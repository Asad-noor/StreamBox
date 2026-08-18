import 'package:flutter/material.dart';
import 'package:streambox/app/theme/app_colors.dart';
import 'package:streambox/app/theme/app_spacing.dart';

/// A dot-separated run of facts: year, rating, duration, genre.
///
/// Wraps rather than overflows, so long metadata survives large text scales
/// and narrow screens instead of throwing a layout error.
class MetadataRow extends StatelessWidget {
  const MetadataRow({required this.items, this.style, super.key});

  final List<String> items;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final visible = items.where((item) => item.isNotEmpty).toList();
    if (visible.isEmpty) return const SizedBox.shrink();

    final effectiveStyle = style ?? Theme.of(context).textTheme.labelMedium;

    return Semantics(
      // Read as one phrase; the bullets are visual punctuation, not content.
      label: visible.join(', '),
      excludeSemantics: true,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: AppSpacing.xs,
        runSpacing: AppSpacing.xxs,
        children: [
          for (final (index, item) in visible.indexed) ...[
            if (index > 0)
              const Icon(Icons.circle, size: 3, color: AppColors.textTertiary),
            Text(item, style: effectiveStyle),
          ],
        ],
      ),
    );
  }
}
