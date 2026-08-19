import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:streambox/core/constants/media_constants.dart';
import 'package:streambox/features/player/data/engine/video_player_playback_engine.dart';

/// Proves that real HLS actually plays on a real device.
///
/// Every other test in this repository substitutes a fake playback engine, so
/// none of them can tell a working stream from a dead one. That gap let a
/// catalogue full of unplayable URLs pass a green suite, so this exists to
/// close it: no fake, no substitution, real decoder, real network.
///
/// Needs a device and an internet connection:
/// `flutter test integration_test/playback_test.dart -d <device>`
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  /// Real streams open on real time, which the test clock does not advance.
  Future<void> waitFor(
    WidgetTester tester,
    bool Function() condition, {
    Duration timeout = const Duration(seconds: 15),
  }) async {
    const step = Duration(milliseconds: 250);
    var waited = Duration.zero;

    while (!condition() && waited < timeout) {
      await tester.pump(step);
      await Future<void>.delayed(step);
      waited += step;
    }
  }

  group('HLS playback', () {
    for (final url in MediaConstants.testStreams) {
      testWidgets('opens and advances: $url', (tester) async {
        final engine = VideoPlayerPlaybackEngine();
        addTearDown(engine.dispose);

        await engine.load(streamUrl: url);
        await waitFor(tester, () => engine.state.duration > Duration.zero);

        expect(
          engine.state.hasFailed,
          isFalse,
          reason: 'stream failed to open: ${engine.state.error}',
        );
        expect(
          engine.state.duration,
          greaterThan(Duration.zero),
          reason: 'stream reported no duration, so it never loaded',
        );

        await engine.play();
        await waitFor(tester, () => engine.state.position > Duration.zero);

        expect(
          engine.state.position,
          greaterThan(Duration.zero),
          reason: 'stream opened but playback never advanced',
        );
        expect(engine.state.isPlaying, isTrue);
      });
    }

    testWidgets('reports a dead stream as a failure rather than hanging', (
      tester,
    ) async {
      final engine = VideoPlayerPlaybackEngine();
      addTearDown(engine.dispose);

      // The exact shape of the original defect: a URL that resolves to a 404.
      await engine.load(
        streamUrl: 'https://stream.mux.com/does-not-exist.m3u8',
      );
      await waitFor(tester, () => engine.state.hasFailed);

      expect(engine.state.hasFailed, isTrue);
      expect(engine.state.error, isNotNull);
    });
  });
}
