import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:streambox/core/result/result.dart';
import 'package:streambox/features/catalog/data/providers/catalog_providers.dart';
import 'package:streambox/features/catalog/domain/entities/home_feed.dart';
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
