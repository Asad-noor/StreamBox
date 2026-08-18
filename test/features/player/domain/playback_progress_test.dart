import 'package:flutter_test/flutter_test.dart';
import 'package:streambox/features/player/domain/entities/playback_progress.dart';

void main() {
  PlaybackProgress progressAt(Duration position, {Duration? duration}) =>
      PlaybackProgress(
        contentId: 'a',
        position: position,
        duration: duration ?? const Duration(minutes: 100),
        updatedAt: DateTime(2026, 8, 19),
      );

  group('PlaybackProgress', () {
    test('reports the watched fraction', () {
      expect(progressAt(const Duration(minutes: 25)).fraction, 0.25);
    });

    test('reports zero fraction with no duration', () {
      expect(
        progressAt(
          const Duration(minutes: 5),
          duration: Duration.zero,
        ).fraction,
        0,
      );
    });

    test('treats the last few percent as finished', () {
      expect(progressAt(const Duration(minutes: 94)).isCompleted, isFalse);
      expect(progressAt(const Duration(minutes: 95)).isCompleted, isTrue);
      expect(progressAt(const Duration(minutes: 100)).isCompleted, isTrue);
    });

    test('is resumable only when started and unfinished', () {
      expect(progressAt(Duration.zero).isResumable, isFalse);
      expect(progressAt(const Duration(minutes: 30)).isResumable, isTrue);
      expect(progressAt(const Duration(minutes: 99)).isResumable, isFalse);
    });
  });
}
