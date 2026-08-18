import 'dart:async';

import 'package:streambox/core/error/app_exception.dart';
import 'package:streambox/features/player/domain/engine/playback_engine.dart';
import 'package:streambox/features/player/domain/entities/playback_state.dart';

/// A [PlaybackEngine] with no platform behind it.
///
/// This is what the engine abstraction buys: the player's business logic —
/// lifecycle, retry, throttled progress, seek clamping — is exercised in plain
/// unit tests with no video package, no texture and no method channel.
final class FakePlaybackEngine implements PlaybackEngine {
  final StreamController<PlaybackState> _states =
      StreamController<PlaybackState>.broadcast();

  PlaybackState _state = PlaybackState.initial;

  /// When set, [load] reports this failure instead of becoming ready.
  AppException? loadFailure;

  /// Duration reported once loaded.
  Duration loadedDuration = const Duration(minutes: 10);

  final List<String> loadedUrls = [];
  final List<Duration> startPositions = [];
  final List<Duration> seeks = [];
  int playCalls = 0;
  int pauseCalls = 0;
  bool disposed = false;

  @override
  Stream<PlaybackState> get stateStream => _states.stream;

  @override
  PlaybackState get state => _state;

  @override
  Future<void> load({
    required String streamUrl,
    Duration startAt = Duration.zero,
  }) async {
    loadedUrls.add(streamUrl);
    startPositions.add(startAt);

    if (loadFailure case final failure?) {
      emit(_state.copyWith(status: PlaybackStatus.failed, error: failure));
      return;
    }

    emit(
      PlaybackState.initial.copyWith(
        status: PlaybackStatus.paused,
        duration: loadedDuration,
        position: startAt,
      ),
    );
  }

  @override
  Future<void> play() async {
    playCalls++;
    emit(_state.copyWith(status: PlaybackStatus.playing));
  }

  @override
  Future<void> pause() async {
    pauseCalls++;
    emit(_state.copyWith(status: PlaybackStatus.paused));
  }

  @override
  Future<void> seek(Duration position) async {
    seeks.add(position);
    emit(_state.copyWith(position: position));
  }

  @override
  Future<void> setSpeed(double speed) async =>
      emit(_state.copyWith(speed: speed));

  @override
  Future<void> setMuted({required bool isMuted}) async =>
      emit(_state.copyWith(isMuted: isMuted));

  @override
  Future<void> dispose() async {
    if (disposed) return;
    disposed = true;
    await _states.close();
  }

  /// Drives the engine from a test, standing in for the platform ticking.
  void emit(PlaybackState next) {
    _state = next;
    if (!_states.isClosed) _states.add(next);
  }

  /// Convenience for advancing playback position.
  void tickTo(Duration position, {PlaybackStatus? status}) => emit(
    _state.copyWith(
      position: position,
      status: status ?? PlaybackStatus.playing,
      duration: loadedDuration,
    ),
  );
}
