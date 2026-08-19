import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streambox/core/error/app_exception.dart';
import 'package:streambox/core/riverpod/app_provider_scope.dart';
import 'package:streambox/features/catalog/data/providers/catalog_providers.dart';
import 'package:streambox/features/player/domain/entities/playback_progress.dart';
import 'package:streambox/features/player/domain/entities/playback_state.dart';
import 'package:streambox/features/player/presentation/providers/player_providers.dart';

import '../../../../support/content_fixtures.dart';
import '../../../../support/fake_content_repository.dart';
import '../../../../support/fake_playback_engine.dart';
import '../../../../support/recording_playback_progress_repository.dart';

void main() {
  late FakeContentRepository repository;
  late FakePlaybackEngine engine;
  late RecordingPlaybackProgressRepository progressRepository;

  const contentId = 'the-long-descent';
  const streamUrl = 'https://example.invalid/stream.m3u8';

  ProviderContainer buildContainer() {
    final container = createAppProviderContainer(
      overrides: [
        contentRepositoryProvider.overrideWithValue(repository),
        playbackEngineProvider(contentId).overrideWithValue(engine),
        playbackProgressRepositoryProvider.overrideWithValue(
          progressRepository,
        ),
      ],
    );
    addTearDown(container.dispose);
    container.listen(
      playerProvider(contentId),
      (_, _) {},
      fireImmediately: true,
    );

    return container;
  }

  /// Lets the notifier's asynchronous start-up run to completion.
  Future<void> settle() => Future<void>.delayed(Duration.zero);

  setUp(() {
    engine = FakePlaybackEngine();
    progressRepository = RecordingPlaybackProgressRepository();
    repository = FakeContentRepository()
      ..content = buildContent(
        id: contentId,
        title: 'The Long Descent',
        streamUrl: streamUrl,
      );
  });

  group('start-up', () {
    test('begins in a loading state', () {
      expect(
        buildContainer().read(playerProvider(contentId)).status,
        PlaybackStatus.loading,
      );
    });

    test('resolves the title and opens its stream', () async {
      final container = buildContainer();
      await settle();

      expect(engine.loadedUrls, [streamUrl]);
      expect(
        container.read(playerProvider(contentId)).status,
        PlaybackStatus.playing,
      );
    });

    test('starts playing as soon as the stream is ready', () async {
      buildContainer();
      await settle();

      // The viewer arrived by pressing play; asking again is friction.
      expect(engine.playCalls, 1);
    });

    test('does not try to play a stream that failed to open', () async {
      engine.loadFailure = const PlaybackException();
      buildContainer();
      await settle();

      expect(engine.playCalls, 0);
    });

    test('does not try to play when the title cannot be resolved', () async {
      repository.failure = const NotFoundException();
      buildContainer();
      await settle();

      expect(engine.playCalls, 0);
    });

    test('fails when the title cannot be resolved', () async {
      repository.failure = const NotFoundException();
      final container = buildContainer();
      await settle();

      final state = container.read(playerProvider(contentId));
      expect(state.hasFailed, isTrue);
      expect(state.error, isA<NotFoundException>());
      expect(engine.loadedUrls, isEmpty);
    });

    test('fails without attempting playback when there is no stream', () async {
      repository.content = buildContent(id: contentId, streamUrl: null);
      final container = buildContainer();
      await settle();

      final state = container.read(playerProvider(contentId));
      expect(state.error, isA<PlaybackUnavailableException>());
      expect(engine.loadedUrls, isEmpty);
    });

    test('reports an engine load failure', () async {
      engine.loadFailure = const PlaybackException();
      final container = buildContainer();
      await settle();

      expect(container.read(playerProvider(contentId)).hasFailed, isTrue);
    });
  });

  group('transport', () {
    test('republishes engine state', () async {
      final container = buildContainer();
      await settle();

      engine.tickTo(const Duration(minutes: 2));
      await settle();

      final state = container.read(playerProvider(contentId));
      expect(state.position, const Duration(minutes: 2));
      expect(state.isPlaying, isTrue);
    });

    test('toggles between play and pause', () async {
      final container = buildContainer();
      await settle();
      final notifier = container.read(playerProvider(contentId).notifier);

      await notifier.togglePlayPause();
      await settle();
      expect(engine.playCalls, 1);

      await notifier.togglePlayPause();
      await settle();
      expect(engine.pauseCalls, 1);
    });

    test('skip seeks relative to the current position', () async {
      final container = buildContainer();
      await settle();
      engine.tickTo(const Duration(minutes: 5));
      await settle();

      await container
          .read(playerProvider(contentId).notifier)
          .skip(const Duration(seconds: -10));

      expect(engine.seeks.last, const Duration(minutes: 4, seconds: 50));
    });

    test('mute toggles from the current value', () async {
      final container = buildContainer();
      await settle();
      final notifier = container.read(playerProvider(contentId).notifier);

      await notifier.toggleMuted();
      await settle();
      expect(container.read(playerProvider(contentId)).isMuted, isTrue);

      await notifier.toggleMuted();
      await settle();
      expect(container.read(playerProvider(contentId)).isMuted, isFalse);
    });
  });

  group('retry', () {
    test('re-opens the stream from the last reported position', () async {
      final container = buildContainer();
      await settle();

      engine.tickTo(const Duration(minutes: 6));
      await settle();

      engine.emit(
        engine.state.copyWith(
          status: PlaybackStatus.failed,
          error: const PlaybackException(),
        ),
      );
      await settle();
      expect(container.read(playerProvider(contentId)).hasFailed, isTrue);

      engine.loadFailure = null;
      final playsBeforeRetry = engine.playCalls;
      await container.read(playerProvider(contentId).notifier).retry();
      await settle();

      expect(engine.loadedUrls, [streamUrl, streamUrl]);
      // Retry resumes playing rather than leaving a paused player behind.
      expect(engine.playCalls, playsBeforeRetry + 1);
      // Exactly where playback stopped, not the throttled report.
      expect(engine.startPositions.last, const Duration(minutes: 6));
    });

    test('re-resolves the title when the stream was never opened', () async {
      repository.failure = const NetworkException();
      final container = buildContainer();
      await settle();

      repository.failure = null;
      await container.read(playerProvider(contentId).notifier).retry();
      await settle();

      expect(engine.loadedUrls, [streamUrl]);
      expect(container.read(playerProvider(contentId)).hasFailed, isFalse);
    });
  });

  group('progress persistence', () {
    test('does not write for movements below the interval', () async {
      buildContainer();
      await settle();

      for (final seconds in [1, 2, 3, 4]) {
        engine.tickTo(Duration(seconds: seconds));
        await settle();
      }

      expect(progressRepository.entries, isEmpty);
    });

    test('writes once the interval is crossed', () async {
      buildContainer();
      await settle();

      engine.tickTo(const Duration(seconds: 6));
      await settle();

      final saved = progressRepository.entries.single;
      expect(saved.contentId, contentId);
      expect(saved.progress.position, const Duration(seconds: 6));
      expect(saved.progress.duration, engine.loadedDuration);
      // The snapshot travels with the write so history renders offline.
      expect(saved.content.title, 'The Long Descent');
    });

    test('writes at most once per interval during steady playback', () async {
      buildContainer();
      await settle();

      // Twelve one-second ticks should cross the five-second threshold twice.
      for (var second = 1; second <= 12; second++) {
        engine.tickTo(Duration(seconds: second));
        await settle();
      }

      expect(progressRepository.saveCalls, 2);
    });

    test('always writes on completion, however small the final step', () async {
      buildContainer();
      await settle();

      engine.tickTo(const Duration(seconds: 6));
      await settle();
      expect(progressRepository.saveCalls, 1);

      engine.emit(
        engine.state.copyWith(
          position: const Duration(seconds: 7),
          status: PlaybackStatus.completed,
        ),
      );
      await settle();

      expect(progressRepository.saveCalls, 2);
    });

    test('records completion at the full duration', () async {
      buildContainer();
      await settle();

      engine.emit(
        engine.state.copyWith(
          position: const Duration(minutes: 9, seconds: 58),
          status: PlaybackStatus.completed,
        ),
      );
      await settle();

      final saved = progressRepository.entries.single;
      expect(saved.progress.position, engine.loadedDuration);
      expect(saved.progress.isCompleted, isTrue);
    });

    test('does not write while the duration is unknown', () async {
      engine.loadedDuration = Duration.zero;
      buildContainer();
      await settle();

      engine.emit(
        engine.state.copyWith(
          position: const Duration(minutes: 1),
          status: PlaybackStatus.playing,
        ),
      );
      await settle();

      expect(progressRepository.entries, isEmpty);
    });
  });

  group('resume', () {
    test('starts from a stored resume point', () async {
      progressRepository.seed(
        content: buildSnapshot(contentId: contentId),
        progress: PlaybackProgress(
          contentId: contentId,
          position: const Duration(minutes: 4),
          duration: const Duration(minutes: 10),
          updatedAt: DateTime(2026, 8, 19),
        ),
      );

      buildContainer();
      await settle();

      expect(engine.startPositions.single, const Duration(minutes: 4));
    });

    test('starts from the beginning with nothing stored', () async {
      buildContainer();
      await settle();

      expect(engine.startPositions.single, Duration.zero);
    });

    test('ignores a resume point that is effectively finished', () async {
      progressRepository.seed(
        content: buildSnapshot(contentId: contentId),
        progress: PlaybackProgress(
          contentId: contentId,
          position: const Duration(minutes: 10),
          duration: const Duration(minutes: 10),
          updatedAt: DateTime(2026, 8, 19),
        ),
      );

      buildContainer();
      await settle();

      // Replaying a finished title must start at the beginning, not the credits.
      expect(engine.startPositions.single, Duration.zero);
    });
  });

  group('teardown', () {
    test('disposing the container releases the real engine', () async {
      // Deliberately does not override playbackEngineProvider: the point is to
      // prove the provider tears its own engine down, which an override
      // would bypass.
      final container = createAppProviderContainer(
        overrides: [
          contentRepositoryProvider.overrideWithValue(repository),
          playbackProgressRepositoryProvider.overrideWithValue(
            progressRepository,
          ),
        ],
      );

      final realEngine = container.read(playbackEngineProvider(contentId));
      var streamClosed = false;
      realEngine.stateStream.listen(null, onDone: () => streamClosed = true);

      container.dispose();
      await settle();

      // A closed state stream is the observable evidence that the engine
      // released its resources rather than leaking with the screen.
      expect(streamClosed, isTrue);
    });
  });
}
