import 'package:flutter_test/flutter_test.dart';
import 'package:streambox/core/error/app_exception.dart';
import 'package:streambox/features/catalog/domain/entities/search_results.dart';
import 'package:streambox/features/search/presentation/providers/search_state.dart';

import '../../../../support/content_fixtures.dart';

void main() {
  SearchResults resultsWith({bool hasMore = false}) => SearchResults(
    items: [buildContent(id: 'a')],
    page: 0,
    hasMore: hasMore,
    totalCount: hasMore ? 5 : 1,
  );

  group('query', () {
    test('is empty only when idle', () {
      expect(const SearchState.idle().query, '');
      expect(const SearchState.loading(query: 'har').query, 'har');
      expect(const SearchState.empty(query: 'zzz').query, 'zzz');
      expect(
        SearchState.success(query: 'har', results: resultsWith()).query,
        'har',
      );
      expect(
        const SearchState.failure(
          query: 'har',
          error: NetworkException(),
        ).query,
        'har',
      );
    });
  });

  group('canLoadMore', () {
    test('is false for every state but success', () {
      expect(const SearchState.idle().canLoadMore, isFalse);
      expect(const SearchState.loading(query: 'a').canLoadMore, isFalse);
      expect(const SearchState.empty(query: 'a').canLoadMore, isFalse);
      expect(
        const SearchState.failure(
          query: 'a',
          error: NetworkException(),
        ).canLoadMore,
        isFalse,
      );
    });

    test('is true only when a further page exists and none is in flight', () {
      expect(
        SearchState.success(
          query: 'a',
          results: resultsWith(hasMore: true),
        ).canLoadMore,
        isTrue,
      );
      expect(
        SearchState.success(query: 'a', results: resultsWith()).canLoadMore,
        isFalse,
      );
      expect(
        SearchState.success(
          query: 'a',
          results: resultsWith(hasMore: true),
          isLoadingMore: true,
        ).canLoadMore,
        isFalse,
      );
    });

    test('is false while a page error is unresolved', () {
      // Otherwise scrolling would retry the failed page continuously.
      expect(
        SearchState.success(
          query: 'a',
          results: resultsWith(hasMore: true),
          pageError: const NetworkException(),
        ).canLoadMore,
        isFalse,
      );
    });
  });
}
