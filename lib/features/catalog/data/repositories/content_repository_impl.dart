import 'package:streambox/core/result/result.dart';
import 'package:streambox/features/catalog/data/datasources/content_remote_data_source.dart';
import 'package:streambox/features/catalog/domain/entities/content.dart';
import 'package:streambox/features/catalog/domain/entities/content_section.dart';
import 'package:streambox/features/catalog/domain/entities/home_feed.dart';
import 'package:streambox/features/catalog/domain/repositories/content_repository.dart';

/// Decides where catalogue data comes from and converts it into entities.
///
/// Holds a short-lived in-memory cache of the home feed so that returning to
/// the home tab does not re-issue a request. `forceRefresh` bypasses it, which
/// is what pull-to-refresh uses.
final class ContentRepositoryImpl implements ContentRepository {
  ContentRepositoryImpl({
    required ContentRemoteDataSource remoteDataSource,
    this.cacheTtl = const Duration(minutes: 5),
    this.now = DateTime.now,
    // The lint's suggested fix is illegal: named parameters cannot be private.
    // The data source stays private so it cannot leak past the repository.
    // ignore: prefer_initializing_formals
  }) : _remoteDataSource = remoteDataSource;

  final ContentRemoteDataSource _remoteDataSource;

  /// How long a loaded feed is served without going back to the source.
  final Duration cacheTtl;

  /// Injectable so cache expiry is testable without waiting.
  final DateTime Function() now;

  HomeFeed? _cachedFeed;
  DateTime? _cachedAt;

  @override
  Future<Result<HomeFeed>> getHomeFeed({bool forceRefresh = false}) {
    if (!forceRefresh) {
      if (_freshCachedFeed case final cached?) {
        return Future.value(Success(cached));
      }
    }

    return Result.guard(() async {
      final dto = await _remoteDataSource.fetchHomeFeed();
      final feed = _toHomeFeed(dto);

      _cachedFeed = feed;
      _cachedAt = now();

      return feed;
    });
  }

  @override
  Future<Result<Content>> getContentById(String id) {
    // Serve from the already-loaded feed when possible: opening details from a
    // rail should not wait on a second round trip for data we already hold.
    if (_findInCache(id) case final cached?) {
      return Future.value(Success(cached));
    }

    return Result.guard(() async {
      final model = await _remoteDataSource.fetchContentById(id);
      return model.toEntity();
    });
  }

  HomeFeed? get _freshCachedFeed {
    if (_cachedFeed case final feed?) {
      if (_cachedAt case final cachedAt?) {
        if (now().difference(cachedAt) < cacheTtl) return feed;
      }
    }

    return null;
  }

  Content? _findInCache(String id) {
    final feed = _freshCachedFeed;
    if (feed == null) return null;

    if (feed.featured case final featured? when featured.id == id) {
      return featured;
    }

    for (final section in feed.sections) {
      final match = section.items.where((item) => item.id == id).firstOrNull;
      if (match != null) return match;
    }

    return null;
  }

  HomeFeed _toHomeFeed(HomeFeedDto dto) => HomeFeed(
    featured: dto.featured?.toEntity(),
    sections: dto.sections.map(_toSection).toList(),
  );

  ContentSection _toSection(ContentSectionDto dto) => ContentSection(
    kind: _parseKind(dto.kind),
    title: dto.title,
    items: dto.items.map((model) => model.toEntity()).toList(),
  );

  /// An unrecognised rail is surfaced as [ContentSectionKind.recommended]
  /// rather than dropped, so a new server-side section still reaches users
  /// before the client knows about it.
  static ContentSectionKind _parseKind(String value) =>
      switch (value.toLowerCase()) {
        'continue_watching' => ContentSectionKind.continueWatching,
        'trending' => ContentSectionKind.trending,
        'popular' => ContentSectionKind.popular,
        'new_releases' => ContentSectionKind.newReleases,
        _ => ContentSectionKind.recommended,
      };
}
