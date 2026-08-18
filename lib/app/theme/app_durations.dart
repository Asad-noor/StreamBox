import 'package:flutter/animation.dart';

/// Motion timings and curves.
///
/// Three durations cover the whole application deliberately: a small, shared
/// set is what makes transitions feel like one system rather than many.
abstract final class AppDurations {
  /// State changes on a single element: ripples, icon swaps, colour shifts.
  static const Duration fast = Duration(milliseconds: 150);

  /// The default. Card presses, fades, expansion.
  static const Duration medium = Duration(milliseconds: 250);

  /// Route transitions and larger reveals.
  static const Duration slow = Duration(milliseconds: 400);

  /// One sweep of a skeleton shimmer.
  static const Duration shimmer = Duration(milliseconds: 1200);

  /// How long player controls stay visible before auto-hiding.
  static const Duration controlsAutoHide = Duration(seconds: 3);

  /// Entering and settling. Fast start, gentle stop.
  static const Curve enter = Curves.easeOutCubic;

  /// Leaving. Gentle start, quick finish.
  static const Curve exit = Curves.easeInCubic;

  /// Symmetric changes that neither enter nor leave.
  static const Curve standard = Curves.easeInOutCubic;
}
