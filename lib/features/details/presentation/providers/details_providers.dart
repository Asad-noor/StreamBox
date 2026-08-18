import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:streambox/core/result/result.dart';
import 'package:streambox/features/catalog/data/providers/catalog_providers.dart';
import 'package:streambox/features/catalog/domain/entities/content_details.dart';
import 'package:streambox/features/details/domain/usecases/get_content_details.dart';

part 'details_providers.g.dart';

@Riverpod(keepAlive: true)
GetContentDetailsUseCase getContentDetailsUseCase(Ref ref) =>
    GetContentDetailsUseCase(ref.watch(contentRepositoryProvider));

/// The details payload for one title.
///
/// Keyed by identifier, so two details screens on the navigation stack hold
/// their own state and neither invalidates the other. Auto-disposed: leaving
/// the screen releases the record rather than accumulating every title the
/// viewer has ever opened.
@riverpod
class ContentDetailsNotifier extends _$ContentDetailsNotifier {
  @override
  Future<ContentDetails> build(String contentId) => _load(contentId);

  Future<void> retry() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _load(contentId));
  }

  Future<ContentDetails> _load(String id) async {
    final result = await ref.read(getContentDetailsUseCaseProvider).call(id);

    return switch (result) {
      Success(:final value) => value,
      Failure(:final error) => throw error,
    };
  }
}

/// Which season the viewer is looking at.
///
/// Held outside [ContentDetailsNotifier] because it is view state, not data:
/// changing it must not invalidate the loaded record or trigger a refetch.
@riverpod
class SelectedSeason extends _$SelectedSeason {
  @override
  int build(String contentId) => 0;

  void select(int index) => state = index;
}
