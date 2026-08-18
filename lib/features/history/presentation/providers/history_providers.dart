import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:streambox/core/result/result.dart';
import 'package:streambox/features/history/domain/entities/watch_history_entry.dart';
import 'package:streambox/features/player/presentation/providers/player_providers.dart';

part 'history_providers.g.dart';

/// Everything watched, newest first.
@Riverpod(keepAlive: true)
Stream<List<WatchHistoryEntry>> watchHistory(Ref ref) =>
    ref.watch(playbackProgressRepositoryProvider).watchHistory();

/// The subset that belongs in Continue Watching: started, and not finished.
///
/// Derived here rather than in the home feed so the rule lives in one place
/// and both screens agree on what "resumable" means.
@Riverpod(keepAlive: true)
List<WatchHistoryEntry> resumableHistory(Ref ref) => ref
    .watch(watchHistoryProvider)
    .maybeWhen(
      data: (entries) => entries.where((entry) => entry.isResumable).toList(),
      orElse: () => const [],
    );

/// Removes entries from history.
@riverpod
class HistoryController extends _$HistoryController {
  @override
  void build() {}

  Future<void> remove(String contentId) async {
    final result = await ref
        .read(playbackProgressRepositoryProvider)
        .clearProgress(contentId);

    if (result case Failure(:final error)) throw error;
  }

  Future<void> clearAll() async {
    final result = await ref
        .read(playbackProgressRepositoryProvider)
        .clearAll();

    if (result case Failure(:final error)) throw error;
  }
}
