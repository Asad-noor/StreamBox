import 'package:flutter/material.dart';
import 'package:streambox/app/theme/app_colors.dart';
import 'package:streambox/app/theme/app_radius.dart';

/// A single grey placeholder block.
///
/// Meant to be wrapped in one [Shimmer] per screen rather than one per box.
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    this.width,
    this.height,
    this.borderRadius = AppRadius.allSm,
    super.key,
  });

  final double? width;
  final double? height;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: AppColors.surfaceMuted,
      borderRadius: borderRadius,
    ),
  );
}

/// A stack of [SkeletonBox] lines standing in for a paragraph.
class SkeletonText extends StatelessWidget {
  const SkeletonText({
    this.lines = 1,
    this.lineHeight = 12,
    this.spacing = 8,
    this.lastLineFraction = 0.6,
    super.key,
  });

  final int lines;
  final double lineHeight;
  final double spacing;

  /// The trailing line is shortened so the block reads as text, not a slab.
  final double lastLineFraction;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var line = 0; line < lines; line++) ...[
            if (line > 0) SizedBox(height: spacing),
            SkeletonBox(
              height: lineHeight,
              width: line == lines - 1 && lines > 1
                  ? constraints.maxWidth * lastLineFraction
                  : null,
            ),
          ],
        ],
      ),
    );
  }
}
