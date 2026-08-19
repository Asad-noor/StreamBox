import 'package:video_player/video_player.dart';

/// A [VideoPlayerController] with no platform behind it.
///
/// Lets [VideoPlayerPlaybackEngine] be tested for real: the mapping from
/// `VideoPlayerValue` onto the application's own playback state is the
/// trickiest code in the player, and it is exactly what a fake *engine*
/// cannot exercise.
class FakeVideoPlayerController extends VideoPlayerController {
  FakeVideoPlayerController({
    this.duration = const Duration(minutes: 10),
    this.failOnInitialize = false,
  }) : super.networkUrl(Uri.parse('https://example.invalid/stream.m3u8'));

  final Duration duration;
  final bool failOnInitialize;

  bool disposed = false;
  final List<Duration> seeks = [];
  int playCalls = 0;
  int pauseCalls = 0;

  @override
  Future<void> initialize() async {
    if (failOnInitialize) throw Exception('could not open the stream');

    value = value.copyWith(duration: duration, isInitialized: true);
  }

  @override
  Future<void> play() async {
    playCalls++;
    value = value.copyWith(isPlaying: true);
  }

  @override
  Future<void> pause() async {
    pauseCalls++;
    value = value.copyWith(isPlaying: false);
  }

  @override
  Future<void> seekTo(Duration position) async {
    seeks.add(position);
    value = value.copyWith(position: position);
  }

  @override
  Future<void> setPlaybackSpeed(double speed) async {
    value = value.copyWith(playbackSpeed: speed);
  }

  @override
  Future<void> setVolume(double volume) async {
    value = value.copyWith(volume: volume);
  }

  /// Safe to delegate: the real `dispose` only reaches the platform when the
  /// real `initialize` ran, and this fake replaces it.
  @override
  Future<void> dispose() async {
    disposed = true;
    await super.dispose();
  }

  /// Drives the controller the way the platform would.
  void emit(VideoPlayerValue next) => value = next;

  /// Convenience for the common case of advancing playback.
  void tickTo(
    Duration position, {
    bool isPlaying = true,
    bool isBuffering = false,
    List<DurationRange> buffered = const [],
  }) => value = value.copyWith(
    position: position,
    isPlaying: isPlaying,
    isBuffering: isBuffering,
    buffered: buffered,
  );

  /// Reports a platform error the way the real controller does.
  void fail(String description) =>
      value = VideoPlayerValue.erroneous(description);
}
