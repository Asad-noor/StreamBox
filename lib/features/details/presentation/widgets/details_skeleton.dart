import 'package:flutter/material.dart';
import 'package:streambox/app/theme/app_colors.dart';
import 'package:streambox/app/theme/app_radius.dart';
import 'package:streambox/app/theme/app_spacing.dart';
import 'package:streambox/core/widgets/skeleton/shimmer.dart';
import 'package:streambox/core/widgets/skeleton/skeleton_box.dart';
import 'package:streambox/features/details/presentation/widgets/details_header.dart';

/// Loading state mirroring [DetailsView]'s layout.
class DetailsSkeleton extends StatelessWidget {
  const DetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) => Shimmer(
    child: SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AspectRatio(
            aspectRatio: DetailsHeader.backdropAspectRatio,
            child: ColoredBox(color: AppColors.surfaceMuted),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.pageGutter),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: DetailsHeader.posterWidth,
                      child: AspectRatio(
                        aspectRatio: 2 / 3,
                        child: SkeletonBox(borderRadius: AppRadius.allSm),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SkeletonBox(height: 22, width: 200),
                          SizedBox(height: AppSpacing.xs),
                          SkeletonBox(height: 12, width: 140),
                          SizedBox(height: AppSpacing.sm),
                          SkeletonBox(height: 24, width: 160),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                const SkeletonBox(height: 48),
                const SizedBox(height: AppSpacing.lg),
                const SkeletonText(lines: 4),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
