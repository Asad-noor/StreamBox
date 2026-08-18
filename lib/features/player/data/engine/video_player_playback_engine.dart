import 'dart:async';

import 'package:streambox/core/error/app_exception.dart';
import 'package:streambox/features/player/domain/engine/playback_engine.dart';
import 'package:streambox/features/player/domain/entities/playback_state.dart';
import 'package:video_player/video_player.dart';

/// Creates the controller for a URL. Injectable so tests can substitute one.
typedef VideoControllerFactory =
    VideoPlayerController Function(String streamUrl);

/// [PlaybackEngine] backed by `package:video_player`.
///
/// The only file in the application that imports the video package. HLS and
/// adaptive bitrate are delegated to the platform — Media3/ExoPlayer on
/// Android, AVPlayer on iOS — which is why no manifest or bitrate handling
/// appears here.
final class VideoPlayerPlaybackEngine implements PlaybackEngine {
  VideoPlayerPlaybackEngine({VideoControllerFactory? controllerFactory})
    : _createController =
          controllerFactory ??
          ((url) => VideoPlayerController.networkUrl(Uri.parse(url)));

  final VideoControllerFactory _createController;

  final StreamController<PlaybackState> _states =
      StreamController<PlaybackState>.broadcast();

  VideoPlayerController? _controller;
  PlaybackState _state = PlaybackState.initial;
  bool _disposed = false;

  @override
  Stream<PlaybackState> get stateStream => _states.stream;

  @override
  PlaybackState get state => _state;

  @override
  Future<void> load({
    required String streamUrl,
    Duration startAt = Duration.zero,
  }) async {
    if (_disposed) return;

    await _releaseController();
    _emit(PlaybackState.initial.copyWith(status: PlaybackStatus.loading));

    final controller = _createController(streamUrl);
    _controller = controller;

    try {
      await controller.initialize();

      // A stored position from a previous session can exceed the current
      // duration if the stream changed; clamp rather than fail the load.
      if (startAt > Duration.zero) {
        final target = startAt < controller.value.duration
            ? startAt
            : Duration.zero;
        await controller.seekTo(target);
      }

      // Attached only after initialize, so a mid-initialisation tick cannot
      // publish a half-configured state.
      controller.addListener(_onControllerChanged);
      _onControllerChanged();
    } on Object catch (error, stackTrace) {
      _emitFailure(error, stackTrace);
    }
  }

  @override
  Future<void> play() async {
    if (_state.isCompleted) await _controller?.seekTo(Duration.zero);

    await _controller?.play();
  }

  @override
  Future<void> pause() => _controller?.pause() ?? Future.value();

  @override
  Future<void> seek(Duration position) async {
    final controller = _controller;
    if (controller == null) return;

    final duration = controller.value.duration;
    final target = position.isNegative
        ? Duration.zero
        : (position > duration ? duration : position);

    await controller.seekTo(target);
  }

  @override
  Future<void> setSpeed(double speed) =>
      _controller?.setPlaybackSpeed(speed) ?? Future.value();

  @override
  Future<void> setMuted({required bool isMuted}) =>
      _controller?.setVolume(isMuted ? 0 : 1) ?? Future.value();

  @override
  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;

    await _releaseController();
    await _states.close();
  }

  /// The live controller, for the render surface. Null until [load] succeeds.
  ///
  /// Deliberately not on [PlaybackEngine]: it is a package type, so only the
  /// widget that renders the video is allowed to reach for it, and it does so
  /// through this concrete class.
  VideoPlayerController? get controller => _controller;

  Future<void> _releaseController() async {
    final controller = _controller;
    if (controller == null) return;

    _controller = null;
    controller.removeListener(_onControllerChanged);
    await controller.dispose();
  }

  void _onControllerChanged() {
    final controller = _controller;
    if (controller == null || _disposed) return;

    final value = controller.value;

    if (value.hasError) {
      _emitFailure(value.errorDescription ?? 'Playback failed', null);
      return;
    }

    _emit(
      _state.copyWith(
        status: _statusFrom(value),
        position: value.position,
        duration: value.duration,
        buffered: _bufferedEnd(value),
        speed: value.playbackSpeed,
        isMuted: value.volume == 0,
        error: null,
      ),
    );
  }

  PlaybackStatus _statusFrom(VideoPlayerValue value) {
    if (!value.isInitialized) return PlaybackStatus.loading;
    if (value.isCompleted) return PlaybackStatus.completed;

    // Buffering is only reported while playing: a paused player that is
    // filling its buffer should not flash a spinner over the controls.
    if (value.isBuffering && value.isPlaying) return PlaybackStatus.buffering;

    return value.isPlaying ? PlaybackStatus.playing : PlaybackStatus.paused;
  }

  /// The furthest continuously buffered point, which is what a progress bar
  /// should show. Later ranges after a gap are not yet playable from here.
  Duration _bufferedEnd(VideoPlayerValue value) {
    if (value.buffered.isEmpty) return Duration.zero;

    for (final range in value.buffered) {
      if (range.start <= value.position && range.end >= value.position) {
        return range.end;
      }
    }

    return value.buffered.first.end;
  }

  void _emit(PlaybackState state) {
    _state = state;
    if (!_states.isClosed) _states.add(state);
  }

  void _emitFailure(Object error, StackTrace? stackTrace) => _emit(
    _state.copyWith(
      status: PlaybackStatus.failed,
      error: PlaybackException(cause: error, stackTrace: stackTrace),
    ),
  );
}
