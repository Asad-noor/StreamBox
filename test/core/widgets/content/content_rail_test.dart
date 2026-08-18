import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streambox/core/widgets/content/content_card.dart';
import 'package:streambox/core/widgets/content/content_rail.dart';

import '../../../support/widget_harness.dart';

void main() {
  Widget railOf({required int itemCount, VoidCallback? onSeeAll}) =>
      ContentRail(
        title: 'Trending now',
        itemCount: itemCount,
        onSeeAll: onSeeAll,
        itemBuilder: (context, index) => ContentCard(title: 'Title $index'),
      );

  group('ContentRail', () {
    testWidgets('renders its header and cards', (tester) async {
      await tester.pumpInApp(railOf(itemCount: 5));

      expect(find.text('Trending now'), findsOneWidget);
      expect(find.text('Title 0'), findsOneWidget);
    });

    testWidgets('collapses entirely when there is nothing to show', (
      tester,
    ) async {
      await tester.pumpInApp(railOf(itemCount: 0));

      expect(find.text('Trending now'), findsNothing);
      expect(find.byType(ListView), findsNothing);
    });

    testWidgets('builds lazily rather than instantiating every card', (
      tester,
    ) async {
      await tester.pumpInApp(railOf(itemCount: 200));

      // Only the visible window plus the cache extent should exist.
      expect(tester.widgetList(find.byType(ContentCard)).length, lessThan(20));
    });

    testWidgets('shows "See all" only when a handler is given', (tester) async {
      await tester.pumpInApp(railOf(itemCount: 3));
      expect(find.text('See all'), findsNothing);

      var taps = 0;
      await tester.pumpInApp(railOf(itemCount: 3, onSeeAll: () => taps++));

      await tester.tap(find.text('See all'));
      await tester.pump();

      expect(taps, 1);
    });

    testWidgets('grows taller when the user enlarges text', (tester) async {
      double railHeight() => tester.getSize(find.byType(ListView)).height;

      Widget scaled(TextScaler scaler) => MediaQuery(
        data: MediaQueryData(textScaler: scaler),
        child: MaterialApp(home: Scaffold(body: railOf(itemCount: 3))),
      );

      await tester.pumpWidget(scaled(TextScaler.noScaling));
      final unscaled = railHeight();

      await tester.pumpWidget(scaled(const TextScaler.linear(1.4)));

      // The label block under each poster must have room to grow, or enlarged
      // titles are clipped.
      expect(railHeight(), greaterThan(unscaled));
    });
  });
}
