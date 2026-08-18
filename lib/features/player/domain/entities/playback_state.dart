import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:streambox/core/error/app_exception.dart';

part 'playback_state.freezed.dart';

/// What the engine is currently doing.
enum PlaybackStatus {
  /// Nothing loaded yet.
  idle,

  /// Opening the stream and filling the initial buffer.
  loading,

  /// Ready, not advancing.
  paused,

  /// Advancing.
  playing,

  /// Stalled mid-playback waiting for data. Distinct from [loading] because
  /// the UI keeps the current frame and controls rather than showing a
  /// full-screen spinner.
  buffering,

  /// Reached the end of the stream.
  completed,

  /// Failed. [PlaybackState.error] carries the reason.
  failed,
}

/// An immutable snapshot of the player.
///
/// This is the only playback type the presentation layer sees; nothing above
/// the engine knows which package is producing it.
@freezed
abstract class PlaybackState with _$PlaybackState {
  const factory PlaybackState({
    @Default(PlaybackStatus.idle) PlaybackStatus status,
    @Default(Duration.zero) Duration position,
    @Default(Duration.zero) Duration duration,

    /// How far the stream has buffered ahead.
    @Default(Duration.zero) Duration buffered,

    @Default(1.0) double speed,
    @Default(false) bool isMuted,

    /// Set only when [status] is [PlaybackStatus.failed].
    AppException? error,
  }) = _PlaybackState;

  const PlaybackState._();

  static const PlaybackState initial = PlaybackState();

  bool get isPlaying => status == PlaybackStatus.playing;

  bool get hasFailed => status == PlaybackStatus.failed;

  bool get isCompleted => status == PlaybackStatus.completed;

  /// True while the viewer is waiting on data, whether at start or mid-stream.
  bool get isWaiting =>
      status == PlaybackStatus.loading || status == PlaybackStatus.buffering;

  /// Whether a duration is known, and therefore whether the scrubber and
  /// remaining-time readout mean anything. Live streams report zero.
  bool get hasDuration => duration > Duration.zero;

  /// Watched fraction in `0..1`.
  double get progress {
    if (!hasDuration) return 0;

    return (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0);
  }

  /// Buffered fraction in `0..1`, for the secondary scrubber track.
  double get bufferedProgress {
    if (!hasDuration) return 0;

    return (buffered.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0);
  }

  Duration get remaining {
    final left = duration - position;

    return left.isNegative ? Duration.zero : left;
  }
}
