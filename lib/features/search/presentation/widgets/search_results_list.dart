import 'package:flutter/material.dart';
import 'package:streambox/app/theme/app_spacing.dart';
import 'package:streambox/core/error/app_exception.dart';
import 'package:streambox/features/catalog/domain/entities/content.dart';
import 'package:streambox/features/catalog/domain/entities/search_results.dart';
import 'package:streambox/features/search/presentation/widgets/search_result_tile.dart';

/// The loaded result list, including its pagination footer.
///
/// Requests the next page when the user comes within [_loadMoreThreshold] of
/// the bottom, so the following page is usually already there by the time they
/// reach it.
class SearchResultsList extends StatefulWidget {
  const SearchResultsList({
    required this.results,
    required this.isLoadingMore,
    required this.pageError,
    required this.onLoadMore,
    required this.onRetryPage,
    required this.onContentTap,
    super.key,
  });

  final SearchResults results;
  final bool isLoadingMore;
  final AppException? pageError;
  final VoidCallback onLoadMore;
  final VoidCallback onRetryPage;
  final void Function(Content content) onContentTap;

  @override
  State<SearchResultsList> createState() => _SearchResultsListState();
}

class _SearchResultsListState extends State<SearchResultsList> {
  /// How close to the bottom, in pixels, triggers the next page.
  static const double _loadMoreThreshold = 400;

  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_controller.hasClients) return;

    final remaining =
        _controller.position.maxScrollExtent - _controller.position.pixels;

    // The notifier is responsible for ignoring this when there is nothing more
    // to load or a request is already running, so this stays a dumb trigger.
    if (remaining <= _loadMoreThreshold) widget.onLoadMore();
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.results.items;

    return ListView.builder(
      controller: _controller,
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      itemCount: items.length + 1,
      itemBuilder: (context, index) {
        if (index == items.length) return _footer(context);

        return SearchResultTile(
          content: items[index],
          onTap: () => widget.onContentTap(items[index]),
        );
      },
    );
  }

  Widget _footer(BuildContext context) {
    if (widget.pageError case final error?) {
      return _PageErrorFooter(error: error, onRetry: widget.onRetryPage);
    }

    if (widget.isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (!widget.results.hasMore && widget.results.items.isNotEmpty) {
      return _EndOfResults(total: widget.results.totalCount);
    }

    return const SizedBox(height: AppSpacing.lg);
  }
}

class _PageErrorFooter extends StatelessWidget {
  const _PageErrorFooter({required this.error, required this.onRetry});

  final AppException error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(AppSpacing.lg),
    child: Column(
      children: [
        Text(
          error.message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: AppSpacing.xs),
        TextButton(onPressed: onRetry, child: const Text('Load more')),
      ],
    ),
  );
}

class _EndOfResults extends StatelessWidget {
  const _EndOfResults({required this.total});

  final int total;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
    child: Center(
      child: Text(
        total == 1 ? '1 result' : '$total results',
        style: Theme.of(context).textTheme.labelSmall,
      ),
    ),
  );
}
