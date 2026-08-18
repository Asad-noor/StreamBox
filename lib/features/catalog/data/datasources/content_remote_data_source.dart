import 'package:streambox/features/catalog/data/models/content_model.dart';

/// One rail as it arrives from the source.
class ContentSectionDto {
  const ContentSectionDto({
    required this.kind,
    required this.title,
    required this.items,
  });

  final String kind;
  final String title;
  final List<ContentModel> items;
}

/// The home feed as it arrives from the source.
class HomeFeedDto {
  const HomeFeedDto({required this.featured, required this.sections});

  final ContentModel? featured;
  final List<ContentSectionDto> sections;
}

/// One page of search results as it arrives from the source.
class SearchResultsDto {
  const SearchResultsDto({
    required this.items,
    required this.page,
    required this.hasMore,
    required this.totalCount,
  });

  final List<ContentModel> items;
  final int page;
  final bool hasMore;
  final int totalCount;
}

/// One episode as it arrives from the source.
class EpisodeDto {
  const EpisodeDto({
    required this.id,
    required this.number,
    required this.title,
    required this.synopsis,
    required this.stillUrl,
    required this.durationMinutes,
    this.streamUrl,
  });

  final String id;
  final int number;
  final String title;
  final String synopsis;
  final String stillUrl;
  final int durationMinutes;
  final String? streamUrl;
}

/// One season as it arrives from the source.
class SeasonDto {
  const SeasonDto({
    required this.number,
    required this.title,
    required this.episodes,
  });

  final int number;
  final String title;
  final List<EpisodeDto> episodes;
}

/// The full record for one title as it arrives from the source.
class ContentDetailsDto {
  const ContentDetailsDto({required this.content, required this.seasons});

  final ContentModel content;
  final List<SeasonDto> seasons;
}

/// Where catalogue data comes from.
///
/// Implementations throw [AppException] on failure; the repository converts
/// those into `Result`. Declared as an interface so the fake used today and a
/// Dio-backed implementation later are interchangeable to the repository.
abstract interface class ContentRemoteDataSource {
  Future<HomeFeedDto> fetchHomeFeed();

  Future<ContentModel> fetchContentById(String id);

  Future<ContentDetailsDto> fetchContentDetails(String id);

  Future<SearchResultsDto> searchContent({
    required String query,
    required int page,
    required int pageSize,
  });
}
