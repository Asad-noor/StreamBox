import 'package:flutter/widgets.dart';

/// Layout classes, taken from the width available to a widget rather than the
/// physical screen, so a widget inside a split view or a side panel is sized by
/// the space it actually has.
enum LayoutSize {
  /// Phones in portrait.
  compact,

  /// Large phones in landscape, small tablets.
  medium,

  /// Tablets and larger.
  expanded;

  static LayoutSize fromWidth(double width) {
    if (width >= Breakpoints.expanded) return LayoutSize.expanded;
    if (width >= Breakpoints.medium) return LayoutSize.medium;

    return LayoutSize.compact;
  }

  bool get isCompact => this == LayoutSize.compact;

  bool get isAtLeastMedium => this != LayoutSize.compact;
}

/// The widths at which the layout changes.
///
/// Deliberately few: every extra breakpoint is another set of states to keep
/// correct, and two cover the range this application targets.
abstract final class Breakpoints {
  static const double medium = 600;
  static const double expanded = 900;

  /// The widest a column of running text is allowed to get.
  ///
  /// Long measures are hard to read, so on a tablet the synopsis stops growing
  /// rather than stretching to the full window.
  static const double readableWidth = 720;

  /// Poster width per layout class. Larger screens get larger cards instead of
  /// simply fitting more phone-sized ones.
  static double cardWidth(LayoutSize size) => switch (size) {
    LayoutSize.compact => 132,
    LayoutSize.medium => 156,
    LayoutSize.expanded => 180,
  };

  /// Horizontal page inset per layout class.
  static double gutter(LayoutSize size) => switch (size) {
    LayoutSize.compact => 16,
    LayoutSize.medium => 24,
    LayoutSize.expanded => 32,
  };
}

/// Resolves the [LayoutSize] for the space a widget has been given.
extension LayoutSizeContext on BuildContext {
  /// Based on the window. Prefer [LayoutSize.fromWidth] with a `LayoutBuilder`
  /// constraint where the widget may not occupy the whole window.
  LayoutSize get layoutSize =>
      LayoutSize.fromWidth(MediaQuery.sizeOf(this).width);
}

/// Centres and caps its child at [Breakpoints.readableWidth].
class ReadableWidth extends StatelessWidget {
  const ReadableWidth({
    required this.child,
    this.maxWidth = Breakpoints.readableWidth,
    super.key,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: child,
    ),
  );
}
