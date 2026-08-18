import 'package:streambox/core/result/result.dart';
import 'package:streambox/features/catalog/domain/entities/content.dart';
import 'package:streambox/features/favorites/domain/entities/favorite_entry.dart';

/// Which titles the viewer has saved.
///
/// Backed by the local database. Adding takes the whole [Content] rather than
/// an identifier so a display snapshot can be stored with the entry, which is
/// what lets the favourites screen render with no catalogue access.
abstract interface class FavoritesRepository {
  /// The saved titles, newest first. Re-emits on every change.
  Stream<List<FavoriteEntry>> watchFavorites();

  /// Just the identifiers, for deciding whether one title is saved.
  ///
  /// Separate from [watchFavorites] so a favourite button does not rebuild
  /// whenever an unrelated entry's snapshot is refreshed.
  Stream<Set<String>> watchFavoriteIds();

  Future<Result<Set<String>>> getFavoriteIds();

  Future<Result<void>> add(Content content);

  Future<Result<void>> remove(String contentId);
}
