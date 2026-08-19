import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:streambox/core/database/database_provider.dart';
import 'package:streambox/core/error/app_exception.dart';
import 'package:streambox/core/result/result.dart';
import 'package:streambox/features/catalog/data/providers/catalog_providers.dart';
import 'package:streambox/features/catalog/domain/entities/content_snapshot.dart';
import 'package:streambox/features/player/data/engine/video_player_playback_engine.dart';
import 'package:streambox/features/player/data/repositories/drift_playback_progress_repository.dart';
import 'package:streambox/features/player/domain/engine/playback_engine.dart';
import 'package:streambox/features/player/domain/entities/playback_progress.dart';
import 'package:streambox/features/player/domain/entities/playback_state.dart';
import 'package:streambox/features/player/domain/repositories/playback_progress_repository.dart';

part 'player_providers.g.dart';

/// Builds the playback engine.
///
/// The single seam between the application and the video package: overriding
/// this provider swaps the entire playback implementation, which is how the
/// player is tested without a platform channel.
@riverpod
PlaybackEngine playbackEngine(Ref ref, String contentId) {
  final engine = VideoPlayerPlaybackEngine();
  ref.onDispose(engine.dispose);

  return engine;
}

/// Where resume points are stored. Phase 7 points this at the database.
@Riverpod(keepAlive: true)
PlaybackProgressRepository playbackProgressRepository(Ref ref) =>
    DriftPlaybackProgressRepository(ref.watch(appDatabaseProvider));

/// Drives playback for one title.
///
/// Resolves the title, opens its stream, and republishes engine state. It is
/// also where playback position will be persisted in phase 7 — the throttling
/// seam ([_reportProgress]) is already in place so that adding persistence
/// does not mean rewriting the update path.
@riverpod
class PlayerNotifier extends _$PlayerNotifier {
  /// How often playback position is reported onward.
  ///
  /// The engine ticks roughly per frame; writing that through to storage would
  /// be thousands of writes per minute for information that only needs to be
  /// accurate to a few seconds.
  static const Duration progressReportInterval = Duration(seconds: 5);

  StreamSubscription<PlaybackState>? _subscription;

  /// The position at which progress was last written. Only used to decide
  /// whether enough has changed to write again.
  Duration _lastPersistedPosition = Duration.zero;

  String? _streamUrl;
  Duration _resumeFrom = Duration.zero;

  /// Captured when the title is resolved, so progress writes carry the display
  /// fields history needs without re-reading the catalogue on every tick.
  ContentSnapshot? _snapshot;

  @override
  PlaybackState build(String contentId) {
    ref.onDispose(() => _subscription?.cancel());

    unawaited(_start(contentId));

    return PlaybackState.initial.copyWith(status: PlaybackStatus.loading);
  }

  Future<void> play() => _engine.play();

  Future<void> pause() => _engine.pause();

  Future<void> togglePlayPause() =>
      state.isPlaying ? _engine.pause() : _engine.play();

  Future<void> seek(Duration position) => _engine.seek(position);

  /// Skips relative to the current position, for the ±10s controls.
  Future<void> skip(Duration offset) => _engine.seek(state.position + offset);

  Future<void> setSpeed(double speed) => _engine.setSpeed(speed);

  Future<void> toggleMuted() => _engine.setMuted(isMuted: !state.isMuted);

  /// Re-opens the stream after a failure, resuming where it stopped.
  ///
  /// Resumes from the live position rather than the last *reported* one: the
  /// report is throttled and can lag by up to [progressReportInterval], which
  /// would silently rewind the viewer on every retry.
  Future<void> retry() async {
    final streamUrl = _streamUrl;
    if (streamUrl == null) {
      await _start(contentId);
      return;
    }

    final resumeFrom = state.position;
    state = PlaybackState.initial.copyWith(status: PlaybackStatus.loading);
    await _openStream(streamUrl, startAt: resumeFrom);
  }

  PlaybackEngine get _engine => ref.read(playbackEngineProvider(contentId));

  Future<void> _start(String id) async {
    // Resolved through the catalogue rather than by fetching a title: the
    // identifier may name an episode, and only the catalogue knows how to turn
    // either kind into a stream.
    final result = await ref.read(contentRepositoryProvider).getPlayable(id);
    if (!ref.mounted) return;

    switch (result) {
      case Failure(:final error):
        state = state.copyWith(status: PlaybackStatus.failed, error: error);
        return;
      case Success(:final value):
        if (value.streamUrl.isEmpty) {
          state = state.copyWith(
            status: PlaybackStatus.failed,
            error: const PlaybackUnavailableException(),
          );
          return;
        }

        _streamUrl = value.streamUrl;
        _snapshot = value.snapshot;
        _resumeFrom = await _storedResumePoint(_snapshot!.contentId);
        if (!ref.mounted) return;

        _lastPersistedPosition = _resumeFrom;

        _subscription = _engine.stateStream.listen(_onEngineState);
        await _openStream(value.streamUrl, startAt: _resumeFrom);
    }
  }

  /// Opens a stream and starts it.
  ///
  /// Playback begins as soon as the stream is ready: the viewer arrived here
  /// by pressing play, so asking them to press it a second time is friction,
  /// not a choice. A stream that failed to open is left alone rather than
  /// having play called on nothing.
  Future<void> _openStream(
    String streamUrl, {
    required Duration startAt,
  }) async {
    await _engine.load(streamUrl: streamUrl, startAt: startAt);

    // Leaving the player mid-load disposes this notifier while the load is
    // still in flight; touching state afterwards would throw.
    if (!ref.mounted || state.hasFailed) return;

    await _engine.play();
  }

  void _onEngineState(PlaybackState next) {
    if (!ref.mounted) return;

    state = next;
    unawaited(_persistProgress(next));
  }

  /// A resume point that is effectively finished is ignored, so replaying a
  /// completed title starts from the beginning rather than the credits.
  Future<Duration> _storedResumePoint(String id) async {
    final result = await _progressRepository.getProgress(id);

    return switch (result) {
      Success(:final value) when value?.isResumable ?? false => value!.position,
      _ => Duration.zero,
    };
  }

  /// Writes the resume point, throttled to [progressReportInterval].
  ///
  /// The engine ticks roughly per frame. Writing every tick would be thousands
  /// of database writes a minute for a value that only needs to be accurate to
  /// a few seconds.
  Future<void> _persistProgress(PlaybackState next) async {
    if (!next.hasDuration) return;

    final movedEnough =
        (next.position - _lastPersistedPosition).abs() >=
        progressReportInterval;

    // Completion is always written, however small the final step, because it
    // is what removes a title from Continue Watching.
    if (!movedEnough && !next.isCompleted) return;

    final snapshot = _snapshot;
    if (snapshot == null) return;

    _lastPersistedPosition = next.position;

    await _progressRepository.saveProgress(
      content: snapshot,
      progress: PlaybackProgress(
        // Grouped under the series for an episode, so history shows one row
        // per show rather than one per episode watched.
        contentId: snapshot.contentId,
        position: next.isCompleted ? next.duration : next.position,
        duration: next.duration,
        updatedAt: DateTime.now(),
      ),
    );
  }

  PlaybackProgressRepository get _progressRepository =>
      ref.read(playbackProgressRepositoryProvider);
}
