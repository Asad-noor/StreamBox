import 'package:streambox/core/constants/media_constants.dart';
import 'package:streambox/core/error/app_exception.dart';
import 'package:streambox/features/catalog/data/datasources/content_remote_data_source.dart';
import 'package:streambox/features/catalog/data/models/content_model.dart';

/// Serves a fixed catalogue from memory.
///
/// Stands in for a backend that does not exist yet. It is deliberately a
/// [ContentRemoteDataSource] like any other, so swapping in a Dio-backed
/// implementation is a one-line provider change and nothing above the data
/// layer is aware of the difference.
///
/// [latency] and [failure] exist so tests and the design gallery can exercise
/// slow and failing responses without a network.
final class FakeContentRemoteDataSource implements ContentRemoteDataSource {
  const FakeContentRemoteDataSource({
    this.latency = const Duration(milliseconds: 600),
    this.failure,
  });

  /// Simulated round-trip time, so skeletons are actually visible in
  /// development instead of flashing for one frame.
  final Duration latency;

  /// When set, every call throws this instead of returning data.
  final AppException? failure;

  @override
  Future<HomeFeedDto> fetchHomeFeed() async {
    await _simulateRequest();

    return HomeFeedDto(
      featured: _catalogue.first,
      sections: [
        _section(ContentSectionKindKeys.trending, 'Trending now', _pick(1, 8)),
        _section(
          ContentSectionKindKeys.popular,
          'Popular on StreamBox',
          _pick(4, 12),
        ),
        _section(
          ContentSectionKindKeys.newReleases,
          'New releases',
          _pick(8, 14),
        ),
        _section(
          ContentSectionKindKeys.recommended,
          'Recommended for you',
          _pick(2, 10),
        ),
      ],
    );
  }

  @override
  Future<ContentModel> fetchContentById(String id) async {
    await _simulateRequest();

    final match = _catalogue.where((item) => item.id == id).firstOrNull;
    if (match == null) throw const NotFoundException();

    return match;
  }

  @override
  Future<ContentDetailsDto> fetchContentDetails(String id) async {
    await _simulateRequest();

    final match = _catalogue.where((item) => item.id == id).firstOrNull;
    if (match == null) throw const NotFoundException();

    return ContentDetailsDto(
      content: match,
      seasons: match.seasonCount == null
          ? const []
          : _buildSeasons(match, match.seasonCount!),
    );
  }

  /// Episode counts and titles are derived from the title's identifier so the
  /// same series always produces the same episodes, in tests and at runtime.
  List<SeasonDto> _buildSeasons(ContentModel series, int seasonCount) {
    return [
      for (var season = 1; season <= seasonCount; season++)
        SeasonDto(
          number: season,
          title: 'Season $season',
          episodes: [
            for (var episode = 1; episode <= _episodesPerSeason; episode++)
              EpisodeDto(
                id: '${series.id}-s${season}e$episode',
                number: episode,
                title: _episodeTitle(season, episode),
                synopsis: series.synopsis,
                stillUrl: MediaConstants.backdropUrl(
                  '${series.id}-s${season}e$episode',
                ),
                durationMinutes: series.durationMinutes,
                streamUrl: MediaConstants.sampleHlsStream,
              ),
          ],
        ),
    ];
  }

  static const int _episodesPerSeason = 6;

  /// Offset by season so the same six titles are not repeated verbatim in
  /// every season.
  static String _episodeTitle(int season, int episode) {
    const titles = [
      'Arrivals',
      'The Long Way Round',
      'What the Tide Left',
      'Small Hours',
      'Everything Owed',
      'Last Light',
    ];

    return titles[(season * 2 + episode - 1) % titles.length];
  }

  @override
  Future<PlayableDto> fetchPlayable(String id) async {
    await _simulateRequest();

    // A title identifier resolves directly.
    final title = _catalogue.where((item) => item.id == id).firstOrNull;
    if (title != null) {
      final streamUrl = title.streamUrl;
      if (streamUrl == null || streamUrl.isEmpty) {
        throw const NotFoundException();
      }

      return PlayableDto(
        id: title.id,
        title: title.title,
        streamUrl: streamUrl,
        posterUrl: title.posterUrl,
        releaseYear: title.releaseYear,
        contentId: title.id,
      );
    }

    // Otherwise it may be an episode of a series.
    return _episodePlayable(id);
  }

