import 'package:flutter/material.dart';
import 'package:streambox/app/theme/app_spacing.dart';
import 'package:streambox/core/widgets/content/section_header.dart';
import 'package:streambox/features/catalog/domain/entities/content_details.dart';
import 'package:streambox/features/catalog/domain/entities/episode.dart';
import 'package:streambox/features/details/presentation/widgets/details_header.dart';
import 'package:streambox/features/details/presentation/widgets/episode_tile.dart';
import 'package:streambox/features/details/presentation/widgets/season_selector.dart';

/// Lays out a loaded [ContentDetails].
///
/// Takes callbacks rather than reaching for providers or the router, so it can
/// be widget-tested against a fixture with no scope and no navigation.
class DetailsView extends StatelessWidget {
  const DetailsView({
    required this.details,
    required this.selectedSeasonIndex,
    required this.onSeasonSelected,
    required this.onWatch,
    required this.onEpisodeTap,
    super.key,
  });

  final ContentDetails details;
  final int selectedSeasonIndex;
  final ValueChanged<int> onSeasonSelected;
  final VoidCallback onWatch;
  final ValueChanged<Episode> onEpisodeTap;

  @override
  Widget build(BuildContext context) {
    // Guarded because the selection outlives a refresh that could return
    // fewer seasons than before.
    final seasonIndex = details.hasSeasons
        ? selectedSeasonIndex.clamp(0, details.seasons.length - 1)
        : 0;
    final episodes = details.hasSeasons
        ? details.seasons[seasonIndex].episodes
        : const <Episode>[];

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: DetailsHeader(details: details, onWatch: onWatch),
        ),
        SliverToBoxAdapter(child: _Synopsis(text: details.content.synopsis)),
        if (details.hasSeasons) ...[
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
          SliverToBoxAdapter(
            child: SectionHeader(
              title: details.seasons.length == 1 ? 'Episodes' : 'Seasons',
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xs)),
          SliverToBoxAdapter(
            child: SeasonSelector(
              seasons: details.seasons,
              selectedIndex: seasonIndex,
              onSelected: onSeasonSelected,
            ),
          ),
          SliverList.builder(
            itemCount: episodes.length,
            itemBuilder: (context, index) =>
                EpisodeTile(episode: episodes[index], onTap: onEpisodeTap),
          ),
        ],
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
      ],
    );
  }
}

class _Synopsis extends StatelessWidget {
  const _Synopsis({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(
      AppSpacing.pageGutter,
      AppSpacing.lg,
      AppSpacing.pageGutter,
      0,
    ),
    child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
  );
}
