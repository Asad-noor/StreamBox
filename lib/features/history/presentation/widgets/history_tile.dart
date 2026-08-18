import 'package:flutter/material.dart';
import 'package:streambox/app/theme/app_colors.dart';
import 'package:streambox/app/theme/app_radius.dart';
import 'package:streambox/app/theme/app_spacing.dart';
import 'package:streambox/core/widgets/content/content_image.dart';
import 'package:streambox/features/history/domain/entities/watch_history_entry.dart';
import 'package:streambox/features/player/presentation/widgets/playback_scrubber.dart';

/// One watched title, with how far through it the viewer got.
class HistoryTile extends StatelessWidget {
  const HistoryTile({
    required this.entry,
    required this.onResume,
    required this.onRemove,
    super.key,
  });

  static const double thumbnailWidth = 116;

  final WatchHistoryEntry entry;
  final VoidCallback onResume;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = entry.progress;

    return Dismissible(
      key: ValueKey('history-${entry.contentId}'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onRemove(),
      background: ColoredBox(
        color: theme.colorScheme.error,
        child: const Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: AppSpacing.xl),
            child: Icon(Icons.delete_outline_rounded),
          ),
        ),
      ),
      child: InkWell(
        onTap: onResume,
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
                    aspectRatio: 16 / 9,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ContentImage(url: entry.content.posterUrl),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: LinearProgressIndicator(
                            value: progress.fraction,
                            minHeight: 3,
                            backgroundColor: AppColors.surfaceElevated,
                            valueColor: const AlwaysStoppedAnimation(
                              AppColors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.content.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      progress.isCompleted
                          ? 'Watched'
                          : '${formatPlaybackTime(progress.position)} of '
                                '${formatPlaybackTime(progress.duration)}',
                      style: theme.textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onRemove,
                icon: const Icon(Icons.close_rounded),
                tooltip: 'Remove ${entry.content.title} from history',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
