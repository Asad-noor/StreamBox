import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:streambox/core/error/app_exception.dart';
import 'package:streambox/features/catalog/domain/entities/search_results.dart';

part 'search_state.freezed.dart';

/// Every state the search screen can be in.
///
/// Modelled as a union rather than an `AsyncValue` because search has two
/// states `AsyncValue` cannot express: an idle prompt before the user has
/// typed anything, and "loading the next page" while existing results stay on
/// screen. A union makes those explicit and lets the UI be one exhaustive
/// switch with no unrepresentable combinations.
@freezed
sealed class SearchState with _$SearchState {
  /// Nothing typed yet. The screen shows a prompt, not an empty result set.
  const factory SearchState.idle() = SearchIdle;

  /// First page in flight. Existing results, if any, have been cleared.
  const factory SearchState.loading({required String query}) = SearchLoading;

  /// At least one match.
  const factory SearchState.success({
    required String query,
    required SearchResults results,

    /// True while the next page is being appended. Results stay visible.
    @Default(false) bool isLoadingMore,

    /// Set when appending a page failed. The already-loaded results remain,
    /// and the UI offers to retry just the failed page.
    AppException? pageError,
  }) = SearchSuccess;

  /// The query ran and matched nothing.
  const factory SearchState.empty({required String query}) = SearchEmpty;

  /// The first page failed. There is nothing to show but the error.
  const factory SearchState.failure({
    required String query,
    required AppException error,
  }) = SearchFailure;

  const SearchState._();

  /// The query currently reflected by this state, for the text field and for
  /// deciding whether an in-flight response is still relevant.
  String get query => switch (this) {
    SearchIdle() => '',
    SearchLoading(:final query) => query,
    SearchSuccess(:final query) => query,
    SearchEmpty(:final query) => query,
    SearchFailure(:final query) => query,
  };

  /// Whether a further page can be requested right now.
  bool get canLoadMore => switch (this) {
    SearchSuccess(:final results, :final isLoadingMore, :final pageError) =>
      results.hasMore && !isLoadingMore && pageError == null,
    _ => false,
  };
}
