import 'package:flutter/material.dart';
import 'package:streambox/app/theme/app_colors.dart';
import 'package:streambox/app/theme/app_durations.dart';
import 'package:streambox/app/theme/app_spacing.dart';
import 'package:streambox/features/player/domain/entities/playback_state.dart';
import 'package:streambox/features/player/presentation/widgets/playback_scrubber.dart';

/// The overlay: title bar, transport controls, scrubber.
///
/// Purely presentational — every interaction is a callback, so the whole
/// control surface can be widget-tested against a constructed [PlaybackState]
/// with no engine and no platform channel.
class PlayerControls extends StatelessWidget {
  const PlayerControls({
    required this.state,
    required this.title,
    required this.onTogglePlayPause,
    required this.onSeek,
    required this.onSkip,
    required this.onToggleMuted,
    required this.onToggleFullscreen,
    required this.onBack,
    required this.isFullscreen,
    super.key,
  });

  /// How far the ±buttons jump. Ten seconds is the platform convention.
  static const Duration skipInterval = Duration(seconds: 10);

  final PlaybackState state;
  final String title;
  final VoidCallback onTogglePlayPause;
  final ValueChanged<Duration> onSeek;
  final ValueChanged<Duration> onSkip;
  final VoidCallback onToggleMuted;
  final VoidCallback onToggleFullscreen;
  final VoidCallback onBack;
  final bool isFullscreen;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black.withValues(alpha: 0.45),
      child: SafeArea(
        child: Column(
          children: [
            _TopBar(title: title, onBack: onBack),
            Expanded(
              child: Center(
                child: _TransportRow(
                  state: state,
                  onTogglePlayPause: onTogglePlayPause,
                  onSkip: onSkip,
                ),
              ),
            ),
            _BottomBar(
              state: state,
              onSeek: onSeek,
              onToggleMuted: onToggleMuted,
              onToggleFullscreen: onToggleFullscreen,
              isFullscreen: isFullscreen,
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      IconButton(
        onPressed: onBack,
        icon: const Icon(Icons.arrow_back_rounded),
        tooltip: 'Back',
      ),
      Expanded(
        child: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      const SizedBox(width: AppSpacing.md),
    ],
  );
}

class _TransportRow extends StatelessWidget {
  const _TransportRow({
    required this.state,
    required this.onTogglePlayPause,
    required this.onSkip,
  });

  final PlaybackState state;
  final VoidCallback onTogglePlayPause;
  final ValueChanged<Duration> onSkip;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      IconButton(
        iconSize: 34,
        onPressed: () => onSkip(-PlayerControls.skipInterval),
        icon: const Icon(Icons.replay_10_rounded),
        tooltip: 'Back 10 seconds',
      ),
      const SizedBox(width: AppSpacing.xl),
      _PlayPauseButton(state: state, onPressed: onTogglePlayPause),
      const SizedBox(width: AppSpacing.xl),
      IconButton(
        iconSize: 34,
        onPressed: () => onSkip(PlayerControls.skipInterval),
        icon: const Icon(Icons.forward_10_rounded),
        tooltip: 'Forward 10 seconds',
      ),
    ],
  );
}

class _PlayPauseButton extends StatelessWidget {
  const _PlayPauseButton({required this.state, required this.onPressed});

  final PlaybackState state;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    // Mid-stream stalls replace the button with a spinner in place, so the
    // control does not jump position as buffering comes and goes.
    if (state.status == PlaybackStatus.buffering) {
      return const SizedBox(
        width: 64,
        height: 64,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final isPlaying = state.isPlaying;
    final label = state.isCompleted ? 'Replay' : (isPlaying ? 'Pause' : 'Play');

    return IconButton.filled(
      iconSize: 40,
      onPressed: onPressed,
      tooltip: label,
      style: IconButton.styleFrom(
        backgroundColor: AppColors.red,
        foregroundColor: AppColors.onRed,
      ),
      icon: AnimatedSwitcher(
        duration: AppDurations.fast,
        child: Icon(
          state.isCompleted
              ? Icons.replay_rounded
              : (isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded),
          key: ValueKey(label),
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.state,
    required this.onSeek,
    required this.onToggleMuted,
    required this.onToggleFullscreen,
    required this.isFullscreen,
  });

  final PlaybackState state;
  final ValueChanged<Duration> onSeek;
  final VoidCallback onToggleMuted;
  final VoidCallback onToggleFullscreen;
  final bool isFullscreen;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      PlaybackScrubber(state: state, onSeek: onSeek),
      Row(
        children: [
          IconButton(
            onPressed: onToggleMuted,
            icon: Icon(
              state.isMuted
                  ? Icons.volume_off_rounded
                  : Icons.volume_up_rounded,
            ),
            tooltip: state.isMuted ? 'Unmute' : 'Mute',
          ),
          const Spacer(),
          IconButton(
            onPressed: onToggleFullscreen,
            icon: Icon(
              isFullscreen
                  ? Icons.fullscreen_exit_rounded
                  : Icons.fullscreen_rounded,
            ),
            tooltip: isFullscreen ? 'Exit full screen' : 'Full screen',
          ),
        ],
      ),
    ],
  );
}
