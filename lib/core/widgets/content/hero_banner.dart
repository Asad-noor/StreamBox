import 'package:flutter/material.dart';
import 'package:streambox/app/theme/app_colors.dart';
import 'package:streambox/app/theme/app_spacing.dart';
import 'package:streambox/core/widgets/content/content_image.dart';
import 'package:streambox/core/widgets/content/metadata_row.dart';

/// The full-bleed feature at the top of the home screen.
///
/// Sizes itself from the available width rather than the screen, so it behaves
/// correctly inside any layout, tablet split views included.
class HeroBanner extends StatelessWidget {
  const HeroBanner({
    required this.title,
    this.backdropUrl,
    this.synopsis,
    this.metadata = const [],
    this.onWatch,
    this.onDetails,
    this.watchLabel = 'Watch',
    super.key,
  });

  /// Tall enough to feel cinematic without pushing the first rail off-screen.
  static const double aspectRatio = 3 / 4;

  /// Beyond this width the banner stops growing taller and letterboxes.
  static const double maxHeight = 560;

  final String title;
  final String? backdropUrl;
  final String? synopsis;
  final List<String> metadata;
  final VoidCallback? onWatch;
  final VoidCallback? onDetails;
  final String watchLabel;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = (constraints.maxWidth / aspectRatio).clamp(
          0.0,
          maxHeight,
        );

        return SizedBox(
          height: height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ContentImage(url: backdropUrl),
              const _Scrim(),
              Align(
                alignment: Alignment.bottomCenter,
                child: _Details(
                  title: title,
                  synopsis: synopsis,
                  metadata: metadata,
                  onWatch: onWatch,
                  onDetails: onDetails,
                  watchLabel: watchLabel,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Darkens the lower half of the artwork so overlaid text keeps its contrast
/// ratio regardless of what the image happens to look like.
class _Scrim extends StatelessWidget {
  const _Scrim();

  @override
  Widget build(BuildContext context) => const DecoratedBox(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: AppColors.heroScrim,
        stops: [0.35, 0.72, 1],
      ),
    ),
  );
}

class _Details extends StatelessWidget {
  const _Details({
    required this.title,
    required this.synopsis,
    required this.metadata,
    required this.onWatch,
    required this.onDetails,
    required this.watchLabel,
  });

  final String title;
  final String? synopsis;
  final List<String> metadata;
  final VoidCallback? onWatch;
  final VoidCallback? onDetails;
  final String watchLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageGutter,
        AppSpacing.md,
        AppSpacing.pageGutter,
        AppSpacing.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.displaySmall,
          ),
          if (metadata.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            MetadataRow(items: metadata),
          ],
          if (synopsis case final synopsis?) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              synopsis,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium,
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          _Actions(
            onWatch: onWatch,
            onDetails: onDetails,
            watchLabel: watchLabel,
          ),
        ],
      ),
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions({
    required this.onWatch,
    required this.onDetails,
    required this.watchLabel,
  });

  final VoidCallback? onWatch;
  final VoidCallback? onDetails;
  final String watchLabel;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: FilledButton.icon(
          onPressed: onWatch,
          icon: const Icon(Icons.play_arrow_rounded),
          label: Text(watchLabel),
        ),
      ),
      const SizedBox(width: AppSpacing.sm),
      Expanded(
        child: OutlinedButton.icon(
          onPressed: onDetails,
          icon: const Icon(Icons.info_outline_rounded, size: 20),
          label: const Text('Details'),
        ),
      ),
    ],
  );
}
