import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streambox/app/router/routes.dart';
import 'package:streambox/core/widgets/skeleton/list_skeleton.dart';
import 'package:streambox/core/widgets/states/app_empty_view.dart';
import 'package:streambox/core/widgets/states/async_value_view.dart';
import 'package:streambox/features/history/domain/entities/watch_history_entry.dart';
import 'package:streambox/features/history/presentation/providers/history_providers.dart';
import 'package:streambox/features/history/presentation/widgets/history_tile.dart';

/// What the viewer has watched, newest first.
class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(watchHistoryProvider);
    final hasEntries = value.value?.isNotEmpty ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Watch history'),
        actions: [
          if (hasEntries)
            TextButton(
              onPressed: () => _confirmClearAll(context, ref),
              child: const Text('Clear all'),
            ),
        ],
      ),
      body: AsyncValueView<List<WatchHistoryEntry>>(
        value: value,
        skeleton: const ListSkeleton(
          thumbnailWidth: HistoryTile.thumbnailWidth,
          thumbnailAspectRatio: 16 / 9,
        ),
        isEmpty: (entries) => entries.isEmpty,
        empty: const AppEmptyView(
          title: 'Nothing watched yet',
          message: 'Titles you start watching will appear here.',
          icon: Icons.history_rounded,
        ),
        data: (entries) => ListView.builder(
          itemCount: entries.length,
          itemBuilder: (context, index) => HistoryTile(
            entry: entries[index],
            onResume: () => PlayerRoute(
              contentId: entries[index].contentId,
              title: entries[index].content.title,
            ).push<void>(context),
            onRemove: () => _remove(context, ref, entries[index].contentId),
          ),
        ),
      ),
    );
  }

  Future<void> _remove(
    BuildContext context,
    WidgetRef ref,
    String contentId,
  ) async {
    final messenger = ScaffoldMessenger.of(context);

    try {
      await ref.read(historyControllerProvider.notifier).remove(contentId);
    } on Object {
      messenger.showSnackBar(
        const SnackBar(content: Text('Could not update your history.')),
      );
    }
  }

  /// Clearing everything is irreversible, so it is confirmed first.
  Future<void> _confirmClearAll(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear watch history?'),
        content: const Text(
          'This removes every title from your history and from Continue '
          'Watching. It cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      try {
        await ref.read(historyControllerProvider.notifier).clearAll();
      } on Object {
        messenger.showSnackBar(
          const SnackBar(content: Text('Could not clear your history.')),
        );
      }
    }
  }
}
