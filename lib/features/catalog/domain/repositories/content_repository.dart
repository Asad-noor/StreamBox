import 'package:streambox/core/result/result.dart';
import 'package:streambox/features/catalog/domain/entities/content.dart';
import 'package:streambox/features/catalog/domain/entities/content_details.dart';
import 'package:streambox/features/catalog/domain/entities/home_feed.dart';
import 'package:streambox/features/catalog/domain/entities/search_results.dart';

/// The catalogue's contract with the rest of the application.
///
/// Lives in the domain layer and names no infrastructure, so the presentation
/// layer can be tested against a hand-written fake and the implementation can
/// move from a local source to a REST API without anything above it changing.
///
/// Methods return [Result] rather than throwing: callers are forced by the
/// type system to handle failure.
abstract interface class ContentRepository {
  /// Everything the home screen needs, in one call.
  Future<Result<HomeFeed>> getHomeFeed({bool forceRefresh = false});

  /// A single title, for the details screen and for resuming playback.
  Future<Result<Content>> getContentById(String id);

  /// The full record for one title, including seasons for a series.
  ///
  /// Separate from [getContentById] because it is a heavier payload: rails and
  /// search only ever need the summary.
  Future<Result<ContentDetails>> getContentDetails(String id);

  /// One page of titles matching [query].
  ///
  /// Search lives on this repository rather than a separate one because it
  /// reads the same catalogue: a parallel contract would mean two sources of
  /// truth for the same entity.
  Future<Result<SearchResults>> searchContent({
    required String query,
    int page,
    int pageSize,
  });
}
