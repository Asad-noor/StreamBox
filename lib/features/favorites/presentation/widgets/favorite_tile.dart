import 'package:flutter/material.dart';
import 'package:streambox/app/theme/app_radius.dart';
import 'package:streambox/app/theme/app_spacing.dart';
import 'package:streambox/core/widgets/content/content_image.dart';
import 'package:streambox/features/favorites/domain/entities/favorite_entry.dart';

/// One saved title.
///
/// Renders entirely from the stored snapshot, which is what lets this screen
/// work with no network and no catalogue.
class FavoriteTile extends StatelessWidget {
  const FavoriteTile({
    required this.entry,
    required this.onTap,
    required this.onRemove,
    super.key,
  });

  static const double thumbnailWidth = 64;

  final FavoriteEntry entry;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final content = entry.content;

    return Dismissible(
      key: ValueKey('favorite-${entry.contentId}'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onRemove(),
      background: const _RemoveBackground(),
      child: Semantics(
        button: true,
        label: '${content.title}, ${content.releaseYear}',
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.pageGutter,
              vertical: AppSpacing.xs,
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: AppRadius.allSm,
                  child: SizedBox(
                    width: thumbnailWidth,
                    child: AspectRatio(
                      aspectRatio: 2 / 3,
                      child: ContentImage(url: content.posterUrl),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        content.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall,
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        '${content.releaseYear}',
                        style: theme.textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(Icons.close_rounded),
                  tooltip: 'Remove ${content.title} from my list',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RemoveBackground extends StatelessWidget {
  const _RemoveBackground();

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: Theme.of(context).colorScheme.error,
    child: const Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.only(right: AppSpacing.xl),
        child: Icon(Icons.delete_outline_rounded),
      ),
    ),
  );
}
