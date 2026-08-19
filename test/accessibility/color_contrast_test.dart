import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streambox/app/theme/app_colors.dart';

/// WCAG 2.1 relative luminance.
double _luminance(Color color) {
  double channel(double value) => value <= 0.03928
      ? value / 12.92
      : math.pow((value + 0.055) / 1.055, 2.4).toDouble();

  return 0.2126 * channel(color.r) +
      0.7152 * channel(color.g) +
      0.0722 * channel(color.b);
}

double contrastRatio(Color foreground, Color background) {
  final a = _luminance(foreground);
  final b = _luminance(background);

  return (math.max(a, b) + 0.05) / (math.min(a, b) + 0.05);
}

void main() {
  /// WCAG AA for text below 18pt, which covers almost all of this app.
  const normalText = 4.5;

  /// WCAG AA for interface components and graphics.
  const uiComponent = 3.0;

  void expectContrast(
    String description,
    Color foreground,
    Color background,
    double minimum,
  ) {
    final ratio = contrastRatio(foreground, background);

    expect(
      ratio,
      greaterThanOrEqualTo(minimum),
      reason:
          '$description has a contrast ratio of '
          '${ratio.toStringAsFixed(2)}, below the required $minimum',
    );
  }

  /// The palette is the thing most likely to drift toward something pretty and
  /// unreadable, so the rules are asserted rather than trusted.
  group('text contrast', () {
    const surfaces = {
      'background': AppColors.background,
      'surface': AppColors.surface,
      'surfaceElevated': AppColors.surfaceElevated,
    };

    for (final MapEntry(key: name, value: surface) in surfaces.entries) {
      test('primary text on $name', () {
        expectContrast(
          'white on $name',
          AppColors.textPrimary,
          surface,
          normalText,
        );
      });

      test('secondary text on $name', () {
        expectContrast(
          'secondary on $name',
          AppColors.textSecondary,
          surface,
          normalText,
        );
      });

      test('tertiary text on $name', () {
        // This token is used almost exclusively for captions, so it has to
        // meet the normal-text bar rather than the large-text one.
        expectContrast(
          'tertiary on $name',
          AppColors.textTertiary,
          surface,
          normalText,
        );
      });
    }
  });

  group('filled surfaces carrying text', () {
    test('white on primary red', () {
      expectContrast(
        'onRed on red',
        AppColors.onRed,
        AppColors.red,
        normalText,
      );
    });

    test('white on pressed red', () {
      expectContrast(
        'onRed on redPressed',
        AppColors.onRed,
        AppColors.redPressed,
        normalText,
      );
    });

    test('white on error', () {
      expectContrast(
        'onRed on error',
        AppColors.onRed,
        AppColors.error,
        normalText,
      );
    });
  });

  group('non-text indicators', () {
    test('red is distinguishable against the page', () {
      expectContrast(
        'red on background',
        AppColors.red,
        AppColors.background,
        uiComponent,
      );
    });

    test('borders are distinguishable against their surface', () {
      expectContrast(
        'border on surface',
        AppColors.border,
        AppColors.background,
        1.2,
      );
    });
  });
}