  /// Episode identifiers are `<seriesId>-s<season>e<episode>`.
  PlayableDto _episodePlayable(String id) {
    final match = RegExp(r'^(.+)-s(\d+)e(\d+)$').firstMatch(id);
    if (match == null) throw const NotFoundException();

    final seriesId = match.group(1)!;
    final series = _catalogue.where((item) => item.id == seriesId).firstOrNull;
    if (series?.seasonCount == null) throw const NotFoundException();

    final season = int.parse(match.group(2)!);
    final episode = int.parse(match.group(3)!);

    if (season < 1 || season > series!.seasonCount!) {
      throw const NotFoundException();
    }
    if (episode < 1 || episode > _episodesPerSeason) {
      throw const NotFoundException();
    }

    return PlayableDto(
      id: id,
      title: '${series.title} S$season E$episode',
      streamUrl: MediaConstants.sampleHlsStream,
      posterUrl: series.posterUrl,
      releaseYear: series.releaseYear,
      // Grouped under the series so history shows one row per show rather
      // than one per episode watched.
      contentId: seriesId,
    );
  }

  @override
  Future<SearchResultsDto> searchContent({
    required String query,
    required int page,
    required int pageSize,
  }) async {
    await _simulateRequest();

    final matches = _matching(query);
    final start = page * pageSize;

    if (start >= matches.length) {
      return SearchResultsDto(
        items: const [],
        page: page,
        hasMore: false,
        totalCount: matches.length,
      );
    }

    final end = (start + pageSize).clamp(start, matches.length);

    return SearchResultsDto(
      items: matches.sublist(start, end),
      page: page,
      hasMore: end < matches.length,
      totalCount: matches.length,
    );
  }

  /// Matches title, genre and synopsis, in that order of preference, so that
  /// a title match always outranks an incidental word in a description.
  List<ContentModel> _matching(String query) {
    final needle = query.trim().toLowerCase();
    if (needle.isEmpty) return const [];

    final byTitle = <ContentModel>[];
    final byGenre = <ContentModel>[];
    final bySynopsis = <ContentModel>[];

    for (final item in _catalogue) {
      if (item.title.toLowerCase().contains(needle)) {
        byTitle.add(item);
      } else if (item.genres.any((g) => g.toLowerCase().contains(needle))) {
        byGenre.add(item);
      } else if (item.synopsis.toLowerCase().contains(needle)) {
        bySynopsis.add(item);
      }
    }

    return [...byTitle, ...byGenre, ...bySynopsis];
  }

  Future<void> _simulateRequest() async {
    if (latency > Duration.zero) await Future<void>.delayed(latency);
    if (failure case final failure?) throw failure;
  }

  ContentSectionDto _section(
    String kind,
    String title,
    List<ContentModel> items,
  ) => ContentSectionDto(kind: kind, title: title, items: items);

  List<ContentModel> _pick(int start, int end) =>
      _catalogue.sublist(start, end.clamp(start, _catalogue.length));

  static List<ContentModel> get _catalogue => _catalogueData;
}

/// The `kind` strings the fake emits, matching what a real API would send.
abstract final class ContentSectionKindKeys {
  static const String continueWatching = 'continue_watching';
  static const String trending = 'trending';
  static const String popular = 'popular';
  static const String newReleases = 'new_releases';
  static const String recommended = 'recommended';
}

ContentModel _movie({
  required String id,
  required String title,
  required String synopsis,
  required int year,
  required List<String> genres,
  required double rating,
  required int minutes,
}) => ContentModel(
  id: id,
  title: title,
  type: 'movie',
  synopsis: synopsis,
  posterUrl: MediaConstants.posterUrl(id),
  backdropUrl: MediaConstants.backdropUrl(id),
  releaseYear: year,
  genres: genres,
  rating: rating,
  durationMinutes: minutes,
  streamUrl: MediaConstants.sampleHlsStream,
);

ContentModel _series({
  required String id,
  required String title,
  required String synopsis,
  required int year,
  required List<String> genres,
  required double rating,
  required int minutes,
  required int seasons,
}) => ContentModel(
  id: id,
  title: title,
  type: 'series',
  synopsis: synopsis,
  posterUrl: MediaConstants.posterUrl(id),
  backdropUrl: MediaConstants.backdropUrl(id),
  releaseYear: year,
  genres: genres,
  rating: rating,
  durationMinutes: minutes,
  streamUrl: MediaConstants.sampleHlsStream,
  seasonCount: seasons,
);

