import 'package:flutter/material.dart';
import 'package:streambox/app/theme/app_colors.dart';
import 'package:streambox/features/player/data/engine/video_player_playback_engine.dart';
import 'package:streambox/features/player/domain/engine/playback_engine.dart';
import 'package:video_player/video_player.dart';

/// Renders the video frames.
///
/// The second and last file that touches the video package, because painting
/// frames genuinely requires the package's own render widget — there is no way
/// to abstract a texture behind a plain interface. It stays a leaf widget with
/// no logic, so swapping engines means replacing this file and the engine, and
/// nothing else.
///
/// An engine that cannot supply a surface renders a black frame rather than
/// failing, which is what keeps the controls usable while a stream loads.
class VideoSurface extends StatelessWidget {
  const VideoSurface({required this.engine, super.key});

  final PlaybackEngine engine;

  @override
  Widget build(BuildContext context) {
    final controller = switch (engine) {
      VideoPlayerPlaybackEngine(:final controller) => controller,
      _ => null,
    };

    if (controller == null || !controller.value.isInitialized) {
      return const ColoredBox(color: AppColors.background);
    }

    return ColoredBox(
      color: AppColors.background,
      child: Center(
        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: VideoPlayer(controller),
        ),
      ),
    );
  }
}
