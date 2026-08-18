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
  /// Derived from the live text theme rather than a fixed constant: a change
  /// to the type scale would otherwise silently clip every card in the app.
  double _railHeight(BuildContext context) {
    final posterHeight = itemWidth / ContentCard.posterAspectRatio;

    return posterHeight + AppSpacing.xs + _labelBlockHeight(context);
  }

  /// [ContentCard.maxTitleLines] of `titleSmall` above one line of
  /// `labelSmall`, scaled by the user's text size preference.
  static double _labelBlockHeight(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scaler = MediaQuery.textScalerOf(context);

    double lineHeight(TextStyle? style, double fallbackSize) {
      final fontSize = scaler.scale(style?.fontSize ?? fallbackSize);
      return fontSize * (style?.height ?? 1.2);
    }

    final title =
        lineHeight(textTheme.titleSmall, 14) * ContentCard.maxTitleLines;
    final subtitle = lineHeight(textTheme.labelSmall, 11);

    // Rounded up: a fractional shortfall still overflows the column.
    return (title + AppSpacing.xxs + subtitle).ceilToDouble();
  }
}
