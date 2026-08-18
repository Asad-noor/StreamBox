import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streambox/app/router/routes.dart';
import 'package:streambox/core/widgets/skeleton/list_skeleton.dart';
import 'package:streambox/core/widgets/states/app_empty_view.dart';
import 'package:streambox/core/widgets/states/async_value_view.dart';
import 'package:streambox/features/favorites/domain/entities/favorite_entry.dart';
import 'package:streambox/features/favorites/presentation/providers/favorites_providers.dart';
import 'package:streambox/features/favorites/presentation/widgets/favorite_tile.dart';

/// The titles the viewer has saved.
///
/// Reads straight from the database stream, so a title favourited on the
/// details screen appears here immediately with no refresh and no coordination
/// between the two screens.
class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('My list')),
      body: AsyncValueView<List<FavoriteEntry>>(
        value: ref.watch(favoritesProvider),
        skeleton: const ListSkeleton(
          thumbnailWidth: FavoriteTile.thumbnailWidth,
        ),
        isEmpty: (entries) => entries.isEmpty,
        empty: const AppEmptyView(
          title: 'Nothing saved yet',
          message: 'Titles you add to your list will appear here.',
          icon: Icons.favorite_outline_rounded,
        ),
        data: (entries) => ListView.builder(
          itemCount: entries.length,
          itemBuilder: (context, index) => FavoriteTile(
            entry: entries[index],
            onTap: () => ContentDetailsRoute(
              contentId: entries[index].contentId,
            ).push<void>(context),
            onRemove: () => _remove(context, ref, entries[index]),
          ),
        ),
      ),
    );
  }

  Future<void> _remove(
    BuildContext context,
    WidgetRef ref,
    FavoriteEntry entry,
  ) async {
    final messenger = ScaffoldMessenger.of(context);

    try {
      await ref
          .read(favoritesControllerProvider.notifier)
          .remove(entry.contentId);
    } on Object {
      messenger.showSnackBar(
        const SnackBar(content: Text('Could not update your list.')),
      );
    }
  }
}
