import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:streambox/core/result/result.dart';
import 'package:streambox/features/favorites/data/repositories/in_memory_favorites_repository.dart';
import 'package:streambox/features/favorites/domain/repositories/favorites_repository.dart';

part 'favorites_providers.g.dart';

@Riverpod(keepAlive: true)
FavoritesRepository favoritesRepository(Ref ref) {
  final repository = InMemoryFavoritesRepository();
  ref.onDispose(repository.dispose);

  return repository;
}

/// The set of saved identifiers, kept current by the repository's stream.
///
/// Every screen that cares about favourites watches this one provider, so a
/// title saved on the details screen appears on the favourites tab with no
/// coordination between them.
@Riverpod(keepAlive: true)
Stream<Set<String>> favoriteIds(Ref ref) =>
    ref.watch(favoritesRepositoryProvider).watchFavoriteIds();

/// Whether one title is saved. Watching this rather than the whole set keeps a
/// card from rebuilding when an unrelated title is favourited.
@riverpod
bool isFavorite(Ref ref, String contentId) => ref
    .watch(favoriteIdsProvider)
    .maybeWhen(data: (ids) => ids.contains(contentId), orElse: () => false);

/// Applies favourite changes.
///
/// Toggling is optimistic: the repository stream is the source of truth and
/// updates within a frame, so the button responds immediately. A failed write
/// is surfaced to the caller, which restores the previous state.
@riverpod
class FavoritesController extends _$FavoritesController {
  @override
  void build() {}

  /// Returns the new favourite state, or throws the underlying failure so the
  /// caller can roll its optimistic update back.
  Future<bool> toggle({
    required String contentId,
    required bool isFavorite,
  }) async {
    final repository = ref.read(favoritesRepositoryProvider);

    final result = isFavorite
        ? await repository.remove(contentId)
        : await repository.add(contentId);

    return switch (result) {
      Success() => !isFavorite,
      Failure(:final error) => throw error,
    };
  }
}