/// Fixed so that every run, screenshot, and test sees the same catalogue.
final List<ContentModel> _catalogueData = [
  _movie(
    id: 'the-long-descent',
    title: 'The Long Descent',
    synopsis:
        'A salvage crew wakes from cryosleep to find their ship three hundred '
        'years off course, low on air, and no longer alone aboard.',
    year: 2026,
    genres: ['Sci-fi', 'Thriller'],
    rating: 8.4,
    minutes: 112,
  ),
  _series(
    id: 'harbour-lights',
    title: 'Harbour Lights',
    synopsis:
        'A detective returns to the fishing town she grew up in and finds the '
        'case that made her leave has never really closed.',
    year: 2025,
    genres: ['Crime', 'Drama'],
    rating: 8.9,
    minutes: 52,
    seasons: 3,
  ),
  _movie(
    id: 'paper-cities',
    title: 'Paper Cities',
    synopsis:
        'An architect discovers the district she designed has been quietly '
        'rebuilt to someone else\'s plans.',
    year: 2024,
    genres: ['Mystery', 'Drama'],
    rating: 7.6,
    minutes: 98,
  ),
  _series(
    id: 'signal-fire',
    title: 'Signal Fire',
    synopsis:
        'Six strangers receive the same broadcast on six different nights, in '
        'six different countries.',
    year: 2026,
    genres: ['Sci-fi', 'Mystery'],
    rating: 8.1,
    minutes: 47,
    seasons: 2,
  ),
  _movie(
    id: 'the-quiet-quarter',
    title: 'The Quiet Quarter',
    synopsis:
        'On the last night of a city-wide blackout, a courier has four hours '
        'to deliver something she was told not to open.',
    year: 2025,
    genres: ['Thriller'],
    rating: 7.9,
    minutes: 104,
  ),
  _series(
    id: 'under-the-arches',
    title: 'Under the Arches',
    synopsis:
        'A market trader, a night nurse and a failing chef share one railway '
        'arch and very different plans for it.',
    year: 2024,
    genres: ['Comedy', 'Drama'],
    rating: 8.2,
    minutes: 38,
    seasons: 4,
  ),
  _movie(
    id: 'northlight',
    title: 'Northlight',
    synopsis:
        'A glaciologist studying an unusual melt pattern realises the ice is '
        'keeping better records than anyone intended.',
    year: 2026,
    genres: ['Drama', 'Sci-fi'],
    rating: 7.4,
    minutes: 121,
  ),
  _movie(
    id: 'seventeen-summers',
    title: 'Seventeen Summers',
    synopsis:
        'Two friends promise to meet on the same pier every August. One of '
        'them keeps it.',
    year: 2023,
    genres: ['Romance', 'Drama'],
    rating: 8.6,
    minutes: 107,
  ),
  _series(
    id: 'the-inheritance-office',
    title: 'The Inheritance Office',
    synopsis:
        'The civil servants who decide what happens to estates with no heirs '
        'find one that names them personally.',
    year: 2025,
    genres: ['Comedy', 'Mystery'],
    rating: 7.8,
    minutes: 44,
    seasons: 2,
  ),
  _movie(
    id: 'low-tide',
    title: 'Low Tide',
    synopsis:
        'Every twelve hours the causeway clears for forty minutes. Tonight, '
        'someone is counting on it not to.',
    year: 2024,
    genres: ['Thriller', 'Crime'],
    rating: 7.2,
    minutes: 94,
  ),
  _series(
    id: 'the-cartographers',
    title: 'The Cartographers',
    synopsis:
        'A mapping team surveys a valley that appears on no earlier chart, and '
        'that the nearest village will not discuss.',
    year: 2026,
    genres: ['Mystery', 'Sci-fi'],
    rating: 8.7,
    minutes: 51,
    seasons: 1,
  ),
  _movie(
    id: 'gravity-well',
    title: 'Gravity Well',
    synopsis:
        'A mining station\'s orbit is decaying, the evacuation window is nine '
        'hours, and the shuttle seats forty of the sixty-one aboard.',
    year: 2025,
    genres: ['Sci-fi', 'Thriller'],
    rating: 8.0,
    minutes: 118,
  ),
  _movie(
    id: 'the-understudy',
    title: 'The Understudy',
    synopsis:
        'She has covered the same role for eleven years. Tonight the lead does '
        'not arrive, and neither does anyone else.',
    year: 2023,
    genres: ['Drama', 'Thriller'],
    rating: 7.5,
    minutes: 101,
  ),
  _series(
    id: 'crossing-the-fens',
    title: 'Crossing the Fens',
    synopsis:
        'A rural vet, a drainage engineer and a very old dispute about where '
        'the water is allowed to go.',
    year: 2024,
    genres: ['Drama'],
    rating: 7.1,
    minutes: 49,
    seasons: 2,
  ),
];
