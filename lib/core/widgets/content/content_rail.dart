import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:streambox/app/theme/app_spacing.dart';
import 'package:streambox/core/widgets/content/content_card.dart';
import 'package:streambox/core/widgets/content/section_header.dart';

/// A horizontally scrolling row of cards beneath a [SectionHeader].
///
/// Builds lazily, so a home screen carrying six rails of fifty titles
/// instantiates only the cards actually on screen.
class ContentRail extends StatelessWidget {
  const ContentRail({
    required this.title,
    required this.itemCount,
    required this.itemBuilder,
    this.onSeeAll,
    this.itemWidth = ContentCard.defaultWidth,
    super.key,
  });

  final String title;
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final VoidCallback? onSeeAll;

  /// Drives the rail's height, so it does not depend on measuring children.
  final double itemWidth;

  @override
  Widget build(BuildContext context) {
    if (itemCount == 0) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: title, onSeeAll: onSeeAll),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: _railHeight(context),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.pageGutter,
            ),
            // Keep one screen-width of cards warm on either side so a flick
            // does not reveal placeholders.
            scrollCacheExtent: ScrollCacheExtent.pixels(itemWidth * 3),
            itemCount: itemCount,
            separatorBuilder: (context, index) =>
                const SizedBox(width: AppSpacing.sm),
            itemBuilder: itemBuilder,
          ),
        ),
      ],
    );
  }

  /// Poster height plus the title and subtitle lines below it.
  ///
  /// Scaled by the user's text setting so the labels are never clipped when
  /// text is enlarged.
  double _railHeight(BuildContext context) {
    final scaler = MediaQuery.textScalerOf(context);
    final posterHeight = itemWidth / ContentCard.posterAspectRatio;

    return posterHeight + AppSpacing.xs + scaler.scale(_labelBlockHeight);
  }

  /// Two lines of `titleSmall` plus one of `labelSmall`, with their leading.
  static const double _labelBlockHeight = 54;
}
