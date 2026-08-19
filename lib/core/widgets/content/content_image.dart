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
    this.decodeWidth,
    super.key,
  });

  /// A null or empty URL renders the placeholder rather than throwing, so
  /// incomplete catalogue entries degrade quietly.
  final String? url;

  final BoxFit fit;
  final double? width;
  final double? height;
  final String? semanticLabel;

  /// Logical width the image will be drawn at.
  ///
  /// Supplied so the decoder can downsample rather than holding a full-size
  /// bitmap in memory: a 400x600 poster drawn into a 132dp card otherwise
  /// costs roughly ten times the memory it needs, and a rail holds many of
  /// them. Null falls back to measuring the box the image is given.
  final double? decodeWidth;

  @override
  Widget build(BuildContext context) {
    // Artwork is decorative when it sits behind a visible title, so the label
    // is opt-in rather than a guessed alt text on every poster.
    return Semantics(
      label: semanticLabel,
      image: true,
      excludeSemantics: true,
      child: LayoutBuilder(builder: _image),
    );
  }

  Widget _image(BuildContext context, BoxConstraints constraints) {
    final url = this.url;
    if (url == null || url.isEmpty) return const _ImagePlaceholder();

    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      width: width,
      height: height,
      memCacheWidth: _decodeWidthPixels(context, constraints),
      fadeInDuration: AppDurations.medium,
      fadeInCurve: AppDurations.enter,
      placeholder: (context, _) => const _ImagePlaceholder(),
      errorWidget: (context, _, _) =>
          const _ImagePlaceholder(icon: Icons.broken_image_outlined),
    );
  }

  /// The decode width in device pixels, or null when the box is unbounded and
  /// there is nothing reliable to measure.
  int? _decodeWidthPixels(BuildContext context, BoxConstraints constraints) {
    final logicalWidth =
        decodeWidth ??
        width ??
        (constraints.hasBoundedWidth ? constraints.maxWidth : null);

    if (logicalWidth == null || logicalWidth <= 0) return null;

    return (logicalWidth * MediaQuery.devicePixelRatioOf(context)).round();
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
