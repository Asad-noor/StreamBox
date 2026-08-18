import 'package:flutter/material.dart';
import 'package:streambox/app/theme/app_radius.dart';
import 'package:streambox/app/theme/app_spacing.dart';
import 'package:streambox/core/widgets/skeleton/shimmer.dart';
import 'package:streambox/core/widgets/skeleton/skeleton_box.dart';
import 'package:streambox/features/search/presentation/widgets/search_result_tile.dart';

/// Placeholder rows matching [SearchResultTile]'s geometry.
class SearchResultsSkeleton extends StatelessWidget {
  const SearchResultsSkeleton({this.rows = 6, super.key});

  final int rows;

  @override
  Widget build(BuildContext context) => Shimmer(
    child: ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: rows,
      itemBuilder: (context, index) => const _SkeletonRow(),
    ),
  );
}

class _SkeletonRow extends StatelessWidget {
  const _SkeletonRow();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.pageGutter,
      vertical: AppSpacing.xs,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          width: SearchResultTile.thumbnailWidth,
          child: AspectRatio(
            aspectRatio: 2 / 3,
            child: SkeletonBox(borderRadius: AppRadius.allSm),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonBox(height: 16, width: 180),
              SizedBox(height: AppSpacing.xs),
              SkeletonBox(height: 11, width: 120),
              SizedBox(height: AppSpacing.xs),
              SkeletonText(lines: 3, lineHeight: 10),
            ],
          ),
        ),
      ],
    ),
  );
}
