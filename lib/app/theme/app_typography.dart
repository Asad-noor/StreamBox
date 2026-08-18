import 'package:flutter/material.dart';
import 'package:streambox/app/theme/app_colors.dart';

/// The type scale.
///
/// Built explicitly rather than by tinting a Material default so the hierarchy
/// is visible in one place and stays stable if the platform's defaults shift.
/// Sizes are logical pixels and scale with the user's text size preference;
/// nothing here disables that.
abstract final class AppTypography {
  /// Inter, shipped as a single variable font. See `pubspec.yaml`.
  static const String fontFamily = 'Inter';

  /// The OpenType axis that carries weight in a variable font.
  static const String _weightAxis = 'wght';

  /// Builds a style that sets the weight twice, deliberately.
  ///
  /// [FontWeight] alone selects the nearest named instance, which on a
  /// variable font quantises to 400/700 and loses the intermediate weights the
  /// scale depends on. [FontVariation] drives the `wght` axis directly for the
  /// real value; the [FontWeight] is kept so that fallback fonts, and any
  /// platform that declines to interpolate, still render a sensible weight.
  static TextStyle _style({
    required double size,
    required double height,
    required int weight,
    double? letterSpacing,
    Color color = AppColors.textPrimary,
  }) => TextStyle(
    fontSize: size,
    height: height,
    letterSpacing: letterSpacing,
    color: color,
    fontWeight: FontWeight.values.firstWhere(
      (candidate) => candidate.value == _nearestNamedWeight(weight),
    ),
    fontVariations: [FontVariation(_weightAxis, weight.toDouble())],
  );

  /// Rounds to the nearest hundred, which is how [FontWeight] is enumerated.
  static int _nearestNamedWeight(int weight) =>
      (weight / 100).round().clamp(1, 9) * 100;

  // Hero titles and other display-scale text.
  static final TextStyle displayLarge = _style(
    size: 40,
    height: 1.1,
    weight: 800,
    letterSpacing: -1,
  );
  static final TextStyle displayMedium = _style(
    size: 32,
    height: 1.15,
    weight: 800,
    letterSpacing: -0.5,
  );
  static final TextStyle displaySmall = _style(
    size: 28,
    height: 1.2,
    weight: 700,
    letterSpacing: -0.25,
  );

  // Screen and dialog titles.
  static final TextStyle headlineLarge = _style(
    size: 24,
    height: 1.25,
    weight: 700,
  );
  static final TextStyle headlineMedium = _style(
    size: 20,
    height: 1.3,
    weight: 700,
  );
  static final TextStyle headlineSmall = _style(
    size: 18,
    height: 1.3,
    weight: 600,
  );

  // Section headers and card titles.
  static final TextStyle titleLarge = _style(
    size: 18,
    height: 1.35,
    weight: 700,
  );
  static final TextStyle titleMedium = _style(
    size: 16,
    height: 1.4,
    weight: 600,
  );
  static final TextStyle titleSmall = _style(
    size: 14,
    height: 1.4,
    weight: 600,
  );

  // Descriptions and running text.
  static final TextStyle bodyLarge = _style(size: 16, height: 1.5, weight: 400);
  static final TextStyle bodyMedium = _style(
    size: 14,
    height: 1.5,
    weight: 400,
    color: AppColors.textSecondary,
  );
  static final TextStyle bodySmall = _style(
    size: 12,
    height: 1.45,
    weight: 400,
    color: AppColors.textSecondary,
  );

  // Buttons, tabs, metadata pills.
  static final TextStyle labelLarge = _style(
    size: 15,
    height: 1.2,
    weight: 600,
    letterSpacing: 0.1,
  );
  static final TextStyle labelMedium = _style(
    size: 13,
    height: 1.2,
    weight: 600,
    letterSpacing: 0.2,
    color: AppColors.textSecondary,
  );
  static final TextStyle labelSmall = _style(
    size: 11,
    height: 1.2,
    weight: 600,
    letterSpacing: 0.4,
    color: AppColors.textTertiary,
  );

  static TextTheme get textTheme => TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    displaySmall: displaySmall,
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    headlineSmall: headlineSmall,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    titleSmall: titleSmall,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
  );
}
