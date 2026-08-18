import 'package:flutter_test/flutter_test.dart';
import 'package:streambox/features/catalog/domain/entities/search_results.dart';

import '../../../../support/content_fixtures.dart';

void main() {
  SearchResults page({
    required List<String> ids,
    int page = 0,
    bool hasMore = false,
    int totalCount = 0,
  }) => SearchResults(
    items: [for (final id in ids) buildContent(id: id)],
    page: page,
    hasMore: hasMore,
    totalCount: totalCount == 0 ? ids.length : totalCount,
  );

  group('SearchResults', () {
    test('reports emptiness', () {
      expect(SearchResults.empty.isEmpty, isTrue);
      expect(page(ids: ['a']).isEmpty, isFalse);
    });

    test('nextPage is the following index only when more exist', () {
      expect(page(ids: ['a'], hasMore: true).nextPage, 1);
      expect(page(ids: ['a'], page: 3, hasMore: true).nextPage, 4);
      expect(page(ids: ['a']).nextPage, isNull);
    });

    test('append concatenates items in order', () {
      final combined = page(
        ids: ['a', 'b'],
        hasMore: true,
        totalCount: 4,
      ).append(page(ids: ['c', 'd'], page: 1, totalCount: 4));

      expect(combined.items.map((item) => item.id), ['a', 'b', 'c', 'd']);
    });

    test('append adopts the newer page cursor and hasMore', () {
      final combined = page(
        ids: ['a'],
        hasMore: true,
        totalCount: 3,
      ).append(page(ids: ['b'], page: 1, hasMore: true, totalCount: 3));

      expect(combined.page, 1);
      expect(combined.hasMore, isTrue);

      final finished = combined.append(
        page(ids: ['c'], page: 2, totalCount: 3),
      );

      expect(finished.page, 2);
      expect(finished.hasMore, isFalse);
      expect(finished.items, hasLength(3));
    });

    test('appending an empty page leaves the items untouched', () {
      final combined = page(
        ids: ['a', 'b'],
        hasMore: true,
      ).append(page(ids: [], page: 1));

      expect(combined.items.map((item) => item.id), ['a', 'b']);
      expect(combined.hasMore, isFalse);
    });
  });
}
