import 'package:streambox/core/result/result.dart';
import 'package:streambox/features/catalog/domain/entities/search_results.dart';
import 'package:streambox/features/catalog/domain/repositories/content_repository.dart';

/// Runs one page of a search.
final class SearchContentUseCase {
  const SearchContentUseCase(this._repository);

  final ContentRepository _repository;

  /// Titles matching [query], one page at a time.
  ///
  /// [page] is zero-based. Paging is the caller's concern: the notifier knows
  /// which page it is on and how results should be combined, whereas this
  /// use case only knows how to fetch one.
  Future<Result<SearchResults>> call({required String query, int page = 0}) =>
      _repository.searchContent(query: query, page: page);
}
