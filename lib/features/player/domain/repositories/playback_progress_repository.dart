import 'package:streambox/core/result/result.dart';
import 'package:streambox/features/catalog/domain/entities/content_snapshot.dart';
import 'package:streambox/features/history/domain/entities/watch_history_entry.dart';
import 'package:streambox/features/player/domain/entities/playback_progress.dart';

/// Stores and retrieves resume points, and the watch history built from them.
///
/// Saving requires a [ContentSnapshot] as well as the progress: history has to
/// render titles and artwork without reaching for the catalogue.
abstract interface class PlaybackProgressRepository {
  /// The resume point for one title, or null if it has never been watched.
  Future<Result<PlaybackProgress?>> getProgress(String contentId);

  Future<Result<void>> saveProgress({
    required ContentSnapshot content,
    required PlaybackProgress progress,
  });

  /// Everything watched, newest first. Re-emits on every change.
  Stream<List<WatchHistoryEntry>> watchHistory();

  /// Removes one title from history and from Continue Watching.
  Future<Result<void>> clearProgress(String contentId);

  Future<Result<void>> clearAll();
}
