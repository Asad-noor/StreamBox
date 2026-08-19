import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:streambox/app/theme/app_spacing.dart';
import 'package:streambox/core/layout/breakpoints.dart';
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
    this.itemWidth,
    super.key,
  });

  final String title;
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final VoidCallback? onSeeAll;

  /// Overrides the width derived from the available space. Drives the rail's
  /// height too, so it does not depend on measuring children.
  final double? itemWidth;

  @override
  Widget build(BuildContext context) {
    if (itemCount == 0) return const SizedBox.shrink();

    return LayoutBuilder(builder: _build);
  }

  Widget _build(BuildContext context, BoxConstraints constraints) {
    // Sized from the width the rail actually has rather than the window, so a
    // rail in a narrow panel still lays out sensibly.
    final size = LayoutSize.fromWidth(constraints.maxWidth);
    final width = itemWidth ?? Breakpoints.cardWidth(size);
    final gutter = Breakpoints.gutter(size);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: title, onSeeAll: onSeeAll, gutter: gutter),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: _railHeight(context, width),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: gutter),
            // Keep one screen-width of cards warm on either side so a flick
            // does not reveal placeholders.
            scrollCacheExtent: ScrollCacheExtent.pixels(width * 3),
            itemCount: itemCount,
            separatorBuilder: (context, index) =>
                const SizedBox(width: AppSpacing.sm),
            // Each card gets its own layer, so scrolling the rail does not
            // force every sibling to repaint with it.
            itemBuilder: (context, index) => RepaintBoundary(
              child: SizedBox(width: width, child: itemBuilder(context, index)),
            ),
          ),
        ),
      ],
    );
  }

  /// Poster height plus the title and subtitle lines below it.
  ///
  /// Derived from the live text theme rather than a fixed constant: a change
  /// to the type scale would otherwise silently clip every card in the app.
  double _railHeight(BuildContext context, double width) {
    final posterHeight = width / ContentCard.posterAspectRatio;

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
