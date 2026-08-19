import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streambox/app/theme/app_durations.dart';
import 'package:streambox/app/theme/app_theme.dart';
import 'package:streambox/core/riverpod/app_provider_scope.dart';
import 'package:streambox/features/catalog/data/providers/catalog_providers.dart';
import 'package:streambox/features/player/domain/entities/playback_state.dart';
import 'package:streambox/features/player/presentation/pages/player_page.dart';
import 'package:streambox/features/player/presentation/providers/player_providers.dart';
import 'package:streambox/features/player/presentation/widgets/player_controls.dart';

import '../../../../support/content_fixtures.dart';
import '../../../../support/fake_content_repository.dart';
import '../../../../support/fake_playback_engine.dart';
import '../../../../support/recording_playback_progress_repository.dart';

void main() {
  late FakeContentRepository repository;
  late FakePlaybackEngine engine;
  late RecordingPlaybackProgressRepository progressRepository;

  const contentId = 'the-long-descent';

  /// Opacity of the controls overlay, which is how visibility is expressed.
  double controlsOpacity(WidgetTester tester) => tester
      .widget<AnimatedOpacity>(
        find.ancestor(
          of: find.byType(PlayerControls),
          matching: find.byType(AnimatedOpacity),
        ),
      )
      .opacity;

  bool controlsVisible(WidgetTester tester) => controlsOpacity(tester) == 1;

  Future<void> pumpPlayer(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      AppProviderScope(
        overrides: [
          contentRepositoryProvider.overrideWithValue(repository),
          playbackEngineProvider(contentId).overrideWithValue(engine),
          playbackProgressRepositoryProvider.overrideWithValue(
            progressRepository,
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.dark,
          home: const PlayerPage(
            contentId: contentId,
            title: 'The Long Descent',
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
  }

  setUp(() {
    engine = FakePlaybackEngine();
    progressRepository = RecordingPlaybackProgressRepository();
    repository = FakeContentRepository()
      ..content = buildContent(
        id: contentId,
        streamUrl: 'https://example.invalid/stream.m3u8',
      );
  });

  group('autoplay', () {
    testWidgets('starts playing without a second tap', (tester) async {
      await pumpPlayer(tester);

      expect(engine.playCalls, 1);
      expect(engine.state.isPlaying, isTrue);
    });
  });

  group('control auto-hiding', () {
    testWidgets('controls are visible when playback begins', (tester) async {
      await pumpPlayer(tester);

      expect(controlsVisible(tester), isTrue);
    });

    testWidgets('controls fade once playback has been running', (tester) async {
      await pumpPlayer(tester);

      await tester.pump(AppDurations.controlsAutoHide);
      await tester.pump(AppDurations.medium);

      expect(controlsVisible(tester), isFalse);
    });

    testWidgets('tapping the video brings them back', (tester) async {
      await pumpPlayer(tester);
      await tester.pump(AppDurations.controlsAutoHide);
      await tester.pump(AppDurations.medium);
      expect(controlsVisible(tester), isFalse);

      await tester.tap(find.byType(PlayerPage));
      await tester.pump(AppDurations.medium);

      expect(controlsVisible(tester), isTrue);
    });

    testWidgets('tapping again hides them immediately', (tester) async {
      await pumpPlayer(tester);
      expect(controlsVisible(tester), isTrue);

      // Away from the transport buttons, which sit in the centre: tapping
      // those operates the player rather than dismissing the overlay.
      await tester.tapAt(const Offset(80, 200));
      await tester.pump(AppDurations.medium);

      expect(controlsVisible(tester), isFalse);
    });

    testWidgets('using a control does not dismiss the overlay', (tester) async {
      await pumpPlayer(tester);

      await tester.tap(find.byTooltip('Forward 10 seconds'));
      await tester.pump(AppDurations.medium);

      // Skipping should leave the controls up so the viewer can skip again.
      expect(controlsVisible(tester), isTrue);
    });

    testWidgets('they hide again after a tap if playback continues', (
      tester,
    ) async {
      await pumpPlayer(tester);
      await tester.pump(AppDurations.controlsAutoHide);
      await tester.pump(AppDurations.medium);

      await tester.tap(find.byType(PlayerPage));
      await tester.pump(AppDurations.medium);
      expect(controlsVisible(tester), isTrue);

      await tester.pump(AppDurations.controlsAutoHide);
      await tester.pump(AppDurations.medium);

      expect(controlsVisible(tester), isFalse);
    });

    testWidgets('pausing brings them back and keeps them', (tester) async {
      await pumpPlayer(tester);
      await tester.pump(AppDurations.controlsAutoHide);
      await tester.pump(AppDurations.medium);
      expect(controlsVisible(tester), isFalse);

      engine.emit(engine.state.copyWith(status: PlaybackStatus.paused));
      await tester.pump();
      await tester.pump(AppDurations.medium);
      expect(controlsVisible(tester), isTrue);

      // A paused player must never hide the only way to resume it.
      await tester.pump(AppDurations.controlsAutoHide * 2);
      await tester.pump(AppDurations.medium);

      expect(controlsVisible(tester), isTrue);
    });

    testWidgets('buffering keeps them visible', (tester) async {
      await pumpPlayer(tester);

      engine.emit(engine.state.copyWith(status: PlaybackStatus.buffering));
      await tester.pump();
      await tester.pump(AppDurations.controlsAutoHide * 2);
      await tester.pump(AppDurations.medium);

      expect(controlsVisible(tester), isTrue);
    });

    testWidgets('no timer outlives the screen', (tester) async {
      await pumpPlayer(tester);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(AppDurations.controlsAutoHide * 2);

      // A pending timer after teardown fails the test outright.
      expect(tester.takeException(), isNull);
    });
  });
}
