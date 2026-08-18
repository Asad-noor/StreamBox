import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streambox/app/router/routes.dart';
import 'package:streambox/core/widgets/states/app_empty_view.dart';
import 'package:streambox/core/widgets/states/async_value_view.dart';
import 'package:streambox/features/catalog/domain/entities/content.dart';
import 'package:streambox/features/home/presentation/providers/home_providers.dart';
import 'package:streambox/features/home/presentation/widgets/home_feed_skeleton.dart';
import 'package:streambox/features/home/presentation/widgets/home_feed_view.dart';

/// The landing screen: one promoted title above a set of content rails.
///
/// Holds no business logic. It resolves state from [homeFeedProvider],
/// hands it to [AsyncValueView], and translates taps into navigation.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(homeFeedProvider.notifier);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: notifier.refresh,
        edgeOffset: MediaQuery.paddingOf(context).top,
        child: AsyncValueView(
          value: ref.watch(homeFeedProvider),
          skeleton: const HomeFeedSkeleton(),
          onRetry: notifier.retry,
          isEmpty: (feed) => feed.isEmpty,
          empty: const AppEmptyView(
            title: 'Nothing to watch yet',
            message: 'New titles will appear here as they are added.',
            icon: Icons.movie_outlined,
          ),
          data: (feed) => HomeFeedView(
            feed: feed,
            onContentTap: (content) => _openDetails(context, content),
            onWatch: (content) => _openPlayer(context, content),
          ),
        ),
      ),
    );
  }

  /// Routes carry the identifier only; the details screen resolves its own
  /// data, so a deep link and an in-app tap take the same path.
  void _openDetails(BuildContext context, Content content) =>
      ContentDetailsRoute(contentId: content.id).push<void>(context);

  void _openPlayer(BuildContext context, Content content) =>
      PlayerRoute(contentId: content.id).push<void>(context);
}
