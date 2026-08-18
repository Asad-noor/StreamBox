import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streambox/app/theme/app_colors.dart';
import 'package:streambox/app/theme/app_durations.dart';
import 'package:streambox/core/error/app_exception.dart';
import 'package:streambox/core/widgets/states/app_error_view.dart';
import 'package:streambox/features/player/domain/entities/playback_state.dart';
import 'package:streambox/features/player/presentation/providers/player_providers.dart';
import 'package:streambox/features/player/presentation/widgets/player_controls.dart';
import 'package:streambox/features/player/presentation/widgets/video_surface.dart';

/// Full-screen playback.
///
/// Owns three things the notifier deliberately does not, because they are
/// properties of this screen being on screen rather than of playback itself:
/// device orientation, the system UI overlays, and control auto-hiding.
class PlayerPage extends ConsumerStatefulWidget {
  const PlayerPage({required this.contentId, this.title = '', super.key});

  final String contentId;
  final String title;

  @override
  ConsumerState<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends ConsumerState<PlayerPage>
    with WidgetsBindingObserver {
  bool _controlsVisible = true;
  bool _isFullscreen = false;

  /// Set while the app is backgrounded so playback only resumes if it was
  /// actually running — returning to a paused player must not start it.
  bool _resumeOnForeground = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _enterImmersiveMode();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _restoreChrome();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final notifier = ref.read(playerProvider(widget.contentId).notifier);

    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        _resumeOnForeground = ref
            .read(playerProvider(widget.contentId))
            .isPlaying;
        notifier.pause();
      case AppLifecycleState.resumed:
        if (_resumeOnForeground) notifier.play();
        _resumeOnForeground = false;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        break;
    }
  }

  /// Landscape is allowed only while this screen is mounted; the rest of the
  /// application is portrait, locked in `main`.
  void _enterImmersiveMode() {
    unawaited(SystemChrome.setPreferredOrientations(DeviceOrientation.values));
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  void _restoreChrome() {
    unawaited(
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]),
    );
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  void _toggleControls() =>
      setState(() => _controlsVisible = !_controlsVisible);

  void _toggleFullscreen() {
    setState(() => _isFullscreen = !_isFullscreen);

    unawaited(
      SystemChrome.setPreferredOrientations(
        _isFullscreen
            ? [
                DeviceOrientation.landscapeLeft,
                DeviceOrientation.landscapeRight,
              ]
            : DeviceOrientation.values,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final contentId = widget.contentId;
    final state = ref.watch(playerProvider(contentId));
    final notifier = ref.read(playerProvider(contentId).notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: state.hasFailed
          ? _Failure(error: state.error, onRetry: notifier.retry)
          : GestureDetector(
              onTap: _toggleControls,
              behavior: HitTestBehavior.opaque,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  VideoSurface(
                    engine: ref.watch(playbackEngineProvider(contentId)),
                  ),
                  if (state.status == PlaybackStatus.loading)
                    const Center(child: CircularProgressIndicator()),
                  AnimatedOpacity(
                    opacity: _controlsVisible ? 1 : 0,
                    duration: AppDurations.medium,
                    child: IgnorePointer(
                      ignoring: !_controlsVisible,
                      child: PlayerControls(
                        state: state,
                        title: widget.title,
                        isFullscreen: _isFullscreen,
                        onTogglePlayPause: notifier.togglePlayPause,
                        onSeek: notifier.seek,
                        onSkip: notifier.skip,
                        onToggleMuted: notifier.toggleMuted,
                        onToggleFullscreen: _toggleFullscreen,
                        onBack: () => Navigator.of(context).maybePop(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _Failure extends StatelessWidget {
  const _Failure({required this.error, required this.onRetry});

  final AppException? error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Stack(
      children: [
        AppErrorView(
          error: error ?? const PlaybackException(),
          onRetry: onRetry,
        ),
        Align(
          alignment: Alignment.topLeft,
          child: IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.arrow_back_rounded),
            tooltip: 'Back',
          ),
        ),
      ],
    ),
  );
}
