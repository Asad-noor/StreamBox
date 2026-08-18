import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streambox/features/player/domain/entities/playback_state.dart';
import 'package:streambox/features/player/presentation/widgets/playback_scrubber.dart';
import 'package:streambox/features/player/presentation/widgets/player_controls.dart';

import '../../../../support/widget_harness.dart';

void main() {
  late List<String> events;
  late List<Duration> seeks;
  late List<Duration> skips;

  Widget controlsFor(PlaybackState state, {bool isFullscreen = false}) =>
      PlayerControls(
        state: state,
        title: 'The Long Descent',
        isFullscreen: isFullscreen,
        onTogglePlayPause: () => events.add('toggle'),
        onSeek: seeks.add,
        onSkip: skips.add,
        onToggleMuted: () => events.add('mute'),
        onToggleFullscreen: () => events.add('fullscreen'),
        onBack: () => events.add('back'),
      );

  const playing = PlaybackState(
    status: PlaybackStatus.playing,
    position: Duration(minutes: 2),
    duration: Duration(minutes: 10),
    buffered: Duration(minutes: 4),
  );

  setUp(() {
    events = [];
    seeks = [];
    skips = [];
  });

  group('PlayerControls', () {
    testWidgets('shows the title', (tester) async {
      await tester.pumpInApp(controlsFor(playing));

      expect(find.text('The Long Descent'), findsOneWidget);
    });

    testWidgets('shows pause while playing and play while paused', (
      tester,
    ) async {
      await tester.pumpInApp(controlsFor(playing));
      expect(find.byTooltip('Pause'), findsOneWidget);

      await tester.pumpInApp(
        controlsFor(playing.copyWith(status: PlaybackStatus.paused)),
      );
      expect(find.byTooltip('Play'), findsOneWidget);
    });

    testWidgets('offers replay once completed', (tester) async {
      await tester.pumpInApp(
        controlsFor(playing.copyWith(status: PlaybackStatus.completed)),
      );

      expect(find.byTooltip('Replay'), findsOneWidget);
    });

    testWidgets('replaces the button with a spinner while buffering', (
      tester,
    ) async {
      await tester.pumpInApp(
        controlsFor(playing.copyWith(status: PlaybackStatus.buffering)),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byTooltip('Pause'), findsNothing);
    });

    testWidgets('reports transport interactions', (tester) async {
      await tester.pumpInApp(controlsFor(playing));

      await tester.tap(find.byTooltip('Pause'));
      await tester.tap(find.byTooltip('Back'));
      await tester.tap(find.byTooltip('Mute'));
      await tester.tap(find.byTooltip('Full screen'));
      await tester.pump();

      expect(events, ['toggle', 'back', 'mute', 'fullscreen']);
    });

    testWidgets('skips by ten seconds in both directions', (tester) async {
      await tester.pumpInApp(controlsFor(playing));

      await tester.tap(find.byTooltip('Back 10 seconds'));
      await tester.tap(find.byTooltip('Forward 10 seconds'));
      await tester.pump();

      expect(skips, [
        const Duration(seconds: -10),
        const Duration(seconds: 10),
      ]);
    });

    testWidgets('reflects the muted state in its icon and label', (
      tester,
    ) async {
      await tester.pumpInApp(controlsFor(playing.copyWith(isMuted: true)));

      expect(find.byTooltip('Unmute'), findsOneWidget);
      expect(find.byIcon(Icons.volume_off_rounded), findsOneWidget);
    });

    testWidgets('offers to leave full screen when in it', (tester) async {
      await tester.pumpInApp(controlsFor(playing, isFullscreen: true));

      expect(find.byTooltip('Exit full screen'), findsOneWidget);
    });

    testWidgets('shows elapsed and remaining time', (tester) async {
      await tester.pumpInApp(controlsFor(playing));

      expect(find.text('2:00'), findsOneWidget);
      expect(find.text('-8:00'), findsOneWidget);
    });

    testWidgets('hides the scrubber for a stream with no duration', (
      tester,
    ) async {
      await tester.pumpInApp(
        controlsFor(playing.copyWith(duration: Duration.zero)),
      );

      expect(find.byType(Slider), findsNothing);
    });

    testWidgets('seeks once, on release', (tester) async {
      await tester.pumpInApp(controlsFor(playing));

      final slider = tester.getCenter(find.byType(Slider));
      await tester.dragFrom(slider, const Offset(60, 0));
      await tester.pumpAndSettle();

      expect(seeks, hasLength(1));
      expect(seeks.single, greaterThan(const Duration(minutes: 2)));
    });
  });

  group('formatPlaybackTime', () {
    test('formats under an hour as m:ss', () {
      expect(formatPlaybackTime(const Duration(seconds: 5)), '0:05');
      expect(
        formatPlaybackTime(const Duration(minutes: 2, seconds: 3)),
        '2:03',
      );
      expect(formatPlaybackTime(const Duration(minutes: 59)), '59:00');
    });

    test('formats an hour and over as h:mm:ss', () {
      expect(
        formatPlaybackTime(const Duration(hours: 1, minutes: 2, seconds: 3)),
        '1:02:03',
      );
      expect(formatPlaybackTime(const Duration(hours: 2)), '2:00:00');
    });
  });
}
