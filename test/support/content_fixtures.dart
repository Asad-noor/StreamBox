import 'package:streambox/features/catalog/domain/entities/content.dart';
import 'package:streambox/features/catalog/domain/entities/content_section.dart';
import 'package:streambox/features/catalog/domain/entities/home_feed.dart';

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
