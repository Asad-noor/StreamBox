import 'package:flutter/material.dart';
import 'package:streambox/app/theme/app_radius.dart';
import 'package:streambox/app/theme/app_spacing.dart';
import 'package:streambox/core/widgets/content/content_image.dart';
import 'package:streambox/core/widgets/content/metadata_row.dart';
import 'package:streambox/features/catalog/domain/entities/content.dart';

/// One search hit.
///
/// A row rather than a poster tile: search results benefit from the synopsis
/// and metadata that a grid cell has no room for.
class SearchResultTile extends StatelessWidget {
  const SearchResultTile({
    required this.content,
    required this.onTap,
    super.key,
  });

  /// Wide enough to read as a poster, short enough to fit several rows.
  static const double thumbnailWidth = 72;

  final Content content;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      button: true,
      label: '${content.title}, ${content.metadata.join(', ')}',
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.allMd,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pageGutter,
            vertical: AppSpacing.xs,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    MetadataRow(items: content.metadata),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      content.synopsis,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
