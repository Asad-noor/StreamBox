import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:streambox/app/theme/app_colors.dart';
import 'package:streambox/app/theme/app_durations.dart';

/// Every remote image in the application is drawn through this widget.
///
/// It is the only file that imports the caching package, so swapping the
/// implementation later touches one place — the same containment applied to
/// Dio in the networking layer.
class ContentImage extends StatelessWidget {
  const ContentImage({
    required this.url,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.semanticLabel,
    super.key,
  });

  /// A null or empty URL renders the placeholder rather than throwing, so
  /// incomplete catalogue entries degrade quietly.
  final String? url;

  final BoxFit fit;
  final double? width;
  final double? height;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final image = switch (url) {
      final String url when url.isNotEmpty => CachedNetworkImage(
        imageUrl: url,
        fit: fit,
        width: width,
        height: height,
        fadeInDuration: AppDurations.medium,
        fadeInCurve: AppDurations.enter,
        placeholder: (context, _) => const _ImagePlaceholder(),
        errorWidget: (context, _, _) =>
            const _ImagePlaceholder(icon: Icons.broken_image_outlined),
      ),
      _ => const _ImagePlaceholder(),
    };

    // Artwork is decorative when it sits behind a visible title, so the label
    // is opt-in rather than a guessed alt text on every poster.
    return Semantics(
      label: semanticLabel,
      image: true,
      excludeSemantics: true,
      child: image,
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({this.icon = Icons.movie_outlined});

  final IconData icon;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: AppColors.surfaceMuted,
    child: Center(child: Icon(icon, color: AppColors.textTertiary, size: 28)),
  );
}
