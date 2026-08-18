import 'package:freezed_annotation/freezed_annotation.dart';

part 'playback_progress.freezed.dart';

/// How far through a title the viewer has watched.
///
/// The unit of resume: written during playback, read back when the same title
/// is opened again, and the basis of the Continue Watching rail.
@freezed
abstract class PlaybackProgress with _$PlaybackProgress {
  const factory PlaybackProgress({
    required String contentId,
    required Duration position,
    required Duration duration,
    required DateTime updatedAt,
  }) = _PlaybackProgress;

  const PlaybackProgress._();

  /// Watched far enough into the end that resuming would be pointless.
  ///
  /// Titles are marked finished slightly before the true end, because credits
  /// mean the last minutes are rarely watched.
  static const double completionThreshold = 0.95;

  double get fraction {
    if (duration <= Duration.zero) return 0;

    return (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0);
  }

  bool get isCompleted => fraction >= completionThreshold;

  /// Whether this belongs in Continue Watching: started, but not finished.
  bool get isResumable => !isCompleted && position > Duration.zero;
}
