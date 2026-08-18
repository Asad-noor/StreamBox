import 'dart:async';

import 'package:streambox/core/error/app_exception.dart';
import 'package:streambox/core/result/result.dart';
import 'package:streambox/features/catalog/domain/entities/content_snapshot.dart';
import 'package:streambox/features/history/domain/entities/watch_history_entry.dart';
import 'package:streambox/features/player/domain/entities/playback_progress.dart';
import 'package:streambox/features/player/domain/repositories/playback_progress_repository.dart';

/// An in-memory [PlaybackProgressRepository] that counts writes.
///
/// Counting is how throttling is verified: the stored value alone cannot
/// distinguish one write from fifty.
final class RecordingPlaybackProgressRepository
    implements PlaybackProgressRepository {
  final Map<String, WatchHistoryEntry> _entries = {};
  final StreamController<List<WatchHistoryEntry>> _controller =
      StreamController<List<WatchHistoryEntry>>.broadcast();

  int saveCalls = 0;

  /// When set, writes fail with this.
  AppException? failure;

  List<WatchHistoryEntry> get entries =>
      _entries.values.toList()
        ..sort((a, b) => b.watchedAt.compareTo(a.watchedAt));

  /// Seeds a resume point without counting as a write.
  void seed({
    required ContentSnapshot content,
    required PlaybackProgress progress,
  }) => _entries[progress.contentId] = WatchHistoryEntry(
    content: content,
    progress: progress,
  );

  @override
  Future<Result<PlaybackProgress?>> getProgress(String contentId) async =>
      Success(_entries[contentId]?.progress);

  @override
  Future<Result<void>> saveProgress({
    required ContentSnapshot content,
    required PlaybackProgress progress,
  }) async {
    saveCalls++;
    if (failure case final failure?) return Failure(failure);

    seed(content: content, progress: progress);

    return const Success(null);
  }

  /// Delivers the current value and the subscription in one synchronous turn,
  /// so no change can slip through the gap.
  @override
  Stream<List<WatchHistoryEntry>> watchHistory() => Stream.multi((controller) {
    controller.add(entries);

    final subscription = _controller.stream.listen(
      controller.add,
      onError: controller.addError,
      onDone: controller.close,
    );

    controller.onCancel = subscription.cancel;
  });

  @override
  Future<Result<void>> clearProgress(String contentId) async {
    if (failure case final failure?) return Failure(failure);

    _entries.remove(contentId);
    _emit();

    return const Success(null);
  }

  @override
  Future<Result<void>> clearAll() async {
    if (failure case final failure?) return Failure(failure);

    _entries.clear();
    _emit();

    return const Success(null);
  }

  Future<void> dispose() => _controller.close();

  void _emit() {
    if (!_controller.isClosed) _controller.add(entries);
  }
}
