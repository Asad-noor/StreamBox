import 'package:flutter/material.dart';
import 'package:streambox/app/theme/app_radius.dart';
import 'package:streambox/app/theme/app_spacing.dart';
import 'package:streambox/core/widgets/content/content_card.dart';
import 'package:streambox/core/widgets/skeleton/shimmer.dart';
import 'package:streambox/core/widgets/skeleton/skeleton_box.dart';

/// Placeholder matching [ContentCard]'s geometry exactly, so nothing shifts
/// when the real card replaces it.
class ContentCardSkeleton extends StatelessWidget {
  const ContentCardSkeleton({this.width = ContentCard.defaultWidth, super.key});

  final double width;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: width,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AspectRatio(
          aspectRatio: ContentCard.posterAspectRatio,
          child: const SkeletonBox(borderRadius: AppRadius.allMd),
        ),
        const SizedBox(height: AppSpacing.xs),
        const SkeletonText(lines: 2, lineHeight: 11),
      ],
    ),
  );
}

/// Placeholder for a whole rail, header included.
///
/// Not scrollable and not lazy on purpose: it renders a fixed handful of cards
/// that are about to be thrown away.
class ContentRailSkeleton extends StatelessWidget {
  const ContentRailSkeleton({
    this.itemCount = 4,
    this.itemWidth = ContentCard.defaultWidth,
    super.key,
  });

  final int itemCount;
  final double itemWidth;

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.pageGutter),
            child: SkeletonBox(width: 140, height: 18),
          ),
          const SizedBox(height: AppSpacing.sm),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.pageGutter,
            ),
            child: Row(
              children: [
                for (var index = 0; index < itemCount; index++) ...[
                  if (index > 0) const SizedBox(width: AppSpacing.sm),
                  ContentCardSkeleton(width: itemWidth),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
