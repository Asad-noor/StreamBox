import 'package:flutter_test/flutter_test.dart';
import 'package:streambox/features/player/domain/entities/playback_state.dart';

void main() {
  PlaybackState stateWith({
    Duration position = Duration.zero,
    Duration duration = const Duration(minutes: 10),
    Duration buffered = Duration.zero,
    PlaybackStatus status = PlaybackStatus.paused,
  }) => PlaybackState(
    status: status,
    position: position,
    duration: duration,
    buffered: buffered,
  );

  group('PlaybackState', () {
    test('reports progress as a fraction', () {
      expect(stateWith(position: const Duration(minutes: 5)).progress, 0.5);
      expect(stateWith().progress, 0);
    });

    test('clamps progress beyond the duration', () {
      expect(stateWith(position: const Duration(minutes: 20)).progress, 1.0);
    });

    test('reports zero progress when the duration is unknown', () {
      final live = stateWith(
        position: const Duration(minutes: 3),
        duration: Duration.zero,
      );

      expect(live.hasDuration, isFalse);
      expect(live.progress, 0);
      expect(live.bufferedProgress, 0);
    });

    test('reports buffered progress separately from position', () {
      final state = stateWith(
        position: const Duration(minutes: 1),
        buffered: const Duration(minutes: 4),
      );

      expect(state.progress, closeTo(0.1, 0.001));
      expect(state.bufferedProgress, closeTo(0.4, 0.001));
    });

    test('remaining never goes negative', () {
      expect(
        stateWith(position: const Duration(minutes: 12)).remaining,
        Duration.zero,
      );
      expect(
        stateWith(position: const Duration(minutes: 4)).remaining,
        const Duration(minutes: 6),
      );
    });

    test('treats loading and buffering as waiting', () {
      expect(stateWith(status: PlaybackStatus.loading).isWaiting, isTrue);
      expect(stateWith(status: PlaybackStatus.buffering).isWaiting, isTrue);
      expect(stateWith(status: PlaybackStatus.playing).isWaiting, isFalse);
      expect(stateWith(status: PlaybackStatus.paused).isWaiting, isFalse);
    });

    test('exposes terminal statuses', () {
      expect(stateWith(status: PlaybackStatus.playing).isPlaying, isTrue);
      expect(stateWith(status: PlaybackStatus.completed).isCompleted, isTrue);
      expect(stateWith(status: PlaybackStatus.failed).hasFailed, isTrue);
    });
  });
}
