import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:streambox/core/database/tables.dart';

part 'app_database.g.dart';

/// The application's local database.
///
/// Exposes `watch*` queries returning streams, which is what lets the
/// favourites and history screens update the moment anything writes without
/// either screen knowing where the write came from.
@DriftDatabase(tables: [FavoriteEntries, PlaybackProgressEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// An isolated database that never touches the file system.
  ///
  /// Every persistence test runs against this, so the tests exercise real
  /// SQLite and real SQL rather than a hand-written stand-in.
  AppDatabase.forTesting(super.connection);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
    beforeOpen: (details) async {
      // Off by default in SQLite, and required for any future foreign keys to
      // be enforced rather than silently ignored.
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  // ---------------------------------------------------------------------------
  // Favourites
  // ---------------------------------------------------------------------------

  Stream<List<FavoriteEntryRow>> watchFavorites() =>
      (select(favoriteEntries)..orderBy([
            (entry) => OrderingTerm(
              expression: entry.addedAt,
              mode: OrderingMode.desc,
            ),
          ]))
          .watch();

  Stream<List<String>> watchFavoriteIds() =>
      (selectOnly(favoriteEntries)..addColumns([favoriteEntries.contentId]))
          .map((row) => row.read(favoriteEntries.contentId)!)
          .watch();

  Future<void> upsertFavorite(FavoriteEntriesCompanion entry) =>
      into(favoriteEntries).insertOnConflictUpdate(entry);

  Future<void> deleteFavorite(String contentId) => (delete(
    favoriteEntries,
  )..where((e) => e.contentId.equals(contentId))).go();

  // ---------------------------------------------------------------------------
  // Playback progress
  // ---------------------------------------------------------------------------

  /// Newest first, which is the order the history screen shows.
  Stream<List<PlaybackProgressRow>> watchProgress() =>
      (select(playbackProgressEntries)..orderBy([
            (entry) => OrderingTerm(
              expression: entry.updatedAt,
              mode: OrderingMode.desc,
            ),
          ]))
          .watch();

  Future<PlaybackProgressRow?> progressFor(String contentId) => (select(
    playbackProgressEntries,
  )..where((e) => e.contentId.equals(contentId))).getSingleOrNull();

  Future<void> upsertProgress(PlaybackProgressEntriesCompanion entry) =>
      into(playbackProgressEntries).insertOnConflictUpdate(entry);

  Future<void> deleteProgress(String contentId) => (delete(
    playbackProgressEntries,
  )..where((e) => e.contentId.equals(contentId))).go();

  Future<void> clearProgress() => delete(playbackProgressEntries).go();
}

QueryExecutor _openConnection() =>
    driftDatabase(name: 'streambox', native: const DriftNativeOptions());
