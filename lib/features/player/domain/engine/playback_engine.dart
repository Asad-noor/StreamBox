import 'package:streambox/features/player/domain/entities/playback_state.dart';

/// The application's view of a video player.
///
/// Every playback capability the app uses is declared here, and exactly one
/// implementation imports the underlying video package. Swapping that package
/// means writing a new implementation of this interface and changing one
/// provider — no screen, notifier or test above this line moves.
///
/// Implementations must be safe to [dispose] more than once, because both the
/// provider and the widget lifecycle can trigger teardown.
abstract interface class PlaybackEngine {
  /// Emits on every meaningful change: status, position, buffer, failure.
  Stream<PlaybackState> get stateStream;

  /// The most recent state, for callers that cannot wait for the stream.
  PlaybackState get state;

  /// Opens [streamUrl] and prepares it for playback.
  ///
  /// [startAt] resumes from a stored position. Implementations seek after the
  /// stream reports a duration, so a resume point beyond the end is clamped
  /// rather than rejected.
  Future<void> load({required String streamUrl, Duration startAt});

  Future<void> play();

  Future<void> pause();

  Future<void> seek(Duration position);

  Future<void> setSpeed(double speed);

  Future<void> setMuted({required bool isMuted});

  /// Releases the platform resources. Idempotent.
  Future<void> dispose();
}
