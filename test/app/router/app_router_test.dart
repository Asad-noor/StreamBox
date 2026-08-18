import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:streambox/app/app.dart';
import 'package:streambox/app/router/app_router.dart';
import 'package:streambox/app/router/routes.dart';
import 'package:streambox/features/catalog/data/datasources/fake_content_remote_data_source.dart';
import 'package:streambox/features/catalog/data/providers/catalog_providers.dart';
import 'package:streambox/features/details/presentation/pages/content_details_page.dart';
import 'package:streambox/features/favorites/presentation/pages/favorites_page.dart';
import 'package:streambox/features/history/presentation/pages/history_page.dart';
import 'package:streambox/features/home/presentation/pages/home_page.dart';
import 'package:streambox/features/player/presentation/pages/player_page.dart';
import 'package:streambox/features/profile/presentation/pages/profile_page.dart';
import 'package:streambox/features/search/presentation/pages/search_page.dart';

/// Removes the fake source's simulated latency so navigation tests settle
/// immediately instead of waiting on an artificial delay.
final _fastCatalogue = [
  contentRemoteDataSourceProvider.overrideWithValue(
    const FakeContentRemoteDataSource(latency: Duration.zero),
  ),
];

void main() {
  Future<GoRouter> pumpApp(WidgetTester tester) async {
    final container = ProviderContainer(overrides: _fastCatalogue);
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

  group('app router', () {
    testWidgets('starts on home', (tester) async {
      await pumpApp(tester);

      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('each shell branch resolves to its screen', (tester) async {
      final router = await pumpApp(tester);

      final destinations = <String, Type>{
        SearchRoute.path: SearchPage,
        FavoritesRoute.path: FavoritesPage,
        ProfileRoute.path: ProfilePage,
        HomeRoute.path: HomePage,
      };

      for (final MapEntry(key: path, value: page) in destinations.entries) {
        router.go(path);
        await tester.pumpAndSettle();

        expect(find.byType(page), findsOneWidget, reason: 'expected $path');
      }
    });

    testWidgets('shell destinations keep the navigation bar', (tester) async {
      final router = await pumpApp(tester);

      router.go(SearchRoute.path);
      await tester.pumpAndSettle();

      expect(find.byType(NavigationBar), findsOneWidget);
    });

    testWidgets('details and player cover the navigation bar', (tester) async {
      final router = await pumpApp(tester);

      router.go(const ContentDetailsRoute(contentId: 'abc').location);
      await tester.pumpAndSettle();

      expect(find.byType(ContentDetailsPage), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);

      router.go(const PlayerRoute(contentId: 'abc').location);
      await tester.pumpAndSettle();

      expect(find.byType(PlayerPage), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);
    });

    testWidgets('path parameters reach the screen', (tester) async {
      final router = await pumpApp(tester);

      router.go(const ContentDetailsRoute(contentId: 'tt-1234').location);
      await tester.pumpAndSettle();

      final page = tester.widget<ContentDetailsPage>(
        find.byType(ContentDetailsPage),
      );

      expect(page.contentId, 'tt-1234');
    });

    testWidgets('history is reachable outside the shell', (tester) async {
      final router = await pumpApp(tester);

      router.go(HistoryRoute.path);
      await tester.pumpAndSettle();

      expect(find.byType(HistoryPage), findsOneWidget);
    });

    testWidgets('an unknown route renders the error screen', (tester) async {
      final router = await pumpApp(tester);

      router.go('/does-not-exist');
      await tester.pumpAndSettle();

      expect(find.text('Not found'), findsWidgets);
    });
  });
}
