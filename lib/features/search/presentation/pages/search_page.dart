import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streambox/app/router/routes.dart';
import 'package:streambox/app/theme/app_spacing.dart';
import 'package:streambox/core/widgets/states/app_empty_view.dart';
import 'package:streambox/core/widgets/states/app_error_view.dart';
import 'package:streambox/features/catalog/domain/entities/content.dart';
import 'package:streambox/features/search/presentation/providers/search_providers.dart';
import 'package:streambox/features/search/presentation/providers/search_state.dart';
import 'package:streambox/features/search/presentation/widgets/search_field.dart';
import 'package:streambox/features/search/presentation/widgets/search_results_list.dart';
import 'package:streambox/features/search/presentation/widgets/search_results_skeleton.dart';

/// Catalogue search.
///
/// The body is a single exhaustive switch over [SearchState]; because the
/// state is a sealed union, adding a case to it is a compile error here rather
/// than a blank screen at runtime.
class SearchPage extends ConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(searchProvider);
    final notifier = ref.watch(searchProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SearchField(
              initialValue: state.query,
              onChanged: notifier.onQueryChanged,
            ),
            Expanded(child: _body(context, state, notifier)),
          ],
        ),
      ),
    );
  }

  Widget _body(
    BuildContext context,
    SearchState state,
    SearchNotifier notifier,
  ) => switch (state) {
    SearchIdle() => const _IdlePrompt(),
    SearchLoading() => const SearchResultsSkeleton(),
    SearchEmpty(:final query) => AppEmptyView(
      title: 'No results for "$query"',
      message: 'Check the spelling, or try a different title or genre.',
      icon: Icons.search_off_rounded,
    ),
    SearchFailure(:final error) => AppErrorView(
      error: error,
      onRetry: notifier.retry,
    ),
    SearchSuccess(:final results, :final isLoadingMore, :final pageError) =>
      SearchResultsList(
        // Rebuilding the list for a new query must reset its scroll position,
        // or page two of the old search stays scrolled under page one of the new.
        key: ValueKey(state.query),
        results: results,
        isLoadingMore: isLoadingMore,
        pageError: pageError,
        onLoadMore: notifier.loadMore,
        onRetryPage: notifier.retryNextPage,
        onContentTap: (content) => _openDetails(context, content),
      ),
  };

  void _openDetails(BuildContext context, Content content) =>
      ContentDetailsRoute(contentId: content.id).push<void>(context);
}

class _IdlePrompt extends StatelessWidget {
  const _IdlePrompt();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.only(bottom: AppSpacing.xxxl),
    child: AppEmptyView(
      title: 'Find something to watch',
      message: 'Search by title, genre, or what a film is about.',
      icon: Icons.search_rounded,
    ),
  );
}
