import 'package:flutter/material.dart';
import 'package:streambox/app/theme/app_colors.dart';
import 'package:streambox/app/theme/app_radius.dart';
import 'package:streambox/app/theme/app_spacing.dart';
import 'package:streambox/core/widgets/content/content_image.dart';
import 'package:streambox/core/widgets/content/metadata_row.dart';
import 'package:streambox/features/catalog/domain/entities/content_details.dart';
import 'package:streambox/features/details/presentation/widgets/favorite_button.dart';

/// Backdrop, poster and the primary actions.
class DetailsHeader extends StatelessWidget {
  const DetailsHeader({
    required this.details,
    required this.onWatch,
    super.key,
  });

  /// Backdrops are 16:9; the poster overlaps its lower edge.
  static const double backdropAspectRatio = 16 / 9;
  static const double posterWidth = 108;

  final ContentDetails details;
  final VoidCallback? onWatch;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: backdropAspectRatio,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ContentImage(url: details.content.backdropUrl),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: AppColors.heroScrim,
                    stops: [0.4, 0.8, 1],
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.pageGutter,
            AppSpacing.md,
            AppSpacing.pageGutter,
            0,
          ),
          child: _TitleBlock(details: details),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.pageGutter,
            AppSpacing.md,
            AppSpacing.pageGutter,
            0,
          ),
          child: _Actions(details: details, onWatch: onWatch),
        ),
      ],
    );
  }
}

class _TitleBlock extends StatelessWidget {
  const _TitleBlock({required this.details});

  final ContentDetails details;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final content = details.content;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: AppRadius.allSm,
          child: SizedBox(
            width: DetailsHeader.posterWidth,
            child: AspectRatio(
              aspectRatio: 2 / 3,
              child: ContentImage(url: content.posterUrl),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(content.title, style: theme.textTheme.headlineMedium),
              const SizedBox(height: AppSpacing.xs),
              MetadataRow(
                items: [
                  '${content.releaseYear}',
                  details.lengthLabel,
                  '★ ${content.formattedRating}',
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              _Genres(genres: content.genres),
            ],
          ),
        ),
      ],
    );
  }
}

class _Genres extends StatelessWidget {
  const _Genres({required this.genres});

  final List<String> genres;

  @override
  Widget build(BuildContext context) {
    if (genres.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: AppSpacing.xxs,
      runSpacing: AppSpacing.xxs,
      children: [
        for (final genre in genres)
          Chip(
            label: Text(genre),
            visualDensity: VisualDensity.compact,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
      ],
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions({required this.details, required this.onWatch});

  final ContentDetails details;
  final VoidCallback? onWatch;

  @override
  Widget build(BuildContext context) {
    final episode = details.firstEpisode;

    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: details.isPlayable ? onWatch : null,
            icon: const Icon(Icons.play_arrow_rounded),
            label: Text(
              episode == null ? 'Watch' : 'Play S1 E${episode.number}',
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        FavoriteButton(contentId: details.id, showLabel: true),
      ],
    );
  }
}
