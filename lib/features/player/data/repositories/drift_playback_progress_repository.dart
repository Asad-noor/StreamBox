import 'package:streambox/core/database/app_database.dart';
import 'package:streambox/core/error/app_exception.dart';
import 'package:streambox/core/result/result.dart';
import 'package:streambox/features/catalog/domain/entities/content_snapshot.dart';
import 'package:streambox/features/history/domain/entities/watch_history_entry.dart';
import 'package:streambox/features/player/domain/entities/playback_progress.dart';
import 'package:streambox/features/player/domain/repositories/playback_progress_repository.dart';

/// Resume points and watch history stored in the local database.
///
/// SQLite has no duration type, so durations are held as milliseconds and
/// converted here — the only place that conversion appears.
final class DriftPlaybackProgressRepository
    implements PlaybackProgressRepository {
  const DriftPlaybackProgressRepository(this._database);

  final AppDatabase _database;

  @override
  Future<Result<PlaybackProgress?>> getProgress(String contentId) =>
      Result.guard(() async {
        final row = await _database.progressFor(contentId);

        return row == null ? null : _toProgress(row);
      });

  @override
  Future<Result<void>> saveProgress({
    required ContentSnapshot content,
    required PlaybackProgress progress,
  }) => _guardWrite(
    () => _database.upsertProgress(
      PlaybackProgressEntriesCompanion.insert(
        contentId: progress.contentId,
        positionMs: progress.position.inMilliseconds,
        durationMs: progress.duration.inMilliseconds,
        title: content.title,
        posterUrl: content.posterUrl,
        releaseYear: content.releaseYear,
        updatedAt: progress.updatedAt,
      ),
    ),
  );

  @override
  Stream<List<WatchHistoryEntry>> watchHistory() =>
      _database.watchProgress().map((rows) => rows.map(_toEntry).toList());

  @override
  Future<Result<void>> clearProgress(String contentId) =>
      _guardWrite(() => _database.deleteProgress(contentId));

  @override
  Future<Result<void>> clearAll() => _guardWrite(_database.clearProgress);

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

  PlaybackProgress _toProgress(PlaybackProgressRow row) => PlaybackProgress(
    contentId: row.contentId,
    position: Duration(milliseconds: row.positionMs),
    duration: Duration(milliseconds: row.durationMs),
    updatedAt: row.updatedAt,
  );

  WatchHistoryEntry _toEntry(PlaybackProgressRow row) => WatchHistoryEntry(
    content: ContentSnapshot(
      contentId: row.contentId,
      title: row.title,
      posterUrl: row.posterUrl,
      releaseYear: row.releaseYear,
    ),
    progress: _toProgress(row),
  );
}
