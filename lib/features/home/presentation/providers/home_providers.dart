import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:streambox/core/result/result.dart';
import 'package:streambox/features/catalog/data/providers/catalog_providers.dart';
import 'package:streambox/features/catalog/domain/entities/content.dart';
import 'package:streambox/features/catalog/domain/entities/content_section.dart';
import 'package:streambox/features/catalog/domain/entities/home_feed.dart';
import 'package:streambox/features/history/presentation/providers/history_providers.dart';
import 'package:streambox/features/home/domain/usecases/get_home_feed.dart';

part 'home_providers.g.dart';

@Riverpod(keepAlive: true)
GetHomeFeedUseCase getHomeFeedUseCase(Ref ref) =>
    GetHomeFeedUseCase(ref.watch(contentRepositoryProvider));

/// Owns the home screen's feed.
///
/// Exposes `AsyncValue<HomeFeed>` so the screen renders through
/// `AsyncValueView` like every other asynchronous surface. The notifier
/// converts the use case's `Result` into an error state rather than letting a
/// failure surface as an unhandled exception.
@riverpod
class HomeFeedNotifier extends _$HomeFeedNotifier {
  @override
  Future<HomeFeed> build() => _load();

  /// Pull-to-refresh. Bypasses the repository cache.
  ///
  /// Deliberately does not move through a loading state: the existing feed
  /// stays on screen until the new one arrives, so the list never collapses
  /// under the user. `RefreshIndicator` provides the progress affordance.
  Future<void> refresh() async {
    state = await AsyncValue.guard(() => _load(forceRefresh: true));
  }

  /// Retry after a failure. Unlike [refresh] there is no previous value worth
  /// preserving, so this goes through a clean loading state.
  Future<void> retry() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_load);
  }

  Future<HomeFeed> _load({bool forceRefresh = false}) async {
    final result = await ref
        .read(getHomeFeedUseCaseProvider)
        .call(forceRefresh: forceRefresh);

    return switch (result) {
      Success(:final value) => value,
      // Rethrown so Riverpod records it as AsyncError; AsyncValueView maps the
      // AppException straight onto the right error UI.
      Failure(:final error) => throw error,
    };
  }
}

/// Resume position per title, keyed by identifier.
///
/// The home rails render summaries; this supplies the watched fraction each
/// card needs without every card reaching into the database itself.
@riverpod
Map<String, double> resumeFractions(Ref ref) => {
  for (final entry in ref.watch(resumableHistoryProvider))
    entry.contentId: entry.progress.fraction,
};

/// The home feed with Continue Watching prepended.
///
/// Composed here rather than in the repository because the catalogue and the
/// viewer's history come from different sources — one remote, one local — and
/// joining them is a presentation concern, not something the catalogue knows
/// how to do.
@riverpod
AsyncValue<HomeFeed> homeFeedWithHistory(Ref ref) {
  final resumable = ref.watch(resumableHistoryProvider);

  return ref.watch(homeFeedProvider).whenData((feed) {
    if (resumable.isEmpty) return feed;

    // Resume entries carry only a snapshot, so the full Content is taken from
    // the feed where available; anything no longer in the catalogue is dropped
    // rather than rendered as a card that cannot be opened.
    final byId = <String, Content>{
      for (final section in feed.sections)
        for (final item in section.items) item.id: item,
      ?feed.featured?.id: ?feed.featured,
    };

    final items = [for (final entry in resumable) ?byId[entry.contentId]];

    if (items.isEmpty) return feed;

    return feed.copyWith(
      sections: [
        ContentSection(
          kind: ContentSectionKind.continueWatching,
          title: 'Continue watching',
          items: items,
        ),
        ...feed.sections,
      ],
    );
  });
}
