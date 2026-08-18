/// The 4pt spacing scale.
///
/// Every gap, pad, and inset in the application comes from this scale so that
/// vertical rhythm stays consistent as screens are added.
abstract final class AppSpacing {
  /// 4 — hairline gaps between tightly coupled elements.
  static const double xxs = 4;

  /// 8 — icon-to-label, chip padding.
  static const double xs = 8;

  /// 12 — inner padding of compact components.
  static const double sm = 12;

  /// 16 — the default horizontal page gutter.
  static const double md = 16;

  /// 20 — gap between cards in a rail.
  static const double lg = 20;

  /// 24 — gap between unrelated blocks.
  static const double xl = 24;

  /// 32 — gap between content sections.
  static const double xxl = 32;

  /// 48 — top and bottom breathing room for large layouts.
  static const double xxxl = 48;

  /// The horizontal inset applied to page-level content.
  static const double pageGutter = md;

  /// Vertical gap between two content rails on the home screen.
  static const double sectionGap = xxl;
}
