import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:streambox/core/database/database_provider.dart';
import 'package:streambox/core/result/result.dart';
import 'package:streambox/features/catalog/domain/entities/content.dart';
import 'package:streambox/features/favorites/data/repositories/drift_favorites_repository.dart';
import 'package:streambox/features/favorites/domain/entities/favorite_entry.dart';
import 'package:streambox/features/favorites/domain/repositories/favorites_repository.dart';

part 'favorites_providers.g.dart';

@Riverpod(keepAlive: true)
FavoritesRepository favoritesRepository(Ref ref) =>
    DriftFavoritesRepository(ref.watch(appDatabaseProvider));

/// The saved titles, newest first.
@Riverpod(keepAlive: true)
Stream<List<FavoriteEntry>> favorites(Ref ref) =>
    ref.watch(favoritesRepositoryProvider).watchFavorites();

/// The saved identifiers, kept current by the database.
///
/// Every screen that cares about favourites watches this one provider, so a
/// title saved on the details screen appears on the favourites tab with no
/// coordination between them.
@Riverpod(keepAlive: true)
Stream<Set<String>> favoriteIds(Ref ref) =>
    ref.watch(favoritesRepositoryProvider).watchFavoriteIds();

/// Whether one title is saved. Watching this rather than the whole set keeps a
/// button from rebuilding when an unrelated title is favourited.
@riverpod
bool isFavorite(Ref ref, String contentId) => ref
    .watch(favoriteIdsProvider)
    .maybeWhen(data: (ids) => ids.contains(contentId), orElse: () => false);

/// Applies favourite changes.
///
/// The database stream is the source of truth and re-emits as soon as a write
/// commits, so the button responds without holding its own copy of the state.
/// A failed write is surfaced to the caller rather than swallowed.
@riverpod
class FavoritesController extends _$FavoritesController {
  @override
  void build() {}

  /// Saves or unsaves [content]. Throws the underlying failure so the caller
  /// can tell the viewer that nothing changed.
  Future<void> toggle(Content content) async {
    final repository = ref.read(favoritesRepositoryProvider);
    final isSaved = ref.read(isFavoriteProvider(content.id));

    final result = isSaved
        ? await repository.remove(content.id)
        : await repository.add(content);

    if (result case Failure(:final error)) throw error;
  }

  /// Removes by identifier, for the favourites screen where the full content
  /// is not to hand.
  Future<void> remove(String contentId) async {
    final result = await ref
        .read(favoritesRepositoryProvider)
        .remove(contentId);

    if (result case Failure(:final error)) throw error;
  }
}
