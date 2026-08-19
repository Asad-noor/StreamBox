import 'package:flutter/material.dart';

/// The complete colour vocabulary of the application.
///
/// Widgets read colours from `Theme.of(context)` wherever a Material component
/// exposes one; this class is the single place those theme values originate,
/// and the source for the handful of brand colours Material has no slot for.
abstract final class AppColors {
  // ---------------------------------------------------------------------------
  // Brand
  // ---------------------------------------------------------------------------

  /// Primary action, active navigation, progress, focus.
  ///
  /// Chosen so that white text on it clears WCAG AA for normal text (5.0:1).
  /// A brighter red looks better in isolation but fails at 3.7:1, which makes
  /// every filled button label non-compliant.
  static const Color red = Color(0xFFD91E36);

  /// Pressed and hovered states of [red].
  static const Color redPressed = Color(0xFFB01528);

  /// Very low-opacity red for tinted surfaces and glows.
  static const Color redSubtle = Color(0x1AD91E36);

  // ---------------------------------------------------------------------------
  // Surfaces
  // ---------------------------------------------------------------------------

  /// Page background. Near-black rather than pure black so that elevation
  /// remains legible on OLED panels.
  static const Color background = Color(0xFF0A0A0B);

  /// Cards, sheets, and the app bar at rest.
  static const Color surface = Color(0xFF131316);

  /// Raised surfaces: menus, dialogs, selected rows.
  static const Color surfaceElevated = Color(0xFF1C1C21);

  /// Skeleton placeholders and image backdrops before load.
  static const Color surfaceMuted = Color(0xFF232329);

  // ---------------------------------------------------------------------------
  // Content
  // ---------------------------------------------------------------------------

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA1A1AA);

  /// Captions and metadata.
  ///
  /// Light enough to clear WCAG AA against [surfaceElevated], the darkest
  /// surface it appears on. The obvious darker grey reads better as "muted"
  /// but lands at 3.5:1, which fails for text below 18pt — and this token is
  /// used almost exclusively for small text.
  static const Color textTertiary = Color(0xFF8A8A94);

  /// Text and icons drawn on top of [red].
  static const Color onRed = Color(0xFFFFFFFF);

  // ---------------------------------------------------------------------------
  // Lines
  // ---------------------------------------------------------------------------

  static const Color border = Color(0xFF27272A);
  static const Color divider = Color(0xFF1F1F23);

  // ---------------------------------------------------------------------------
  // Status
  // ---------------------------------------------------------------------------

  /// Also used as a button background, so white on it must clear AA (4.7:1).
  static const Color error = Color(0xFFD93036);
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);

  // ---------------------------------------------------------------------------
  // Effects
  // ---------------------------------------------------------------------------

  /// Scrim laid over hero artwork so overlaid text keeps its contrast ratio.
  static const List<Color> heroScrim = [
    Color(0x000A0A0B),
    Color(0x990A0A0B),
    Color(0xFF0A0A0B),
  ];

  /// Scrim for the lower portion of a content card.
  static const List<Color> cardScrim = [Color(0x00000000), Color(0xCC000000)];
}
