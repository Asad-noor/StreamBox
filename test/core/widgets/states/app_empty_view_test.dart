import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streambox/core/widgets/states/app_empty_view.dart';

import '../../../support/widget_harness.dart';

void main() {
  group('AppEmptyView', () {
    testWidgets('renders title only when nothing else is given', (
      tester,
    ) async {
      await tester.pumpInApp(const AppEmptyView(title: 'No favourites yet'));

      expect(find.text('No favourites yet'), findsOneWidget);
      expect(find.byType(OutlinedButton), findsNothing);
    });

    testWidgets('renders the optional message', (tester) async {
      await tester.pumpInApp(
        const AppEmptyView(title: 'Nothing here', message: 'Try a search.'),
      );

      expect(find.text('Try a search.'), findsOneWidget);
    });

    testWidgets('invokes the action', (tester) async {
      var taps = 0;

      await tester.pumpInApp(
        AppEmptyView(
          title: 'Nothing here',
          actionLabel: 'Browse',
          onAction: () => taps++,
        ),
      );

      await tester.tap(find.text('Browse'));
      await tester.pump();

      expect(taps, 1);
    });

    testWidgets('hides the action when only a label is supplied', (
      tester,
    ) async {
      await tester.pumpInApp(
        const AppEmptyView(title: 'Nothing here', actionLabel: 'Browse'),
      );

      expect(find.byType(OutlinedButton), findsNothing);
    });
  });
}
