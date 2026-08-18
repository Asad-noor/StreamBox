import 'package:streambox/core/result/result.dart';
import 'package:streambox/features/player/domain/entities/playback_progress.dart';
import 'package:streambox/features/player/domain/repositories/playback_progress_repository.dart';

/// Holds resume points for the lifetime of the process.
///
/// A deliberate placeholder, replaced by the database-backed implementation in
/// phase 7. It exists so the player writes through the real contract now.
final class InMemoryPlaybackProgressRepository
    implements PlaybackProgressRepository {
  final Map<String, PlaybackProgress> _entries = {};

  /// Everything stored, newest first. Phase 7's history screen reads the same
  /// ordering from the database.
  List<PlaybackProgress> get entries =>
      _entries.values.toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

  @override
  Future<Result<PlaybackProgress?>> getProgress(String contentId) async =>
      Success(_entries[contentId]);

  @override
  Future<Result<void>> saveProgress(PlaybackProgress progress) async {
    _entries[progress.contentId] = progress;

    return const Success(null);
  }

  @override
  Future<Result<void>> clearProgress(String contentId) async {
    _entries.remove(contentId);

    return const Success(null);
  }
}
