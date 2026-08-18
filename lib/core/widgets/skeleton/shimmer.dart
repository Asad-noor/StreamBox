import 'package:flutter/material.dart';
import 'package:streambox/app/theme/app_colors.dart';
import 'package:streambox/app/theme/app_durations.dart';

/// Sweeps a highlight across its subtree to signal loading.
///
/// Hand-rolled rather than pulled from a package: it is one animation
/// controller and one shader, and owning it keeps the timing on
/// [AppDurations.shimmer] with the rest of the motion system.
///
/// One controller drives the whole subtree, so a rail of twenty skeleton cards
/// costs a single animation rather than twenty.
class Shimmer extends StatefulWidget {
  const Shimmer({required this.child, this.enabled = true, super.key});

  final Widget child;

  /// When false the child renders untouched, so a skeleton can be left mounted
  /// while its animation is stopped.
  final bool enabled;

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  // Constructed eagerly rather than lazily: a `late final` initialiser would
  // not run when the widget starts disabled, and `dispose` would then build an
  // AnimationController against an already-deactivated element.
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.shimmer,
    );
    if (widget.enabled) _controller.repeat();
  }

  @override
  void didUpdateWidget(Shimmer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled == oldWidget.enabled) return;

    if (widget.enabled) {
      _controller.repeat();
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    // The child is built once and reused on every tick: only the shader moves.
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) => ShaderMask(
        blendMode: BlendMode.srcATop,
        shaderCallback: (bounds) => LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: const [
            AppColors.surfaceMuted,
            AppColors.surfaceElevated,
            AppColors.surfaceMuted,
          ],
          stops: _stops,
        ).createShader(bounds),
        child: child,
      ),
    );
  }

  /// Slides a three-stop window from fully off the left edge to fully off the
  /// right, so the highlight enters and exits rather than popping.
  List<double> get _stops {
    final progress = _controller.value * 2 - 0.5;

    return [
      (progress - 0.3).clamp(0.0, 1.0),
      progress.clamp(0.0, 1.0),
      (progress + 0.3).clamp(0.0, 1.0),
    ];
  }
}
