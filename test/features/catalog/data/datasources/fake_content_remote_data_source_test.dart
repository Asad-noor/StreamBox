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

  group('fetchContentDetails', () {
    test('returns a movie with no seasons', () async {
      final details = await source.fetchContentDetails('the-long-descent');

      expect(details.content.title, 'The Long Descent');
      expect(details.seasons, isEmpty);
    });

    test('builds one season per declared season count', () async {
      final details = await source.fetchContentDetails('harbour-lights');

      expect(details.content.seasonCount, 3);
      expect(details.seasons, hasLength(3));
      expect(details.seasons.map((season) => season.number), [1, 2, 3]);
    });

    test('gives every episode a unique, addressable identifier', () async {
      final details = await source.fetchContentDetails('harbour-lights');

      final ids = [
        for (final season in details.seasons)
          for (final episode in season.episodes) episode.id,
      ];

      expect(ids.toSet(), hasLength(ids.length));
      expect(ids.first, 'harbour-lights-s1e1');
    });

    test('numbers episodes from one within each season', () async {
      final details = await source.fetchContentDetails('harbour-lights');

      for (final season in details.seasons) {
        expect(
          season.episodes.map((episode) => episode.number),
          List.generate(season.episodes.length, (index) => index + 1),
          reason: 'season ${season.number}',
        );
      }
    });

    test('every episode is playable', () async {
      final details = await source.fetchContentDetails('harbour-lights');

      expect(
        details.seasons
            .expand((season) => season.episodes)
            .every((episode) => episode.streamUrl != null),
        isTrue,
      );
    });

    test('gives each episode in a season its own description', () async {
      final details = await source.fetchContentDetails('harbour-lights');
      final season = details.seasons.first;

      // Six identical paragraphs is not a catalogue.
      expect(
        season.episodes.map((episode) => episode.synopsis).toSet(),
        hasLength(season.episodes.length),
      );
      expect(
        season.episodes.map((episode) => episode.title).toSet(),
        hasLength(season.episodes.length),
      );
    });

    test('episode descriptions differ from the series blurb', () async {
      final details = await source.fetchContentDetails('harbour-lights');

      expect(
        details.seasons.first.episodes.every(
          (episode) => episode.synopsis != details.content.synopsis,
        ),
        isTrue,
      );
    });

    test('is deterministic across calls', () async {
      final first = await source.fetchContentDetails('harbour-lights');
      final second = await source.fetchContentDetails('harbour-lights');

      expect(
        first.seasons.map((s) => s.episodes.map((e) => e.title).toList()),
        second.seasons.map((s) => s.episodes.map((e) => e.title).toList()),
      );
    });

    test('throws NotFoundException for an unknown id', () async {
      expect(
        () => source.fetchContentDetails('nope'),
        throwsA(isA<NotFoundException>()),
      );
    });
  });

  group('fetchPlayable', () {
    test('resolves a movie identifier', () async {
      final playable = await source.fetchPlayable('the-long-descent');

      expect(playable.id, 'the-long-descent');
      expect(playable.contentId, 'the-long-descent');
      expect(playable.streamUrl, isNotEmpty);
    });

    test('resolves an episode identifier', () async {
      final playable = await source.fetchPlayable('harbour-lights-s2e3');

      expect(playable.id, 'harbour-lights-s2e3');
      expect(playable.title, contains('S2 E3'));
      expect(playable.streamUrl, isNotEmpty);
    });

    test('groups an episode under its series', () async {
      final playable = await source.fetchPlayable('harbour-lights-s1e1');

      // History shows one row per show, not one per episode watched.
      expect(playable.contentId, 'harbour-lights');
    });

    test('borrows the series artwork for an episode', () async {
      final series = await source.fetchContentById('harbour-lights');
      final playable = await source.fetchPlayable('harbour-lights-s1e1');

      expect(playable.posterUrl, series.posterUrl);
      expect(playable.releaseYear, series.releaseYear);
    });

    test('rejects an episode of a season that does not exist', () async {
      expect(
        () => source.fetchPlayable('harbour-lights-s9e1'),
        throwsA(isA<NotFoundException>()),
      );
    });

    test('rejects an episode number beyond the season', () async {
      expect(
        () => source.fetchPlayable('harbour-lights-s1e99'),
        throwsA(isA<NotFoundException>()),
      );
    });

    test('rejects an episode of a movie', () async {
      expect(
        () => source.fetchPlayable('the-long-descent-s1e1'),
        throwsA(isA<NotFoundException>()),
      );
    });

    test('rejects an unrecognised identifier', () async {
      expect(
        () => source.fetchPlayable('nonsense'),
        throwsA(isA<NotFoundException>()),
      );
    });

    test('every episode the details screen lists is playable', () async {
      final details = await source.fetchContentDetails('harbour-lights');

      // The bug this guards against: details offering episodes the player
      // cannot open.
      for (final season in details.seasons) {
        for (final episode in season.episodes) {
          await expectLater(source.fetchPlayable(episode.id), completes);
        }
      }
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
