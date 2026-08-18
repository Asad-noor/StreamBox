import 'package:flutter/material.dart';
import 'package:streambox/app/theme/app_colors.dart';
import 'package:streambox/app/theme/app_spacing.dart';
import 'package:streambox/features/player/domain/entities/playback_state.dart';

/// Formats a duration as `1:02:03` or `2:03`.
String formatPlaybackTime(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(Duration.minutesPerHour);
  final seconds = duration.inSeconds.remainder(Duration.secondsPerMinute);

  final paddedSeconds = seconds.toString().padLeft(2, '0');

  if (hours > 0) {
    return '$hours:${minutes.toString().padLeft(2, '0')}:$paddedSeconds';
  }

  return '$minutes:$paddedSeconds';
}

/// The seek bar and time readout.
///
/// Holds the in-progress drag locally so the thumb tracks the finger rather
/// than snapping back to whatever position the engine last reported. The seek
/// is issued once, on release.
class PlaybackScrubber extends StatefulWidget {
  const PlaybackScrubber({
    required this.state,
    required this.onSeek,
    super.key,
  });

  final PlaybackState state;
  final ValueChanged<Duration> onSeek;

  @override
  State<PlaybackScrubber> createState() => _PlaybackScrubberState();
}

class _PlaybackScrubberState extends State<PlaybackScrubber> {
  double? _dragValue;

  Duration get _displayedPosition => _dragValue == null
      ? widget.state.position
      : widget.state.duration * _dragValue!;

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final theme = Theme.of(context);

    // A live stream reports no duration; a scrubber would be meaningless.
    if (!state.hasDuration) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Row(
          children: [
            Text(
              formatPlaybackTime(state.position),
              style: theme.textTheme.labelSmall,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // The buffered track sits beneath the slider so the viewer can see
            // how far ahead it is safe to seek.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: LinearProgressIndicator(
                value: state.bufferedProgress,
                minHeight: 2,
                backgroundColor: AppColors.surfaceMuted,
                valueColor: const AlwaysStoppedAnimation(
                  AppColors.textTertiary,
                ),
              ),
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 2,
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                activeTrackColor: AppColors.red,
                inactiveTrackColor: Colors.transparent,
                thumbColor: AppColors.red,
              ),
              child: Slider(
                value: _dragValue ?? state.progress,
                onChanged: (value) => setState(() => _dragValue = value),
                onChangeEnd: (value) {
                  widget.onSeek(state.duration * value);
                  setState(() => _dragValue = null);
                },
                semanticFormatterCallback: (value) =>
                    formatPlaybackTime(state.duration * value),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formatPlaybackTime(_displayedPosition),
                style: theme.textTheme.labelSmall,
              ),
              Text(
                '-${formatPlaybackTime(state.duration - _displayedPosition)}',
                style: theme.textTheme.labelSmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
