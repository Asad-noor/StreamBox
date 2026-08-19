import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streambox/core/layout/breakpoints.dart';
import 'package:streambox/core/widgets/content/content_card.dart';
import 'package:streambox/core/widgets/content/content_rail.dart';

import '../../../support/widget_harness.dart';

void main() {
  Widget rail() => ContentRail(
    title: 'Trending now',
    itemCount: 6,
    itemBuilder: (context, index) => ContentCard(title: 'Title $index'),
  );

  double cardWidthAt(WidgetTester tester) =>
      tester.getSize(find.byType(ContentCard).first).width;

  group('ContentRail responsiveness', () {
    testWidgets('uses compact card widths on a phone', (tester) async {
      await tester.pumpInApp(rail(), surfaceSize: const Size(390, 844));

      expect(cardWidthAt(tester), Breakpoints.cardWidth(LayoutSize.compact));
    });

    testWidgets('uses larger cards on a tablet', (tester) async {
      await tester.pumpInApp(rail(), surfaceSize: const Size(1024, 1366));

      expect(cardWidthAt(tester), Breakpoints.cardWidth(LayoutSize.expanded));
      expect(
        cardWidthAt(tester),
        greaterThan(Breakpoints.cardWidth(LayoutSize.compact)),
      );
    });

    testWidgets('an explicit width overrides the derived one', (tester) async {
      await tester.pumpInApp(
        ContentRail(
          title: 'Trending now',
          itemCount: 3,
          itemWidth: 99,
          itemBuilder: (context, index) => ContentCard(title: 'Title $index'),
        ),
        surfaceSize: const Size(1024, 1366),
      );

      expect(cardWidthAt(tester), 99);
    });

    testWidgets('isolates each card so scrolling repaints less', (
      tester,
    ) async {
      await tester.pumpInApp(rail(), surfaceSize: const Size(390, 844));

      expect(
        find.descendant(
          of: find.byType(ContentRail),
          matching: find.byType(RepaintBoundary),
        ),
        findsWidgets,
      );
    });

    testWidgets('header and first card share a gutter', (tester) async {
      await tester.pumpInApp(rail(), surfaceSize: const Size(1024, 1366));

      // A mismatched gutter is the sort of thing that only shows up on a
      // device, so it is asserted rather than eyeballed.
      expect(
        tester.getTopLeft(find.text('Trending now')).dx,
        tester.getTopLeft(find.byType(ContentCard).first).dx,
      );
    });
  });
}
