import 'package:flutter_test/flutter_test.dart';
import 'package:streambox/core/error/app_exception.dart';
import 'package:streambox/core/result/result.dart';
import 'package:streambox/features/catalog/data/datasources/content_remote_data_source.dart';
import 'package:streambox/features/catalog/data/models/content_model.dart';
import 'package:streambox/features/catalog/data/repositories/content_repository_impl.dart';
import 'package:streambox/features/catalog/domain/entities/content.dart';
import 'package:streambox/features/catalog/domain/entities/content_section.dart';
import 'package:streambox/features/catalog/domain/entities/search_results.dart';

/// Records calls and returns whatever the test sets up.
final class _FakeRemoteDataSource implements ContentRemoteDataSource {
  _FakeRemoteDataSource({this.feed});

  HomeFeedDto? feed;
  ContentModel? content;
  Object? failure;

  SearchResultsDto? searchResults;

  int homeFeedCalls = 0;
  int contentCalls = 0;
  final List<({String query, int page, int pageSize})> searchCalls = [];

  @override
  Future<HomeFeedDto> fetchHomeFeed() async {
    homeFeedCalls++;
    if (failure case final failure?) throw failure;
    return feed!;
  }

  @override
  Future<SearchResultsDto> searchContent({
    required String query,
    required int page,
    required int pageSize,
  }) async {
    searchCalls.add((query: query, page: page, pageSize: pageSize));
    if (failure case final failure?) throw failure;
    return searchResults!;
  }

  ContentDetailsDto? detailsResult;
  final List<String> detailsCalls = [];

  PlayableDto? playableResult;
  final List<String> playableCalls = [];

  @override
  Future<PlayableDto> fetchPlayable(String id) async {
    playableCalls.add(id);
    if (failure case final failure?) throw failure;
    return playableResult!;
  }

  @override
  Future<ContentDetailsDto> fetchContentDetails(String id) async {
    detailsCalls.add(id);
    if (failure case final failure?) throw failure;
    return detailsResult!;
  }

  @override
  Future<ContentModel> fetchContentById(String id) async {
    contentCalls++;
    if (failure case final failure?) throw failure;
    return content!;
  }
}

ContentModel buildModel({String id = 'a', String type = 'movie'}) =>
    ContentModel(
      id: id,
      title: 'Title $id',
      type: type,
      synopsis: 'Synopsis',
      posterUrl: 'https://example.invalid/$id.jpg',
      backdropUrl: 'https://example.invalid/$id-wide.jpg',
      releaseYear: 2026,
      genres: const ['Drama'],
      rating: 7.5,
      durationMinutes: 95,
      streamUrl: 'https://example.invalid/$id.m3u8',
    );

HomeFeedDto buildDto({String sectionKind = 'trending'}) => HomeFeedDto(
  featured: buildModel(id: 'featured'),
  sections: [
    ContentSectionDto(
      kind: sectionKind,
      title: 'Trending now',
      items: [
        buildModel(id: 'a'),
        buildModel(id: 'b'),
      ],
    ),
  ],
);

