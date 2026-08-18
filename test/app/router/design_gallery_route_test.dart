import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:streambox/app/app.dart';
import 'package:streambox/app/design_gallery/design_gallery_page.dart';
import 'package:streambox/app/router/app_router.dart';
import 'package:streambox/app/router/routes.dart';
import 'package:streambox/core/config/app_config.dart';
import 'package:streambox/core/config/app_config_provider.dart';
import 'package:streambox/core/riverpod/app_provider_scope.dart';
import 'package:streambox/features/home/presentation/pages/home_page.dart';
import '../../support/test_database.dart';

void main() {
  AppConfig configFor(Flavor flavor) => AppConfig(
    flavor: flavor,
    apiBaseUrl: AppConfig.defaultBaseUrlFor(flavor),
    connectTimeout: const Duration(seconds: 1),
    receiveTimeout: const Duration(seconds: 1),
    sendTimeout: const Duration(seconds: 1),
  );

  Future<GoRouter> pumpAppOn(WidgetTester tester, Flavor flavor) async {
    final container = createAppProviderContainer(
      overrides: [
        appConfigProvider.overrideWithValue(configFor(flavor)),
        ...testOverrides(),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const StreamBoxApp(),
      ),
    );
    await tester.pumpAndSettle();

    return container.read(appRouterProvider);
  }

  group('design gallery route', () {
    testWidgets('is reachable in development', (tester) async {
      final router = await pumpAppOn(tester, Flavor.development);

      router.go(DesignGalleryRoute.path);
      await tester.pumpAndSettle();

      expect(find.byType(DesignGalleryPage), findsOneWidget);
    });

    // One app per test: two live GoRouters in a single test collide on the
    // GlobalKeys backing their navigators.
    for (final flavor in [Flavor.staging, Flavor.production]) {
      testWidgets('redirects to home in ${flavor.name}', (tester) async {
        final router = await pumpAppOn(tester, flavor);

        router.go(DesignGalleryRoute.path);
        await tester.pumpAndSettle();

        expect(find.byType(DesignGalleryPage), findsNothing);
        expect(find.byType(HomePage), findsOneWidget);
      });
    }
  });
}
