import 'package:flutter/material.dart';
import 'package:streambox/app/theme/app_colors.dart';
import 'package:streambox/app/theme/app_spacing.dart';
import 'package:streambox/core/widgets/content/hero_banner.dart';
import 'package:streambox/core/widgets/skeleton/content_skeletons.dart';
import 'package:streambox/core/widgets/skeleton/shimmer.dart';
import 'package:streambox/core/widgets/skeleton/skeleton_box.dart';

/// The home screen's loading state.
///
/// Mirrors the real layout — hero, then rails — so that when data arrives
/// nothing jumps. One [Shimmer] drives the whole screen.
class HomeFeedSkeleton extends StatelessWidget {
  const HomeFeedSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _HeroSkeleton(),
            const SizedBox(height: AppSpacing.lg),
            for (var index = 0; index < _railCount; index++) ...[
              if (index > 0) const SizedBox(height: AppSpacing.sectionGap),
              const ContentRailSkeleton(),
            ],
          ],
        ),
      ),
    );
  }

  /// Enough to fill a phone screen; more would be built and never seen.
  static const int _railCount = 2;
}

class _HeroSkeleton extends StatelessWidget {
  const _HeroSkeleton();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SizedBox(
        height: (constraints.maxWidth / HeroBanner.aspectRatio).clamp(
          0.0,
          HeroBanner.maxHeight,
        ),
        child: ColoredBox(
          color: AppColors.surfaceMuted,
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
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
                  const SkeletonBox(width: 220, height: 28),
                  const SizedBox(height: AppSpacing.sm),
                  const SkeletonText(lines: 2, lineHeight: 12),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      const SkeletonBox(width: 120, height: 48),
                      const SizedBox(width: AppSpacing.sm),
                      const SkeletonBox(width: 120, height: 48),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
