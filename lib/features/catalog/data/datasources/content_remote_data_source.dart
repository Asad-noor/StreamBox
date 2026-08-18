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

/// Where catalogue data comes from.
///
/// Implementations throw [AppException] on failure; the repository converts
/// those into `Result`. Declared as an interface so the fake used today and a
/// Dio-backed implementation later are interchangeable to the repository.
abstract interface class ContentRemoteDataSource {
  Future<HomeFeedDto> fetchHomeFeed();

  Future<ContentModel> fetchContentById(String id);

  Future<SearchResultsDto> searchContent({
    required String query,
    required int page,
    required int pageSize,
  });
}
