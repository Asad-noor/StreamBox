import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:streambox/features/catalog/domain/entities/content_snapshot.dart';
import 'package:streambox/features/player/domain/entities/playback_progress.dart';

part 'watch_history_entry.freezed.dart';

/// One row of watch history: a title, and how far through it the viewer got.
///
/// Composes [PlaybackProgress] rather than repeating its fields, so the
/// resumable and completion rules live in exactly one place.
@freezed
abstract class WatchHistoryEntry with _$WatchHistoryEntry {
  const factory WatchHistoryEntry({
    required ContentSnapshot content,
    required PlaybackProgress progress,
  }) = _WatchHistoryEntry;

  const WatchHistoryEntry._();

  String get contentId => content.contentId;

  DateTime get watchedAt => progress.updatedAt;

  /// Belongs in Continue Watching: started, and not effectively finished.
  bool get isResumable => progress.isResumable;
}
