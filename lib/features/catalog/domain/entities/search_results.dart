import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:streambox/features/catalog/domain/entities/content.dart';

part 'search_results.freezed.dart';

/// One page of search results.
///
/// Carries the paging cursor with the data so the caller never has to track
/// page numbers separately and risk them drifting out of sync with the items.
@freezed
abstract class SearchResults with _$SearchResults {
  const factory SearchResults({
    required List<Content> items,

    /// Zero-based index of the page these [items] came from.
    required int page,

    /// Whether requesting `page + 1` would return anything.
    required bool hasMore,

    /// Total matches across all pages, for the result count in the UI.
    required int totalCount,
  }) = _SearchResults;

  const SearchResults._();

  static const SearchResults empty = SearchResults(
    items: [],
    page: 0,
    hasMore: false,
    totalCount: 0,
  );

  bool get isEmpty => items.isEmpty;

  /// The page to request next, or null when the list is exhausted.
  int? get nextPage => hasMore ? page + 1 : null;

  /// Appends [next] onto this page, producing the combined list the UI shows.
  SearchResults append(SearchResults next) =>
      next.copyWith(items: [...items, ...next.items]);
}
