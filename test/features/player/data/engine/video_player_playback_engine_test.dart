import 'package:flutter_test/flutter_test.dart';
import 'package:streambox/core/error/app_exception.dart';
import 'package:streambox/features/player/data/engine/video_player_playback_engine.dart';
import 'package:streambox/features/player/domain/entities/playback_state.dart';
import 'package:video_player/video_player.dart';

import '../../../../support/fake_video_player_controller.dart';

void main() {
  late VideoPlayerPlaybackEngine engine;

  /// Every controller the engine has asked for, in order.
  late List<FakeVideoPlayerController> created;

  /// The most recent one, which is the live controller.
  FakeVideoPlayerController controller() => created.last;

  const streamUrl = 'https://example.invalid/stream.m3u8';

  VideoPlayerPlaybackEngine buildEngine({
    Duration duration = const Duration(minutes: 10),
    bool failOnInitialize = false,
  }) {
    created = [];

    // A fresh controller per call, exactly as the real factory does, so
    // reloading is genuinely exercised.
    return VideoPlayerPlaybackEngine(
      controllerFactory: (_) {
        final next = FakeVideoPlayerController(
          duration: duration,
          failOnInitialize: failOnInitialize,
        );
        created.add(next);

        return next;
      },
    );
  }

  setUp(() {
    engine = buildEngine();
  });

  tearDown(() => engine.dispose());

  group('load', () {
    test('reports loading, then ready with a duration', () async {
      final states = <PlaybackStatus>[];
      engine.stateStream.listen((state) => states.add(state.status));

      await engine.load(streamUrl: streamUrl);
      await pumpEventQueue();

      expect(states.first, PlaybackStatus.loading);
      expect(engine.state.status, PlaybackStatus.paused);
      expect(engine.state.duration, const Duration(minutes: 10));
    });

    test('seeks to a stored resume point', () async {
      await engine.load(
        streamUrl: streamUrl,
        startAt: const Duration(minutes: 4),
      );

      expect(controller().seeks, [const Duration(minutes: 4)]);
    });

    test('ignores a resume point beyond the end of the stream', () async {
      await engine.load(
        streamUrl: streamUrl,
        startAt: const Duration(minutes: 99),
      );

      // Clamped to the start rather than rejected, so a stream whose length
      // changed does not fail to open at all.
      expect(controller().seeks, [Duration.zero]);
    });

    test('does not seek when starting from the beginning', () async {
      await engine.load(streamUrl: streamUrl);

      expect(controller().seeks, isEmpty);
    });

    test('reports a failure to open as a PlaybackException', () async {
      engine = buildEngine(failOnInitialize: true);

      await engine.load(streamUrl: streamUrl);

      expect(engine.state.status, PlaybackStatus.failed);
      expect(engine.state.error, isA<PlaybackException>());
    });

    test('releases the previous controller when reloading', () async {
      await engine.load(streamUrl: streamUrl);
      final first = controller();

      await engine.load(streamUrl: streamUrl);

      expect(created, hasLength(2));
      expect(first.disposed, isTrue);
      expect(identical(controller(), first), isFalse);
    });
  });

  group('status mapping', () {
    setUp(() async {
      await engine.load(streamUrl: streamUrl);
    });

    test('playing and paused follow the controller', () async {
      await engine.play();
      expect(engine.state.status, PlaybackStatus.playing);

      await engine.pause();
      expect(engine.state.status, PlaybackStatus.paused);
    });

    test('buffering is reported only while playing', () {
      controller().tickTo(const Duration(minutes: 1), isBuffering: true);
      expect(engine.state.status, PlaybackStatus.buffering);

      // A paused player filling its buffer must not flash a spinner over the
      // controls, so it stays paused.
      controller().tickTo(
        const Duration(minutes: 1),
        isPlaying: false,
        isBuffering: true,
      );
      expect(engine.state.status, PlaybackStatus.paused);
    });

    test('completion is reported when the stream ends', () {
      controller().emit(
        controller().value.copyWith(
          position: const Duration(minutes: 10),
          isCompleted: true,
        ),
      );

      expect(engine.state.status, PlaybackStatus.completed);
      expect(engine.state.isCompleted, isTrue);
    });

    test('a platform error becomes a PlaybackException', () {
      controller().fail('decoder gave up');

      expect(engine.state.status, PlaybackStatus.failed);
      expect(engine.state.error, isA<PlaybackException>());
      expect(engine.state.error?.cause, 'decoder gave up');
    });

    test('position and speed are republished', () async {
      controller().tickTo(const Duration(minutes: 3));
      expect(engine.state.position, const Duration(minutes: 3));

      await engine.setSpeed(1.5);
      expect(engine.state.speed, 1.5);
    });

    test('muting sets the volume to zero and back', () async {
      await engine.setMuted(isMuted: true);
      expect(engine.state.isMuted, isTrue);

      await engine.setMuted(isMuted: false);
      expect(engine.state.isMuted, isFalse);
    });
  });

  group('buffered range', () {
    setUp(() async {
      await engine.load(streamUrl: streamUrl);
    });

    test('reports the end of the range containing the playhead', () {
      controller().tickTo(
        const Duration(minutes: 2),
        buffered: [
          DurationRange(Duration.zero, const Duration(minutes: 4)),
          DurationRange(const Duration(minutes: 6), const Duration(minutes: 8)),
        ],
      );

      // The later range is not reachable from here, so it must not be shown
      // as buffered.
      expect(engine.state.buffered, const Duration(minutes: 4));
    });

    test('falls back to the first range when the playhead is in a gap', () {
      controller().tickTo(
        const Duration(minutes: 5),
        buffered: [DurationRange(Duration.zero, const Duration(minutes: 4))],
      );

      expect(engine.state.buffered, const Duration(minutes: 4));
    });

    test('reports nothing buffered when the stream reports no ranges', () {
      controller().tickTo(const Duration(minutes: 1));

      expect(engine.state.buffered, Duration.zero);
    });
  });

  group('seek', () {
    setUp(() async {
      await engine.load(streamUrl: streamUrl);
    });

    test('clamps a negative target to the start', () async {
      await engine.seek(const Duration(seconds: -30));

      expect(controller().seeks.last, Duration.zero);
    });

    test('clamps a target past the end to the duration', () async {
      await engine.seek(const Duration(minutes: 99));

      expect(controller().seeks.last, const Duration(minutes: 10));
    });

    test('passes a valid target through', () async {
      await engine.seek(const Duration(minutes: 6));

      expect(controller().seeks.last, const Duration(minutes: 6));
    });

    test('replaying a completed stream restarts it', () async {
      controller().emit(controller().value.copyWith(isCompleted: true));

      await engine.play();

      expect(controller().seeks, contains(Duration.zero));
    });
  });

  group('lifecycle', () {
    test('transport calls before load are safe no-ops', () async {
      await engine.play();
      await engine.pause();
      await engine.seek(const Duration(minutes: 1));
      await engine.setSpeed(2);

      expect(engine.state.status, PlaybackStatus.idle);
    });

    test('dispose closes the stream and releases the controller', () async {
      await engine.load(streamUrl: streamUrl);

      var closed = false;
      engine.stateStream.listen(null, onDone: () => closed = true);

      await engine.dispose();
      await pumpEventQueue();

      expect(controller().disposed, isTrue);
      expect(closed, isTrue);
    });

    test('dispose is idempotent', () async {
      await engine.load(streamUrl: streamUrl);

      await engine.dispose();

      // Both the provider and the widget lifecycle can trigger teardown.
      await expectLater(engine.dispose(), completes);
    });

    test('loading after dispose does nothing', () async {
      await engine.dispose();

      await engine.load(streamUrl: streamUrl);

      expect(engine.state.status, PlaybackStatus.idle);
    });
  });
}
