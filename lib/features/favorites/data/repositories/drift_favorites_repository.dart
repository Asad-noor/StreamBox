import 'package:streambox/core/database/app_database.dart';
import 'package:streambox/core/error/app_exception.dart';
import 'package:streambox/core/result/result.dart';
import 'package:streambox/features/catalog/domain/entities/content.dart';
import 'package:streambox/features/catalog/domain/entities/content_snapshot.dart';
import 'package:streambox/features/favorites/domain/entities/favorite_entry.dart';
import 'package:streambox/features/favorites/domain/repositories/favorites_repository.dart';

/// Favourites stored in the local database.
///
/// Mapping between rows and entities is confined here: nothing above this file
/// knows the table exists, which is why swapping the in-memory implementation
/// for this one changed no screen and no notifier.
final class DriftFavoritesRepository implements FavoritesRepository {
  DriftFavoritesRepository(this._database, {DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final AppDatabase _database;

  /// Injectable so ordering is deterministic in tests.
  final DateTime Function() _now;

  @override
  Stream<List<FavoriteEntry>> watchFavorites() =>
      _database.watchFavorites().map((rows) => rows.map(_toEntry).toList());

  @override
  Stream<Set<String>> watchFavoriteIds() =>
      _database.watchFavoriteIds().map((ids) => ids.toSet());

  @override
  Future<Result<Set<String>>> getFavoriteIds() => Result.guard(() async {
    final ids = await _database.watchFavoriteIds().first;

    return ids.toSet();
  });

  @override
  Future<Result<void>> add(Content content) => _guardWrite(
    () => _database.upsertFavorite(
      FavoriteEntriesCompanion.insert(
        contentId: content.id,
        title: content.title,
        posterUrl: content.posterUrl,
        releaseYear: content.releaseYear,
        addedAt: _now(),
      ),
    ),
  );

  @override
  Future<Result<void>> remove(String contentId) =>
      _guardWrite(() => _database.deleteFavorite(contentId));

  /// Database failures are reported as [CacheException] rather than escaping
  /// as driver-specific errors, so callers keep dealing in [AppException].
  Future<Result<void>> _guardWrite(Future<void> Function() write) async {
    try {
      await write();

      return const Success(null);
    } on AppException catch (error) {
      return Failure(error);
    } on Object catch (error, stackTrace) {
      return Failure(CacheException(cause: error, stackTrace: stackTrace));
    }
  }

  FavoriteEntry _toEntry(FavoriteEntryRow row) => FavoriteEntry(
    content: ContentSnapshot(
      contentId: row.contentId,
      title: row.title,
      posterUrl: row.posterUrl,
      releaseYear: row.releaseYear,
    ),
    addedAt: row.addedAt,
  );
}
