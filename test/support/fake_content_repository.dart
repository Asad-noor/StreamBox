import 'package:streambox/core/error/app_exception.dart';
import 'package:streambox/core/result/result.dart';
import 'package:streambox/features/catalog/domain/entities/content.dart';
import 'package:streambox/features/catalog/domain/entities/content_details.dart';
import 'package:streambox/features/catalog/domain/entities/content_snapshot.dart';
import 'package:streambox/features/catalog/domain/entities/home_feed.dart';
import 'package:streambox/features/catalog/domain/entities/playable.dart';
import 'package:streambox/features/catalog/domain/entities/search_results.dart';
import 'package:streambox/features/catalog/domain/repositories/content_repository.dart';

/// Hand-written stand-in for [ContentRepository].
///
/// Preferred over a generated mock: the call recording is explicit, and the
/// tests read as descriptions of behaviour rather than of a mocking API.
final class FakeContentRepository implements ContentRepository {
  FakeContentRepository({this.feed, this.failure, this.content});

  /// Returned by [searchContent]. Set [searchPages] instead to exercise
  /// pagination across several calls.
  SearchResults? searchResults;

  /// Consumed one entry per [searchContent] call, in order.
  List<SearchResults>? searchPages;

  /// Every `(query, page)` pair [searchContent] was called with.
  final List<({String query, int page})> searchCalls = [];

  /// Delays each [searchContent] response, for testing debounce and staleness.
  Duration searchLatency = Duration.zero;

  /// Returned by [getHomeFeed] when [failure] is null.
  HomeFeed? feed;

  /// Returned by [getContentById] when [failure] is null.
  Content? content;

  /// When set, every call fails with this.
  AppException? failure;

  /// How many times [getHomeFeed] has been called.
  int homeFeedCalls = 0;

  /// The `forceRefresh` argument of each [getHomeFeed] call, in order.
  final List<bool> forceRefreshCalls = [];

  @override
  Future<Result<HomeFeed>> getHomeFeed({bool forceRefresh = false}) async {
    homeFeedCalls++;
    forceRefreshCalls.add(forceRefresh);

    if (failure case final failure?) return Failure(failure);

    return Success(feed!);
  }

  @override
  Future<Result<SearchResults>> searchContent({
    required String query,
    int page = 0,
    int pageSize = 10,
  }) async {
    searchCalls.add((query: query, page: page));

    if (searchLatency > Duration.zero) {
      await Future<void>.delayed(searchLatency);
    }

    if (failure case final failure?) return Failure(failure);

    if (searchPages case final pages? when pages.isNotEmpty) {
      return Success(pages.removeAt(0));
    }

    return Success(searchResults ?? SearchResults.empty);
  }

  /// Returned by [getContentDetails].
  ContentDetails? details;

  /// Every id passed to [getContentDetails], in order.
  final List<String> detailsCalls = [];

  @override
  Future<Result<ContentDetails>> getContentDetails(String id) async {
    detailsCalls.add(id);

    if (failure case final failure?) return Failure(failure);

    return Success(details!);
  }

  /// Returned by [getPlayable]. Defaults to one derived from [content].
  Playable? playable;

  /// Every id passed to [getPlayable], in order.
  final List<String> playableCalls = [];

  @override
  Future<Result<Playable>> getPlayable(String id) async {
    playableCalls.add(id);

    if (failure case final failure?) return Failure(failure);

    if (playable case final playable?) return Success(playable);

    final source = content!;

    return Success(
      Playable(
        id: source.id,
        title: source.title,
        streamUrl: source.streamUrl ?? '',
        snapshot: ContentSnapshot.fromContent(source),
      ),
    );
  }

  @override
  Future<Result<Content>> getContentById(String id) async {
    if (failure case final failure?) return Failure(failure);

    return Success(content!);
  }
}
