import 'package:streambox/core/result/result.dart';
import 'package:streambox/features/player/data/repositories/in_memory_playback_progress_repository.dart';
import 'package:streambox/features/player/domain/entities/playback_progress.dart';
import 'package:streambox/features/player/domain/repositories/playback_progress_repository.dart';

/// The in-memory store, wrapped to count writes.
///
/// Composed rather than subclassed: the production class is `final` on
/// purpose, and counting writes is how throttling is verified — the stored
/// value alone cannot distinguish one write from fifty.
final class RecordingPlaybackProgressRepository
    implements PlaybackProgressRepository {
  final InMemoryPlaybackProgressRepository _delegate =
      InMemoryPlaybackProgressRepository();

  int saveCalls = 0;

  List<PlaybackProgress> get entries => _delegate.entries;

  @override
  Future<Result<PlaybackProgress?>> getProgress(String contentId) =>
      _delegate.getProgress(contentId);

  @override
  Future<Result<void>> saveProgress(PlaybackProgress progress) {
    saveCalls++;

    return _delegate.saveProgress(progress);
  }

  @override
  Future<Result<void>> clearProgress(String contentId) =>
      _delegate.clearProgress(contentId);
}
