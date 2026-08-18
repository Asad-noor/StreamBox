import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streambox/app/theme/app_theme.dart';
import 'package:streambox/core/error/app_exception.dart';
import 'package:streambox/core/riverpod/app_provider_scope.dart';
import 'package:streambox/core/widgets/states/app_empty_view.dart';
import 'package:streambox/core/widgets/states/app_error_view.dart';
import 'package:streambox/features/catalog/data/providers/catalog_providers.dart';
import 'package:streambox/features/catalog/domain/entities/search_results.dart';
import 'package:streambox/features/search/presentation/pages/search_page.dart';
import 'package:streambox/features/search/presentation/widgets/search_result_tile.dart';
import 'package:streambox/features/search/presentation/widgets/search_results_skeleton.dart';

import '../../../../support/content_fixtures.dart';
import '../../../../support/fake_content_repository.dart';

/// Comfortably past the notifier's 350ms debounce.
const _pastDebounce = Duration(milliseconds: 400);

void main() {
  late FakeContentRepository repository;

  Future<void> pumpSearch(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final container = createAppProviderContainer(
      overrides: [contentRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(theme: AppTheme.dark, home: const SearchPage()),
      ),
    );
  }

  Future<void> type(WidgetTester tester, String query) async {
    await tester.enterText(find.byType(TextField), query);
    await tester.pump(_pastDebounce);
    await tester.pumpAndSettle();
  }

  setUp(() {
    repository = FakeContentRepository()
      ..searchResults = SearchResults(
        items: [
          buildContent(id: 'a', title: 'Harbour Lights'),
          buildContent(id: 'b', title: 'Low Tide'),
        ],
        page: 0,
        hasMore: false,
        totalCount: 2,
      );
  });

  group('SearchPage', () {
    testWidgets('opens on the idle prompt with no request issued', (
      tester,
    ) async {
      await pumpSearch(tester);

      expect(find.text('Find something to watch'), findsOneWidget);
      expect(repository.searchCalls, isEmpty);
    });

    testWidgets('does not search until typing settles', (tester) async {
      await pumpSearch(tester);

      await tester.enterText(find.byType(TextField), 'har');
      await tester.pump(const Duration(milliseconds: 100));

      expect(repository.searchCalls, isEmpty);

      await tester.pump(_pastDebounce);
      await tester.pumpAndSettle();

      expect(repository.searchCalls, hasLength(1));
    });

    testWidgets('shows the skeleton while the first page loads', (
      tester,
    ) async {
      repository.searchLatency = const Duration(milliseconds: 300);
      await pumpSearch(tester);

      await tester.enterText(find.byType(TextField), 'harbour');
      await tester.pump(_pastDebounce);

      expect(find.byType(SearchResultsSkeleton), findsOneWidget);

      await tester.pumpAndSettle();
      expect(find.byType(SearchResultsSkeleton), findsNothing);
    });

    testWidgets('renders one tile per match', (tester) async {
      await pumpSearch(tester);
      await type(tester, 'harbour');

      expect(find.byType(SearchResultTile), findsNWidgets(2));
      expect(find.text('Harbour Lights'), findsOneWidget);
      expect(find.text('Low Tide'), findsOneWidget);
    });

    testWidgets('shows the result count once the list is exhausted', (
      tester,
    ) async {
      await pumpSearch(tester);
      await type(tester, 'harbour');

      expect(find.text('2 results'), findsOneWidget);
    });

    testWidgets('shows the empty state naming the query', (tester) async {
      repository.searchResults = SearchResults.empty;
      await pumpSearch(tester);
      await type(tester, 'zzz');

      expect(find.byType(AppEmptyView), findsOneWidget);
      expect(find.text('No results for "zzz"'), findsOneWidget);
    });

    testWidgets('shows the error state and recovers on retry', (tester) async {
      repository.failure = const NetworkException();
      await pumpSearch(tester);
      await type(tester, 'harbour');

      expect(find.byType(AppErrorView), findsOneWidget);
      expect(find.text('You are offline'), findsOneWidget);

      repository.failure = null;
      await tester.tap(find.text('Try again'));
      await tester.pumpAndSettle();

      expect(find.byType(SearchResultTile), findsNWidgets(2));
    });

    testWidgets('the clear button empties the field and returns to idle', (
      tester,
    ) async {
      await pumpSearch(tester);
      await type(tester, 'harbour');

      await tester.tap(find.byTooltip('Clear search'));
      await tester.pumpAndSettle();

      expect(find.text('Find something to watch'), findsOneWidget);
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller?.text,
        '',
      );
    });

    testWidgets('the clear button only appears once text is entered', (
      tester,
    ) async {
      await pumpSearch(tester);

      expect(find.byTooltip('Clear search'), findsNothing);

      await type(tester, 'harbour');

      expect(find.byTooltip('Clear search'), findsOneWidget);
    });

    testWidgets('appends the next page when scrolled to the bottom', (
      tester,
    ) async {
      repository.searchPages = [
        SearchResults(
          items: [
            for (var index = 0; index < 10; index++)
              buildContent(id: 'p1-$index', title: 'First $index'),
          ],
          page: 0,
          hasMore: true,
          totalCount: 12,
        ),
        SearchResults(
          items: [
            buildContent(id: 'p2-0', title: 'Second 0'),
            buildContent(id: 'p2-1', title: 'Second 1'),
          ],
          page: 1,
          hasMore: false,
          totalCount: 12,
        ),
      ];

      await pumpSearch(tester);
      await type(tester, 'the');

      expect(repository.searchCalls.map((call) => call.page), [0]);

      await tester.fling(find.byType(ListView), const Offset(0, -2000), 3000);
      await tester.pumpAndSettle();

      expect(repository.searchCalls.map((call) => call.page), [0, 1]);
      expect(find.text('12 results'), findsOneWidget);
    });

    testWidgets('a failed page keeps existing results on screen', (
      tester,
    ) async {
      repository.searchResults = SearchResults(
        items: [
          for (var index = 0; index < 10; index++)
            buildContent(id: 'p1-$index', title: 'First $index'),
        ],
        page: 0,
        hasMore: true,
        totalCount: 20,
      );

      await pumpSearch(tester);
      await type(tester, 'the');

      repository.failure = const NetworkException();
      await tester.fling(find.byType(ListView), const Offset(0, -2000), 3000);
      await tester.pumpAndSettle();

      expect(find.byType(SearchResultTile), findsWidgets);
      expect(find.text('Load more'), findsOneWidget);
      expect(find.byType(AppErrorView), findsNothing);
    });
  });
}
