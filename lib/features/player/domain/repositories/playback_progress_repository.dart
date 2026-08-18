import 'package:streambox/core/result/result.dart';
import 'package:streambox/features/player/domain/entities/playback_progress.dart';

/// Stores and retrieves resume points.
///
/// Backed by an in-memory store today and by the local database in phase 7.
/// Declaring the contract now means the player already writes through it, so
/// adding persistence is a provider swap rather than a change to playback.
abstract interface class PlaybackProgressRepository {
  Future<Result<PlaybackProgress?>> getProgress(String contentId);

  Future<Result<void>> saveProgress(PlaybackProgress progress);

  /// Called when a title is watched to the end: it should stop appearing in
  /// Continue Watching.
  Future<Result<void>> clearProgress(String contentId);
}
