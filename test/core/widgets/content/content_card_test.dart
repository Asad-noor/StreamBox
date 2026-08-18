import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streambox/core/widgets/content/content_card.dart';

import '../../../support/widget_harness.dart';

void main() {
  group('ContentCard', () {
    testWidgets('renders the title and optional subtitle', (tester) async {
      await tester.pumpInApp(
        const ContentCard(title: 'The Long Descent', subtitle: 'Season 2'),
      );

      expect(find.text('The Long Descent'), findsOneWidget);
      expect(find.text('Season 2'), findsOneWidget);
    });

    testWidgets('draws a resume bar only when progress is set', (tester) async {
      await tester.pumpInApp(const ContentCard(title: 'Unwatched'));
      expect(find.byType(LinearProgressIndicator), findsNothing);

      await tester.pumpInApp(
        const ContentCard(title: 'Half watched', progress: 0.5),
      );

      final indicator = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(indicator.value, 0.5);
    });

    testWidgets('clamps out-of-range progress instead of throwing', (
      tester,
    ) async {
      await tester.pumpInApp(
        const ContentCard(title: 'Overshot', progress: 1.4),
      );

      final indicator = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(indicator.value, 1.0);
    });

    testWidgets('reports tap', (tester) async {
      var taps = 0;

      await tester.pumpInApp(
        ContentCard(title: 'Tappable', onTap: () => taps++),
      );

      await tester.tap(find.byType(ContentCard));
      await tester.pump();

      expect(taps, 1);
    });

    testWidgets('announces itself as one labelled button', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpInApp(
        ContentCard(
          title: 'The Long Descent',
          subtitle: 'Season 2',
          progress: 0.5,
          onTap: () {},
        ),
      );

      expect(
        find.bySemanticsLabel('The Long Descent, Season 2, 50 percent watched'),
        findsOneWidget,
      );

      handle.dispose();
    });

    testWidgets('a long title stays within the card width', (tester) async {
      await tester.pumpInApp(
        const ContentCard(
          title: 'A title long enough that it must be truncated to two lines',
        ),
      );

      expect(tester.takeException(), isNull);

      final size = tester.getSize(find.byType(ContentCard));
      expect(size.width, ContentCard.defaultWidth);
    });
  });
}
