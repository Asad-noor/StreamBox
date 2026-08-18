import 'package:flutter/material.dart';
import 'package:streambox/app/theme/app_radius.dart';
import 'package:streambox/app/theme/app_spacing.dart';
import 'package:streambox/core/widgets/skeleton/shimmer.dart';
import 'package:streambox/core/widgets/skeleton/skeleton_box.dart';

/// Placeholder rows for a list of titles.
///
/// Shared by favourites and history, whose rows differ only in thumbnail
/// proportions. Exists so neither screen falls back to a bare spinner, which
/// tells the viewer nothing about what is arriving.
class ListSkeleton extends StatelessWidget {
  const ListSkeleton({
    this.rows = 6,
    this.thumbnailWidth = 64,
    this.thumbnailAspectRatio = 2 / 3,
    super.key,
  });

  final int rows;
  final double thumbnailWidth;
  final double thumbnailAspectRatio;

  @override
  Widget build(BuildContext context) => Shimmer(
    child: ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: rows,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.pageGutter,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: thumbnailWidth,
              child: AspectRatio(
                aspectRatio: thumbnailAspectRatio,
                child: const SkeletonBox(borderRadius: AppRadius.allSm),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonBox(height: 15, width: 160),
                  SizedBox(height: AppSpacing.xs),
                  SkeletonBox(height: 11, width: 90),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
