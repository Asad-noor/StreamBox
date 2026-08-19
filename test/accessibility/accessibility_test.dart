import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streambox/app/theme/app_theme.dart';
import 'package:streambox/core/error/app_exception.dart';
import 'package:streambox/core/widgets/content/content_card.dart';
import 'package:streambox/core/widgets/content/content_rail.dart';
import 'package:streambox/core/widgets/states/app_empty_view.dart';
import 'package:streambox/core/widgets/states/app_error_view.dart';
import 'package:streambox/features/player/domain/entities/playback_state.dart';
import 'package:streambox/features/player/presentation/widgets/player_controls.dart';

/// Guideline checks that apply to every interactive surface.
///
/// Run against the real theme, so a token change that breaks contrast or
/// shrinks a tap target fails here rather than in review.
void main() {
  Future<void> pump(WidgetTester tester, Widget child) async {
    await tester.binding.setSurfaceSize(const Size(400, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: Scaffold(body: child),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('guideline compliance', () {
    testWidgets('error view meets tap target, label and contrast rules', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pump(
        tester,
        AppErrorView(error: const NetworkException(), onRetry: () {}),
      );

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));

      handle.dispose();
    });

    testWidgets('empty view meets the same rules', (tester) async {
      final handle = tester.ensureSemantics();
      await pump(
        tester,
        AppEmptyView(
          title: 'Nothing saved yet',
          message: 'Titles you add will appear here.',
          actionLabel: 'Browse',
          onAction: () {},
        ),
      );

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));

      handle.dispose();
    });

    testWidgets('player controls are labelled and large enough to hit', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pump(
        tester,
        PlayerControls(
          state: const PlaybackState(
            status: PlaybackStatus.playing,
            position: Duration(minutes: 2),
            duration: Duration(minutes: 10),
          ),
          title: 'The Long Descent',
          isFullscreen: false,
          onTogglePlayPause: () {},
          onSeek: (_) {},
          onSkip: (_) {},
          onToggleMuted: () {},
          onToggleFullscreen: () {},
          onBack: () {},
        ),
      );

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));

      handle.dispose();
    });
  });

  group('text scaling', () {
    testWidgets('a rail survives the largest supported text size', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MediaQuery(
          // The upper bound the app clamps to.
          data: const MediaQueryData(textScaler: TextScaler.linear(1.4)),
          child: MaterialApp(
            theme: AppTheme.dark,
            home: Scaffold(
              body: ContentRail(
                title: 'Trending now',
                itemCount: 4,
                itemBuilder: (context, index) => ContentCard(
                  title: 'A title long enough to wrap onto two lines',
                  subtitle: 'Season $index',
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Enlarged text must not overflow the card, which is what the derived
      // rail height exists to prevent.
      expect(tester.takeException(), isNull);
    });

    testWidgets('the error view survives enlarged text', (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 640));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(1.4)),
          child: MaterialApp(
            theme: AppTheme.dark,
            home: Scaffold(
              body: AppErrorView(
                error: const NetworkException(),
                onRetry: () {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
