import 'package:drift/drift.dart';

/// Titles the viewer has saved.
///
/// Carries a snapshot of the title's display fields so the favourites screen
/// renders with no catalogue access. The snapshot is rewritten whenever the
/// entry is touched.
@DataClassName('FavoriteEntryRow')
class FavoriteEntries extends Table {
  TextColumn get contentId => text()();

  TextColumn get title => text()();
  TextColumn get posterUrl => text()();
  IntColumn get releaseYear => integer()();

  DateTimeColumn get addedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {contentId};
}

/// Where the viewer stopped watching each title.
///
/// One row per title: resuming updates in place rather than appending, so the
/// table stays proportional to what has been watched, not to how long.
///
/// Durations are stored in milliseconds because SQLite has no duration type;
/// the mapping is confined to the repository.
@DataClassName('PlaybackProgressRow')
class PlaybackProgressEntries extends Table {
  TextColumn get contentId => text()();

  IntColumn get positionMs => integer()();
  IntColumn get durationMs => integer()();

  TextColumn get title => text()();
  TextColumn get posterUrl => text()();
  IntColumn get releaseYear => integer()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {contentId};
}