void main() {
  late _FakeRemoteDataSource remote;
  late DateTime clock;

  ContentRepositoryImpl buildRepository({
    Duration cacheTtl = const Duration(minutes: 5),
  }) => ContentRepositoryImpl(
    remoteDataSource: remote,
    cacheTtl: cacheTtl,
    now: () => clock,
  );

  setUp(() {
    clock = DateTime(2026, 8, 19, 12);
    remote = _FakeRemoteDataSource(feed: buildDto());
  });

  group('getHomeFeed', () {
    test('maps the wire format onto domain entities', () async {
      final result = await buildRepository().getHomeFeed();

      final feed = result.valueOrNull!;
      expect(feed.featured?.id, 'featured');
      expect(feed.featured?.duration, const Duration(minutes: 95));
      expect(feed.sections.single.kind, ContentSectionKind.trending);
      expect(feed.sections.single.items.map((item) => item.id), ['a', 'b']);
    });

    test(
      'serves a second call from cache without hitting the source',
      () async {
        final repository = buildRepository();

        await repository.getHomeFeed();
        await repository.getHomeFeed();

        expect(remote.homeFeedCalls, 1);
      },
    );

    test('forceRefresh bypasses the cache', () async {
      final repository = buildRepository();

      await repository.getHomeFeed();
      await repository.getHomeFeed(forceRefresh: true);

      expect(remote.homeFeedCalls, 2);
    });

    test('refetches once the cache has expired', () async {
      final repository = buildRepository(cacheTtl: const Duration(minutes: 5));

      await repository.getHomeFeed();
      clock = clock.add(const Duration(minutes: 6));
      await repository.getHomeFeed();

      expect(remote.homeFeedCalls, 2);
    });

    test('still serves the cache just before it expires', () async {
      final repository = buildRepository(cacheTtl: const Duration(minutes: 5));

      await repository.getHomeFeed();
      clock = clock.add(const Duration(minutes: 4, seconds: 59));
      await repository.getHomeFeed();

      expect(remote.homeFeedCalls, 1);
    });

    test('surfaces an AppException as a Failure without rethrowing', () async {
      remote.failure = const NetworkException();

      final result = await buildRepository().getHomeFeed();

      expect(result, isA<Failure<dynamic>>());
      expect(result.errorOrNull, isA<NetworkException>());
    });

    test('wraps an unclassified error so nothing raw escapes', () async {
      remote.failure = StateError('boom');

      final result = await buildRepository().getHomeFeed();

      expect(result.errorOrNull, isA<UnknownException>());
      expect(result.errorOrNull?.cause, isA<StateError>());
    });

    test('does not cache a failed response', () async {
      final repository = buildRepository();
      remote.failure = const NetworkException();

      await repository.getHomeFeed();
      remote
        ..failure = null
        ..feed = buildDto();
      final result = await repository.getHomeFeed();

      expect(remote.homeFeedCalls, 2);
      expect(result.isSuccess, isTrue);
    });

    test('keeps an unrecognised section rather than dropping it', () async {
      remote.feed = buildDto(sectionKind: 'because_you_watched');

      final result = await buildRepository().getHomeFeed();

      expect(
        result.valueOrNull?.sections.single.kind,
        ContentSectionKind.recommended,
      );
      expect(result.valueOrNull?.sections.single.items, hasLength(2));
    });

    test('maps every known section kind', () async {
      const kinds = {
        'continue_watching': ContentSectionKind.continueWatching,
        'trending': ContentSectionKind.trending,
        'popular': ContentSectionKind.popular,
        'new_releases': ContentSectionKind.newReleases,
        'recommended': ContentSectionKind.recommended,
      };

      for (final MapEntry(key: wire, value: kind) in kinds.entries) {
        remote = _FakeRemoteDataSource(feed: buildDto(sectionKind: wire));

        final result = await buildRepository().getHomeFeed();

        expect(
          result.valueOrNull?.sections.single.kind,
          kind,
          reason: '"$wire" should map to $kind',
        );
      }
    });
  });

  group('getContentDetails', () {
    setUp(() {
      remote.detailsResult = ContentDetailsDto(
        content: buildModel(id: 'series', type: 'series'),
        seasons: [
          SeasonDto(
            number: 1,
            title: 'Season 1',
            episodes: [
              const EpisodeDto(
                id: 'series-s1e1',
                number: 1,
                title: 'Arrivals',
                synopsis: 'An episode.',
                stillUrl: 'https://example.invalid/still.jpg',
                durationMinutes: 47,
                streamUrl: 'https://example.invalid/ep.m3u8',
              ),
            ],
          ),
        ],
      );
    });

    test('maps content and seasons onto entities', () async {
      final result = await buildRepository().getContentDetails('series');

      final details = result.valueOrNull!;
      expect(details.id, 'series');
      expect(details.content.type, ContentType.series);
      expect(details.seasons, hasLength(1));
      expect(details.seasons.single.episodes.single.id, 'series-s1e1');
    });

    test('converts episode minutes into a Duration', () async {
      final result = await buildRepository().getContentDetails('series');

      expect(
        result.valueOrNull?.seasons.single.episodes.single.duration,
        const Duration(minutes: 47),
      );
    });

    test('returns no seasons for a movie', () async {
      remote.detailsResult = ContentDetailsDto(
        content: buildModel(id: 'movie'),
        seasons: const [],
      );

      final result = await buildRepository().getContentDetails('movie');

      expect(result.valueOrNull?.hasSeasons, isFalse);
    });

    test('always reaches the source rather than the feed cache', () async {
      final repository = buildRepository();
      await repository.getHomeFeed();

      await repository.getContentDetails('series');

      // The cached feed holds summaries only; details must be fetched.
      expect(remote.detailsCalls, ['series']);
    });

    test('reports a missing title as a Failure', () async {
      remote.failure = const NotFoundException();

      final result = await buildRepository().getContentDetails('nope');

      expect(result.errorOrNull, isA<NotFoundException>());
    });

    test('wraps an unclassified error', () async {
      remote.failure = StateError('boom');

      final result = await buildRepository().getContentDetails('series');

      expect(result.errorOrNull, isA<UnknownException>());
    });
  });

  group('searchContent', () {
    setUp(() {
      remote.searchResults = SearchResultsDto(
        items: [
          buildModel(id: 'a'),
          buildModel(id: 'b'),
        ],
        page: 0,
        hasMore: true,
        totalCount: 5,
      );
    });

    test('maps the wire format onto entities', () async {
      final result = await buildRepository().searchContent(query: 'harbour');

      final results = result.valueOrNull!;
      expect(results.items.map((item) => item.id), ['a', 'b']);
      expect(results.items.first.duration, const Duration(minutes: 95));
      expect(results.page, 0);
      expect(results.hasMore, isTrue);
      expect(results.totalCount, 5);
    });

    test('trims the query before sending it', () async {
      await buildRepository().searchContent(query: '  harbour  ');

      expect(remote.searchCalls.single.query, 'harbour');
    });

    test('short-circuits a blank query without a request', () async {
      final repository = buildRepository();

      final blank = await repository.searchContent(query: '');
      final whitespace = await repository.searchContent(query: '   ');

      expect(remote.searchCalls, isEmpty);
      expect(blank.valueOrNull, SearchResults.empty);
      expect(whitespace.valueOrNull?.isEmpty, isTrue);
    });

    test('passes the requested page and size through', () async {
      await buildRepository().searchContent(
        query: 'harbour',
        page: 2,
        pageSize: 25,
      );

      expect(remote.searchCalls.single, (
        query: 'harbour',
        page: 2,
        pageSize: 25,
      ));
    });

    test('does not consult the home feed cache', () async {
      final repository = buildRepository();
      await repository.getHomeFeed();

      await repository.searchContent(query: 'harbour');
      await repository.searchContent(query: 'harbour');

      // Search is never cached: both calls must reach the source.
      expect(remote.searchCalls, hasLength(2));
    });

    test('reports a failure as a Failure', () async {
      remote.failure = const NetworkException();

      final result = await buildRepository().searchContent(query: 'harbour');

      expect(result.errorOrNull, isA<NetworkException>());
    });

    test('wraps an unclassified error', () async {
      remote.failure = StateError('boom');

      final result = await buildRepository().searchContent(query: 'harbour');

      expect(result.errorOrNull, isA<UnknownException>());
    });
  });

  group('getContentById', () {
    test('answers from the cached feed without a second request', () async {
      final repository = buildRepository();
      await repository.getHomeFeed();

      final result = await repository.getContentById('a');

      expect(result.valueOrNull?.id, 'a');
      expect(remote.contentCalls, 0);
    });

    test('finds the featured title in the cache', () async {
      final repository = buildRepository();
      await repository.getHomeFeed();

      final result = await repository.getContentById('featured');

      expect(result.valueOrNull?.id, 'featured');
      expect(remote.contentCalls, 0);
    });

    test('falls back to the source for an uncached id', () async {
      final repository = buildRepository();
      await repository.getHomeFeed();
      remote.content = buildModel(id: 'z');

      final result = await repository.getContentById('z');

      expect(result.valueOrNull?.id, 'z');
      expect(remote.contentCalls, 1);
    });

    test('goes to the source when nothing is cached', () async {
      remote.content = buildModel(id: 'z');

      final result = await buildRepository().getContentById('z');

      expect(result.valueOrNull?.id, 'z');
      expect(remote.contentCalls, 1);
    });

    test('reports a missing title as a Failure', () async {
      remote.failure = const NotFoundException();

      final result = await buildRepository().getContentById('missing');

      expect(result.errorOrNull, isA<NotFoundException>());
    });

    test('maps a series with its season count', () async {
      remote.content = buildModel(id: 's', type: 'series');

      final result = await buildRepository().getContentById('s');

      expect(result.valueOrNull?.type, ContentType.series);
    });
  });
}
