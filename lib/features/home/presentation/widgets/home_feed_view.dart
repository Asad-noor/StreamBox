import 'package:flutter/material.dart';
import 'package:streambox/app/theme/app_spacing.dart';
import 'package:streambox/core/widgets/content/content_card.dart';
import 'package:streambox/core/widgets/content/content_rail.dart';
import 'package:streambox/core/widgets/content/hero_banner.dart';
import 'package:streambox/features/catalog/domain/entities/content.dart';
import 'package:streambox/features/catalog/domain/entities/content_section.dart';
import 'package:streambox/features/catalog/domain/entities/home_feed.dart';

/// Lays out a loaded [HomeFeed].
///
/// Takes callbacks rather than reaching for a router or a provider, so it can
/// be widget-tested against a fixture with no Riverpod scope and no navigation.
class HomeFeedView extends StatelessWidget {
  const HomeFeedView({
    required this.feed,
    required this.onContentTap,
    required this.onWatch,
    super.key,
  });

  final HomeFeed feed;
  final void Function(Content content) onContentTap;
  final void Function(Content content) onWatch;

  @override
  Widget build(BuildContext context) {
    final sections = feed.visibleSections;

    // One lazy list for the whole screen: rails below the fold are not built
    // until they scroll into view.
    return CustomScrollView(
      slivers: [
        if (feed.featured case final featured?)
          SliverToBoxAdapter(
            child: _Hero(
              content: featured,
              onTap: onContentTap,
              onWatch: onWatch,
            ),
          ),
        SliverList.separated(
          itemCount: sections.length,
          separatorBuilder: (context, index) =>
              const SizedBox(height: AppSpacing.sectionGap),
          itemBuilder: (context, index) =>
              _Rail(section: sections[index], onContentTap: onContentTap),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
      ],
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({
    required this.content,
    required this.onTap,
    required this.onWatch,
  });

  final Content content;
  final void Function(Content content) onTap;
  final void Function(Content content) onWatch;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
    child: HeroBanner(
      title: content.title,
      backdropUrl: content.backdropUrl,
      synopsis: content.synopsis,
      metadata: content.metadata,
      // A title with no stream yet disables playback rather than failing on tap.
      onWatch: content.isPlayable ? () => onWatch(content) : null,
      onDetails: () => onTap(content),
      watchLabel: content.isSeries ? 'Play S1 E1' : 'Watch',
    ),
  );
}

class _Rail extends StatelessWidget {
  const _Rail({required this.section, required this.onContentTap});

  final ContentSection section;
  final void Function(Content content) onContentTap;

  @override
  Widget build(BuildContext context) {
    final isContinueWatching =
        section.kind == ContentSectionKind.continueWatching;

    return ContentRail(
      title: section.title,
      itemCount: section.items.length,
      itemBuilder: (context, index) {
        final content = section.items[index];

        return ContentCard(
          title: content.title,
          imageUrl: content.posterUrl,
          subtitle: content.isSeries
              ? '${content.seasonCount} seasons'
              : '${content.releaseYear}',
          // Progress is only meaningful on the resume rail; phase 7 supplies
          // the real values from persisted playback position.
          progress: isContinueWatching ? 0 : null,
          onTap: () => onContentTap(content),
        );
      },
    );
  }
}
