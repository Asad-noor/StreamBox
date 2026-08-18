import 'package:flutter_test/flutter_test.dart';
import 'package:streambox/core/error/app_exception.dart';
import 'package:streambox/features/catalog/data/datasources/fake_content_remote_data_source.dart';

void main() {
  const source = FakeContentRemoteDataSource(latency: Duration.zero);

  group('searchContent', () {
    test('matches on title', () async {
      final results = await source.searchContent(
        query: 'harbour',
        page: 0,
        pageSize: 10,
      );

      expect(results.items.single.title, 'Harbour Lights');
    });

    test('is case insensitive', () async {
      final upper = await source.searchContent(
        query: 'HARBOUR',
        page: 0,
        pageSize: 10,
      );

      expect(upper.items.single.id, 'harbour-lights');
    });

    test('matches on genre', () async {
      final results = await source.searchContent(
        query: 'sci-fi',
        page: 0,
        pageSize: 20,
      );

      expect(results.items, isNotEmpty);
      expect(
        results.items.every(
          (item) => item.genres.any((g) => g.toLowerCase().contains('sci-fi')),
        ),
        isTrue,
      );
    });

    test('matches on synopsis', () async {
      final results = await source.searchContent(
        query: 'cryosleep',
        page: 0,
        pageSize: 10,
      );

      expect(results.items.single.id, 'the-long-descent');
    });

    test('ranks title matches above synopsis matches', () async {
      final results = await source.searchContent(
        query: 'the',
        page: 0,
        pageSize: 20,
      );

      final firstNonTitle = results.items.indexWhere(
        (item) => !item.title.toLowerCase().contains('the'),
      );
      final lastTitle = results.items.lastIndexWhere(
        (item) => item.title.toLowerCase().contains('the'),
      );

      if (firstNonTitle != -1) expect(lastTitle, lessThan(firstNonTitle));
    });

    test('returns nothing for a query that matches nothing', () async {
      final results = await source.searchContent(
        query: 'zzzzzz',
        page: 0,
        pageSize: 10,
      );

      expect(results.items, isEmpty);
      expect(results.totalCount, 0);
      expect(results.hasMore, isFalse);
    });

    test('treats a blank query as no match', () async {
      final results = await source.searchContent(
        query: '   ',
        page: 0,
        pageSize: 10,
      );

      expect(results.items, isEmpty);
    });

    test('pages through results without gaps or repeats', () async {
      final first = await source.searchContent(
        query: 'the',
        page: 0,
        pageSize: 2,
      );
      final second = await source.searchContent(
        query: 'the',
        page: 1,
        pageSize: 2,
      );

      expect(first.items, hasLength(2));
      expect(first.hasMore, isTrue);
      expect(
        first.items
            .map((item) => item.id)
            .toSet()
            .intersection(second.items.map((item) => item.id).toSet()),
        isEmpty,
      );
      expect(first.totalCount, second.totalCount);
    });

    test('reports no more results on the final page', () async {
      final all = await source.searchContent(
        query: 'harbour',
        page: 0,
        pageSize: 10,
      );

      expect(all.hasMore, isFalse);
    });

    test('returns an empty page beyond the end rather than throwing', () async {
      final results = await source.searchContent(
        query: 'harbour',
        page: 99,
        pageSize: 10,
      );

      expect(results.items, isEmpty);
      expect(results.hasMore, isFalse);
    });

    test('propagates the injected failure', () async {
      const failing = FakeContentRemoteDataSource(
        latency: Duration.zero,
        failure: NetworkException(),
      );

      expect(
        () => failing.searchContent(query: 'a', page: 0, pageSize: 10),
        throwsA(isA<NetworkException>()),
      );
    });
  });

  group('fetchContentById', () {
    test('returns a known title', () async {
      final model = await source.fetchContentById('harbour-lights');

      expect(model.title, 'Harbour Lights');
    });

    test('throws NotFoundException for an unknown id', () async {
      expect(
        () => source.fetchContentById('nope'),
        throwsA(isA<NotFoundException>()),
      );
    });
  });

  group('fetchHomeFeed', () {
    test('returns a featured title and non-empty sections', () async {
      final feed = await source.fetchHomeFeed();

      expect(feed.featured, isNotNull);
      expect(feed.sections, isNotEmpty);
      expect(
        feed.sections.every((section) => section.items.isNotEmpty),
        isTrue,
      );
    });

    test('is deterministic across calls', () async {
      final first = await source.fetchHomeFeed();
      final second = await source.fetchHomeFeed();

      expect(first.featured?.id, second.featured?.id);
      expect(
        first.sections.map((s) => s.items.map((i) => i.id).toList()),
        second.sections.map((s) => s.items.map((i) => i.id).toList()),
      );
    });
  });
}
