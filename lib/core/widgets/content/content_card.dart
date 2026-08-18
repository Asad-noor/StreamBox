import 'package:flutter/material.dart';
import 'package:streambox/app/theme/app_colors.dart';
import 'package:streambox/app/theme/app_durations.dart';
import 'package:streambox/app/theme/app_radius.dart';
import 'package:streambox/app/theme/app_spacing.dart';
import 'package:streambox/core/widgets/content/content_image.dart';

/// Poster tile used by every rail and grid in the application.
///
/// Takes primitives rather than a domain entity so the design system stays
/// independent of any feature's models and can be tested without them.
class ContentCard extends StatefulWidget {
  const ContentCard({
    required this.title,
    this.imageUrl,
    this.subtitle,
    this.progress,
    this.onTap,
    this.width = defaultWidth,
    super.key,
  });

  /// Sized so three cards and their gutters fit a 360dp screen with a peek of
  /// the fourth, which is what signals the rail scrolls.
  static const double defaultWidth = 132;

  /// Standard poster proportion.
  static const double posterAspectRatio = 2 / 3;

  /// Titles wrap to at most this many lines. [ContentRail] reads it to size
  /// itself, so the two cannot drift apart.
  static const int maxTitleLines = 2;

  final String title;
  final String? imageUrl;
  final String? subtitle;

  /// Watched fraction in `0..1`. Non-null draws the resume bar.
  final double? progress;

  final VoidCallback? onTap;
  final double width;

  @override
  State<ContentCard> createState() => _ContentCardState();
}

class _ContentCardState extends State<ContentCard> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      button: widget.onTap != null,
      label: _semanticLabel,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        child: AnimatedScale(
          scale: _pressed ? 0.96 : 1,
          duration: AppDurations.fast,
          curve: AppDurations.standard,
          child: SizedBox(
            width: widget.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _Poster(imageUrl: widget.imageUrl, progress: widget.progress),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  widget.title,
                  maxLines: ContentCard.maxTitleLines,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall,
                ),
                if (widget.subtitle case final subtitle?) ...[
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String get _semanticLabel {
    final parts = [
      widget.title,
      ?widget.subtitle,
      if (widget.progress case final progress?)
        '${(progress * 100).round()} percent watched',
    ];

    return parts.join(', ');
  }
}

class _Poster extends StatelessWidget {
  const _Poster({required this.imageUrl, required this.progress});

  final String? imageUrl;
  final double? progress;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadius.allMd,
      child: AspectRatio(
        aspectRatio: ContentCard.posterAspectRatio,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ContentImage(url: imageUrl),
            if (progress case final progress?)
              Align(
                alignment: Alignment.bottomCenter,
                child: LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  minHeight: 3,
                  backgroundColor: AppColors.surfaceElevated,
                  valueColor: const AlwaysStoppedAnimation(AppColors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
