import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streambox/app/theme/app_theme.dart';
import 'package:streambox/core/config/app_config.dart';
import 'package:streambox/core/config/app_config_provider.dart';
import 'package:streambox/core/riverpod/app_provider_scope.dart';
import 'package:streambox/features/profile/presentation/pages/profile_page.dart';

void main() {
  AppConfig configFor(Flavor flavor) => AppConfig(
    flavor: flavor,
    apiBaseUrl: AppConfig.defaultBaseUrlFor(flavor),
    connectTimeout: const Duration(seconds: 1),
    receiveTimeout: const Duration(seconds: 1),
    sendTimeout: const Duration(seconds: 1),
  );

  Future<void> pumpProfile(WidgetTester tester, Flavor flavor) async {
    await tester.pumpWidget(
      AppProviderScope(
        overrides: [appConfigProvider.overrideWithValue(configFor(flavor))],
        child: MaterialApp(theme: AppTheme.dark, home: const ProfilePage()),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('ProfilePage', () {
    testWidgets('links to watch history and the saved list', (tester) async {
      await pumpProfile(tester, Flavor.development);

      expect(find.text('Watch history'), findsOneWidget);
      expect(find.text('My list'), findsOneWidget);
    });

    testWidgets('names the running flavor', (tester) async {
      await pumpProfile(tester, Flavor.staging);

      expect(find.text('StreamBox · staging'), findsOneWidget);
    });

    testWidgets('offers the design gallery only outside production', (
      tester,
    ) async {
      await pumpProfile(tester, Flavor.development);
      expect(find.text('Design system'), findsOneWidget);

      await pumpProfile(tester, Flavor.production);
      expect(find.text('Design system'), findsNothing);
    });
  });
}
