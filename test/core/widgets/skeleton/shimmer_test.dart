import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streambox/core/widgets/skeleton/shimmer.dart';

import '../../../support/widget_harness.dart';

void main() {
  group('Shimmer', () {
    testWidgets('masks its child while enabled', (tester) async {
      await tester.pumpInApp(
        const Shimmer(child: SizedBox(width: 100, height: 20)),
      );

      expect(find.byType(ShaderMask), findsOneWidget);
    });

    testWidgets('renders the child untouched when disabled', (tester) async {
      await tester.pumpInApp(
        const Shimmer(enabled: false, child: SizedBox(width: 100, height: 20)),
      );

      expect(find.byType(ShaderMask), findsNothing);
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('starts and stops the animation with the flag', (tester) async {
      Widget shimmer({required bool enabled}) => MaterialApp(
        home: Shimmer(
          enabled: enabled,
          child: const SizedBox(width: 100, height: 20),
        ),
      );

      await tester.pumpWidget(shimmer(enabled: true));
      expect(find.byType(ShaderMask), findsOneWidget);

      await tester.pumpWidget(shimmer(enabled: false));
      expect(find.byType(ShaderMask), findsNothing);

      await tester.pumpWidget(shimmer(enabled: true));
      expect(find.byType(ShaderMask), findsOneWidget);

      // A running controller would keep the test pending forever if it leaked.
      await tester.pumpWidget(const SizedBox.shrink());
      expect(tester.takeException(), isNull);
    });

    testWidgets('drives one controller for the whole subtree', (tester) async {
      await tester.pumpInApp(
        const Shimmer(
          child: Column(
            children: [
              SizedBox(width: 100, height: 20),
              SizedBox(width: 100, height: 20),
              SizedBox(width: 100, height: 20),
            ],
          ),
        ),
      );

      expect(find.byType(ShaderMask), findsOneWidget);
    });
  });
}
