import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streambox/app/app.dart';
import 'package:streambox/app/theme/app_colors.dart';
import 'package:streambox/core/riverpod/app_provider_scope.dart';
import 'package:streambox/features/home/presentation/pages/home_page.dart';

import 'support/test_database.dart';

void main() {
  group('StreamBoxApp', () {
    testWidgets('boots into the home destination', (tester) async {
      await tester.pumpWidget(
        AppProviderScope(
          overrides: testOverrides(),
          child: const StreamBoxApp(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('applies the dark theme', (tester) async {
      await tester.pumpWidget(
        AppProviderScope(
          overrides: testOverrides(),
          child: const StreamBoxApp(),
        ),
      );
      await tester.pumpAndSettle();

      final theme = Theme.of(tester.element(find.byType(HomePage)));

      expect(theme.brightness, Brightness.dark);
      expect(theme.colorScheme.primary, AppColors.red);
      expect(theme.scaffoldBackgroundColor, AppColors.background);
    });

    testWidgets('exposes all four primary destinations', (tester) async {
      await tester.pumpWidget(
        AppProviderScope(
          overrides: testOverrides(),
          child: const StreamBoxApp(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(NavigationDestination), findsNWidgets(4));
    });
  });
}
