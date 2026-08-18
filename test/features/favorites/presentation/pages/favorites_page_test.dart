import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streambox/app/theme/app_theme.dart';
import 'package:streambox/core/error/app_exception.dart';
import 'package:streambox/core/riverpod/app_provider_scope.dart';
import 'package:streambox/core/widgets/states/app_empty_view.dart';
import 'package:streambox/features/favorites/presentation/pages/favorites_page.dart';
import 'package:streambox/features/favorites/presentation/providers/favorites_providers.dart';
import 'package:streambox/features/favorites/presentation/widgets/favorite_tile.dart';

import '../../../../support/content_fixtures.dart';
import '../../../../support/fake_favorites_repository.dart';
import '../../../../support/offline_image_http_overrides.dart';

void main() {
  late FakeFavoritesRepository repository;

  Future<void> pumpFavorites(WidgetTester tester) async {
    useOfflineImages();
    await tester.binding.setSurfaceSize(const Size(400, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      AppProviderScope(
        overrides: [favoritesRepositoryProvider.overrideWithValue(repository)],
        child: MaterialApp(theme: AppTheme.dark, home: const FavoritesPage()),
      ),
    );
    await tester.pumpAndSettle();
  }

  setUp(() {
    repository = FakeFavoritesRepository();
    addTearDown(repository.dispose);
  });

  group('FavoritesPage', () {
    testWidgets('shows the empty state with nothing saved', (tester) async {
      await pumpFavorites(tester);

      expect(find.byType(AppEmptyView), findsOneWidget);
      expect(find.text('Nothing saved yet'), findsOneWidget);
    });

    testWidgets('lists saved titles from the stored snapshot', (tester) async {
      await repository.add(buildContent(id: 'a', title: 'Harbour Lights'));
      await repository.add(buildContent(id: 'b', title: 'Low Tide'));

      await pumpFavorites(tester);

      expect(find.byType(FavoriteTile), findsNWidgets(2));
      expect(find.text('Harbour Lights'), findsOneWidget);
      expect(find.text('Low Tide'), findsOneWidget);
    });

    testWidgets('updates live when a title is saved elsewhere', (tester) async {
      await pumpFavorites(tester);
      expect(find.byType(FavoriteTile), findsNothing);

      // Nothing tells the screen to refresh: the repository stream does.
      await repository.add(buildContent(id: 'a', title: 'Harbour Lights'));
      await tester.pumpAndSettle();

      expect(find.text('Harbour Lights'), findsOneWidget);
    });

    testWidgets('removes a title with the button', (tester) async {
      await repository.add(buildContent(id: 'a', title: 'Harbour Lights'));

      await pumpFavorites(tester);
      await tester.tap(find.byTooltip('Remove Harbour Lights from my list'));
      await tester.pumpAndSettle();

      expect(find.byType(FavoriteTile), findsNothing);
      expect(find.byType(AppEmptyView), findsOneWidget);
    });

    testWidgets('removes a title by swiping', (tester) async {
      await repository.add(buildContent(id: 'a', title: 'Harbour Lights'));

      await pumpFavorites(tester);
      await tester.drag(find.byType(FavoriteTile), const Offset(-500, 0));
      await tester.pumpAndSettle();

      expect(find.byType(FavoriteTile), findsNothing);
    });

    testWidgets('tells the viewer when a removal fails', (tester) async {
      await repository.add(buildContent(id: 'a', title: 'Harbour Lights'));
      await pumpFavorites(tester);

      repository.failure = const CacheException();
      await tester.tap(find.byTooltip('Remove Harbour Lights from my list'));
      await tester.pumpAndSettle();

      expect(find.text('Could not update your list.'), findsOneWidget);
      // The entry stays: the write never happened.
      expect(find.byType(FavoriteTile), findsOneWidget);
    });
  });
}
