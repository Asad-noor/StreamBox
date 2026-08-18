import 'package:flutter/material.dart';
import 'package:streambox/app/theme/app_radius.dart';
import 'package:streambox/app/theme/app_spacing.dart';
import 'package:streambox/core/widgets/content/content_image.dart';
import 'package:streambox/features/catalog/domain/entities/episode.dart';

/// One episode row.
class EpisodeTile extends StatelessWidget {
  const EpisodeTile({required this.episode, required this.onTap, super.key});

  static const double stillWidth = 116;

  final Episode episode;
  final ValueChanged<Episode> onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final enabled = episode.isPlayable;

    return Semantics(
      button: enabled,
      label:
          'Episode ${episode.number}, ${episode.title}, '
          '${episode.formattedDuration}',
      excludeSemantics: true,
      child: InkWell(
        onTap: enabled ? () => onTap(episode) : null,
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
                  width: stillWidth,
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: ContentImage(url: episode.stillUrl),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${episode.number}. ${episode.title}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      episode.formattedDuration,
                      style: theme.textTheme.labelSmall,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      episode.synopsis,
                      maxLines: 2,
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
