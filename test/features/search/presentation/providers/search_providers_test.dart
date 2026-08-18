import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streambox/core/error/app_exception.dart';
import 'package:streambox/core/riverpod/retry_policy.dart';
import 'package:streambox/features/catalog/data/providers/catalog_providers.dart';
import 'package:streambox/features/catalog/domain/entities/search_results.dart';
import 'package:streambox/features/search/presentation/providers/search_providers.dart';
import 'package:streambox/features/search/presentation/providers/search_state.dart';

import '../../../../support/content_fixtures.dart';
import '../../../../support/fake_content_repository.dart';

/// Longer than the notifier's 350ms debounce.
const _pastDebounce = Duration(milliseconds: 400);

SearchResults resultsPage({
  required List<String> ids,
  int page = 0,
  bool hasMore = false,
  int? totalCount,
}) => SearchResults(
  items: [for (final id in ids) buildContent(id: id, title: 'Title $id')],
  page: page,
  hasMore: hasMore,
  totalCount: totalCount ?? ids.length,
);

void main() {
  late FakeContentRepository repository;

  ProviderContainer buildContainer() {
    final container = ProviderContainer(
      retry: noAutomaticRetry,
      overrides: [contentRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
    container.listen(searchProvider, (_, _) {}, fireImmediately: true);

    return container;
  }

  setUp(() {
    repository = FakeContentRepository()
      ..searchResults = resultsPage(ids: ['a', 'b']);
  });

  group('initial state', () {
    test('starts idle', () {
      expect(buildContainer().read(searchProvider), isA<SearchIdle>());
    });
  });

  group('debounce', () {
    test('does not search while the query is still changing', () async {
      final container = buildContainer();
      final notifier = container.read(searchProvider.notifier);

      notifier
        ..onQueryChanged('h')
        ..onQueryChanged('ha')
        ..onQueryChanged('har');

      await Future<void>.delayed(const Duration(milliseconds: 100));
      expect(repository.searchCalls, isEmpty);

      await Future<void>.delayed(_pastDebounce);
      expect(repository.searchCalls, hasLength(1));
      expect(repository.searchCalls.single.query, 'har');
    });

    test('trims whitespace before searching', () async {
      final container = buildContainer();
      container.read(searchProvider.notifier).onQueryChanged('  harbour  ');

      await Future<void>.delayed(_pastDebounce);

      expect(repository.searchCalls.single.query, 'harbour');
    });

    test('clearing the field returns to idle without a request', () async {
      final container = buildContainer();
      final notifier = container.read(searchProvider.notifier);

      notifier.onQueryChanged('harbour');
      await Future<void>.delayed(_pastDebounce);

      notifier.onQueryChanged('');

      expect(container.read(searchProvider), isA<SearchIdle>());
      expect(repository.searchCalls, hasLength(1));
    });

    test('a whitespace-only query is treated as cleared', () async {
      final container = buildContainer();
      container.read(searchProvider.notifier).onQueryChanged('   ');

      await Future<void>.delayed(_pastDebounce);

      expect(container.read(searchProvider), isA<SearchIdle>());
      expect(repository.searchCalls, isEmpty);
    });

    test('does not re-search an unchanged query', () async {
      final container = buildContainer();
      final notifier = container.read(searchProvider.notifier);

      notifier.onQueryChanged('harbour');
      await Future<void>.delayed(_pastDebounce);

      notifier.onQueryChanged('harbour');
      await Future<void>.delayed(_pastDebounce);

      expect(repository.searchCalls, hasLength(1));
    });
  });

  group('results', () {
    test('resolves to success with the matches', () async {
      final container = buildContainer();
      container.read(searchProvider.notifier).onQueryChanged('harbour');

      await Future<void>.delayed(_pastDebounce);

      final state = container.read(searchProvider);
      expect(state, isA<SearchSuccess>());
      expect((state as SearchSuccess).results.items, hasLength(2));
      expect(state.query, 'harbour');
    });

    test('reports no matches as empty rather than success', () async {
      repository.searchResults = SearchResults.empty;
      final container = buildContainer();

      container.read(searchProvider.notifier).onQueryChanged('zzz');
      await Future<void>.delayed(_pastDebounce);

      expect(container.read(searchProvider), isA<SearchEmpty>());
    });

    test('shows a loading state while the first page is in flight', () async {
      repository.searchLatency = const Duration(milliseconds: 200);
      final container = buildContainer();

      container.read(searchProvider.notifier).onQueryChanged('harbour');
      await Future<void>.delayed(_pastDebounce);

      expect(container.read(searchProvider), isA<SearchLoading>());

      await Future<void>.delayed(const Duration(milliseconds: 250));
      expect(container.read(searchProvider), isA<SearchSuccess>());
    });
  });

  group('staleness', () {
    test('discards a slow response superseded by a newer query', () async {
      repository.searchLatency = const Duration(milliseconds: 300);
      final container = buildContainer();
      final notifier = container.read(searchProvider.notifier);

      notifier.onQueryChanged('har');
      await Future<void>.delayed(_pastDebounce);

      // "har" is now in flight. Issue a newer query that resolves sooner.
      repository
        ..searchLatency = Duration.zero
        ..searchResults = resultsPage(ids: ['fast']);
      notifier.onQueryChanged('harbour');
      await Future<void>.delayed(_pastDebounce);

      // Let the original slow response land.
      await Future<void>.delayed(const Duration(milliseconds: 400));

      final state = container.read(searchProvider) as SearchSuccess;
      expect(state.query, 'harbour');
      expect(state.results.items.single.id, 'fast');
    });

    test('a response arriving after the field is cleared is ignored', () async {
      repository.searchLatency = const Duration(milliseconds: 300);
      final container = buildContainer();
      final notifier = container.read(searchProvider.notifier);

      notifier.onQueryChanged('harbour');
      await Future<void>.delayed(_pastDebounce);
      notifier.onQueryChanged('');

      await Future<void>.delayed(const Duration(milliseconds: 400));

      expect(container.read(searchProvider), isA<SearchIdle>());
    });
  });

  group('failure', () {
    test('surfaces a first-page failure', () async {
      repository.failure = const NetworkException();
      final container = buildContainer();

      container.read(searchProvider.notifier).onQueryChanged('harbour');
      await Future<void>.delayed(_pastDebounce);

      final state = container.read(searchProvider);
      expect(state, isA<SearchFailure>());
      expect((state as SearchFailure).error, isA<NetworkException>());
    });

    test('retry re-runs the failed query', () async {
      repository.failure = const NetworkException();
      final container = buildContainer();
      final notifier = container.read(searchProvider.notifier);

      notifier.onQueryChanged('harbour');
      await Future<void>.delayed(_pastDebounce);

      repository.failure = null;
      await notifier.retry();

      expect(container.read(searchProvider), isA<SearchSuccess>());
      expect(repository.searchCalls, hasLength(2));
    });

    test('retry is a no-op when nothing has been searched', () async {
      final container = buildContainer();

      await container.read(searchProvider.notifier).retry();

      expect(repository.searchCalls, isEmpty);
      expect(container.read(searchProvider), isA<SearchIdle>());
    });
  });

  group('pagination', () {
    setUp(() {
      repository.searchPages = [
        resultsPage(ids: ['a', 'b'], hasMore: true, totalCount: 4),
        resultsPage(ids: ['c', 'd'], page: 1, totalCount: 4),
      ];
    });

    Future<ProviderContainer> searched() async {
      final container = buildContainer();
      container.read(searchProvider.notifier).onQueryChanged('the');
      await Future<void>.delayed(_pastDebounce);

      return container;
    }

    test('appends the next page to the existing results', () async {
      final container = await searched();

      await container.read(searchProvider.notifier).loadMore();

      final state = container.read(searchProvider) as SearchSuccess;
      expect(state.results.items.map((item) => item.id), ['a', 'b', 'c', 'd']);
      expect(state.results.hasMore, isFalse);
      expect(repository.searchCalls.map((call) => call.page), [0, 1]);
    });

    test('does nothing once results are exhausted', () async {
      final container = await searched();
      final notifier = container.read(searchProvider.notifier);

      await notifier.loadMore();
      await notifier.loadMore();

      expect(repository.searchCalls, hasLength(2));
    });

    test('ignores repeat calls while a page is in flight', () async {
      repository
        ..searchPages = null
        ..searchResults = resultsPage(ids: ['a'], hasMore: true, totalCount: 9);
      final container = buildContainer();
      container.read(searchProvider.notifier).onQueryChanged('the');
      await Future<void>.delayed(_pastDebounce);

      repository.searchLatency = const Duration(milliseconds: 100);
      final notifier = container.read(searchProvider.notifier);

      final first = notifier.loadMore();
      await notifier.loadMore();
      await notifier.loadMore();
      await first;

      // One first-page call plus exactly one in-flight next-page call.
      expect(repository.searchCalls, hasLength(2));
    });

    test('keeps loaded results when a page fails', () async {
      final container = await searched();
      repository
        ..searchPages = null
        ..failure = const NetworkException();

      await container.read(searchProvider.notifier).loadMore();

      final state = container.read(searchProvider) as SearchSuccess;
      expect(state.results.items.map((item) => item.id), ['a', 'b']);
      expect(state.pageError, isA<NetworkException>());
      expect(state.canLoadMore, isFalse);
    });

    test('retryNextPage clears the error and appends', () async {
      final container = await searched();
      repository
        ..searchPages = null
        ..failure = const NetworkException();

      final notifier = container.read(searchProvider.notifier);
      await notifier.loadMore();

      repository
        ..failure = null
        ..searchResults = resultsPage(ids: ['c'], page: 1, totalCount: 3);
      await notifier.retryNextPage();

      final state = container.read(searchProvider) as SearchSuccess;
      expect(state.pageError, isNull);
      expect(state.results.items.map((item) => item.id), ['a', 'b', 'c']);
    });

    test('a new query discards pagination from the previous one', () async {
      final container = await searched();
      final notifier = container.read(searchProvider.notifier);
      await notifier.loadMore();

      repository
        ..searchPages = null
        ..searchResults = resultsPage(ids: ['x']);
      notifier.onQueryChanged('other');
      await Future<void>.delayed(_pastDebounce);

      final state = container.read(searchProvider) as SearchSuccess;
      expect(state.results.items.map((item) => item.id), ['x']);
      expect(state.results.page, 0);
    });
  });
}
