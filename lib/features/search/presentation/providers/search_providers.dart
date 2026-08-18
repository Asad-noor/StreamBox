import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:streambox/core/result/result.dart';
import 'package:streambox/features/catalog/data/providers/catalog_providers.dart';
import 'package:streambox/features/search/domain/usecases/search_content.dart';
import 'package:streambox/features/search/presentation/providers/search_state.dart';

part 'search_providers.g.dart';

@Riverpod(keepAlive: true)
SearchContentUseCase searchContentUseCase(Ref ref) =>
    SearchContentUseCase(ref.watch(contentRepositoryProvider));

/// Owns the search screen's state.
///
/// Two things this class exists to get right:
///
/// * **Debounce.** Typing does not issue a request per keystroke; the query
///   settles for [_debounce] first.
/// * **Staleness.** Debounce alone is not enough. A slow response for "har"
///   can still land after a fast one for "harbour" and overwrite it, so every
///   request carries a token and only the newest one is allowed to write.
@riverpod
class SearchNotifier extends _$SearchNotifier {
  static const Duration _debounce = Duration(milliseconds: 350);

  Timer? _debounceTimer;

  /// Incremented per query. A response whose token is not the current one is
  /// discarded rather than applied.
  int _requestToken = 0;

  @override
  SearchState build() {
    ref.onDispose(() => _debounceTimer?.cancel());

    return const SearchState.idle();
  }

  /// Called on every keystroke.
  void onQueryChanged(String query) {
    _debounceTimer?.cancel();

    final trimmed = query.trim();

    if (trimmed.isEmpty) {
      // Clearing the field returns to the prompt immediately: there is no
      // request to wait for, and holding stale results would be misleading.
      _requestToken++;
      state = const SearchState.idle();
      return;
    }

    if (trimmed == state.query && state is! SearchFailure) return;

    _debounceTimer = Timer(_debounce, () => _search(trimmed));
  }

  /// Retry the first page after a failure.
  Future<void> retry() {
    final query = state.query;
    if (query.isEmpty) return Future.value();

    return _search(query);
  }

  /// Append the next page. Safe to call repeatedly while scrolling: it is a
  /// no-op unless there is a further page and none is already in flight.
  Future<void> loadMore() async {
    if (state case SearchSuccess(
      :final query,
      :final results,
    ) when state.canLoadMore) {
      final nextPage = results.nextPage;
      if (nextPage == null) return;

      final token = _requestToken;
      state = (state as SearchSuccess).copyWith(isLoadingMore: true);

      final result = await ref
          .read(searchContentUseCaseProvider)
          .call(query: query, page: nextPage);

      if (token != _requestToken) return;

      state = switch (result) {
        Success(value: final page) => SearchState.success(
          query: query,
          results: results.append(page),
        ),
        // The already-loaded pages stay on screen; only the failed page is
        // retryable, so a lost connection does not empty the list.
        Failure(:final error) => SearchState.success(
          query: query,
          results: results,
          pageError: error,
        ),
      };
    }
  }

  /// Retry only the page that failed, leaving loaded results in place.
  Future<void> retryNextPage() async {
    if (state case SearchSuccess(:final query, :final results)) {
      state = SearchState.success(query: query, results: results);
      await loadMore();
    }
  }

  Future<void> _search(String query) async {
    final token = ++_requestToken;
    state = SearchState.loading(query: query);

    final result = await ref
        .read(searchContentUseCaseProvider)
        .call(query: query);

    if (token != _requestToken) return;

    state = switch (result) {
      Success(value: final results) when results.isEmpty => SearchState.empty(
        query: query,
      ),
      Success(value: final results) => SearchState.success(
        query: query,
        results: results,
      ),
      Failure(:final error) => SearchState.failure(query: query, error: error),
    };
  }
}
