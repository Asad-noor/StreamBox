import 'package:streambox/features/catalog/domain/entities/content.dart';
import 'package:streambox/features/catalog/domain/entities/content_details.dart';
import 'package:streambox/features/catalog/domain/entities/content_section.dart';
import 'package:streambox/features/catalog/domain/entities/content_snapshot.dart';
import 'package:streambox/features/catalog/domain/entities/episode.dart';
import 'package:streambox/features/catalog/domain/entities/home_feed.dart';
import 'package:streambox/features/catalog/domain/entities/season.dart';

/// Hand-built entities for tests.
///
/// Kept separate from the fake data source so that domain and presentation
/// tests do not depend on whatever the catalogue happens to contain.
Content buildContent({
  String id = 'test-id',
  String title = 'Test Title',
  ContentType type = ContentType.movie,
  String synopsis = 'A synopsis.',
  int releaseYear = 2026,
  List<String> genres = const ['Drama'],
  double rating = 7.5,
  Duration duration = const Duration(minutes: 95),
  String? streamUrl = 'https://example.invalid/stream.m3u8',
  int? seasonCount,
}) => Content(
  id: id,
  title: title,
  type: type,
  synopsis: synopsis,
  posterUrl: 'https://example.invalid/$id/poster.jpg',
  backdropUrl: 'https://example.invalid/$id/backdrop.jpg',
  releaseYear: releaseYear,
  genres: genres,
  rating: rating,
  duration: duration,
  streamUrl: streamUrl,
  seasonCount: seasonCount,
);

ContentSection buildSection({
  ContentSectionKind kind = ContentSectionKind.trending,
  String title = 'Trending now',
  List<Content>? items,
}) => ContentSection(
  kind: kind,
  title: title,
  items: items ?? [buildContent(id: 'a'), buildContent(id: 'b')],
);

HomeFeed buildHomeFeed({Content? featured, List<ContentSection>? sections}) =>
    HomeFeed(
      featured: featured ?? buildContent(id: 'featured', title: 'Featured'),
      sections: sections ?? [buildSection()],
    );

Episode buildEpisode({
  String id = 'ep-1',
  int number = 1,
  String title = 'Arrivals',
  String synopsis = 'An episode synopsis.',
  Duration duration = const Duration(minutes: 47),
  String? streamUrl = 'https://example.invalid/ep.m3u8',
}) => Episode(
  id: id,
  number: number,
  title: title,
  synopsis: synopsis,
  stillUrl: 'https://example.invalid/$id/still.jpg',
  duration: duration,
  streamUrl: streamUrl,
);

Season buildSeason({
  int number = 1,
  String? title,
  int episodeCount = 3,
  List<Episode>? episodes,
}) => Season(
  number: number,
  title: title ?? 'Season $number',
  episodes:
      episodes ??
      [
        for (var index = 1; index <= episodeCount; index++)
          buildEpisode(
            id: 's${number}e$index',
            number: index,
            title: 'Episode $index',
          ),
      ],
);

/// A movie: no seasons.
ContentDetails buildMovieDetails({Content? content}) =>
    ContentDetails(content: content ?? buildContent(id: 'movie-1'));

/// A series with [seasonCount] seasons.
ContentDetails buildSeriesDetails({
  Content? content,
  int seasonCount = 2,
  List<Season>? seasons,
}) => ContentDetails(
  content:
      content ??
      buildContent(
        id: 'series-1',
        title: 'Harbour Lights',
        type: ContentType.series,
        seasonCount: seasonCount,
      ),
  seasons:
      seasons ??
      [
        for (var index = 1; index <= seasonCount; index++)
          buildSeason(number: index),
      ],
);

ContentSnapshot buildSnapshot({
  String contentId = 'test-id',
  String title = 'Test Title',
  int releaseYear = 2026,
}) => ContentSnapshot(
  contentId: contentId,
  title: title,
  posterUrl: 'https://example.invalid/$contentId/poster.jpg',
  releaseYear: releaseYear,
);
