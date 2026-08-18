// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Builds the playback engine.
///
/// The single seam between the application and the video package: overriding
/// this provider swaps the entire playback implementation, which is how the
/// player is tested without a platform channel.

@ProviderFor(playbackEngine)
final playbackEngineProvider = PlaybackEngineFamily._();

/// Builds the playback engine.
///
/// The single seam between the application and the video package: overriding
/// this provider swaps the entire playback implementation, which is how the
/// player is tested without a platform channel.

final class PlaybackEngineProvider
    extends $FunctionalProvider<PlaybackEngine, PlaybackEngine, PlaybackEngine>
    with $Provider<PlaybackEngine> {
  /// Builds the playback engine.
  ///
  /// The single seam between the application and the video package: overriding
  /// this provider swaps the entire playback implementation, which is how the
  /// player is tested without a platform channel.
  PlaybackEngineProvider._({
    required PlaybackEngineFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'playbackEngineProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$playbackEngineHash();

  @override
  String toString() {
    return r'playbackEngineProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<PlaybackEngine> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PlaybackEngine create(Ref ref) {
    final argument = this.argument as String;
    return playbackEngine(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlaybackEngine value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlaybackEngine>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PlaybackEngineProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$playbackEngineHash() => r'9b14e0125de19fa1592a43fbd859945cd74f2bc1';

/// Builds the playback engine.
///
/// The single seam between the application and the video package: overriding
/// this provider swaps the entire playback implementation, which is how the
/// player is tested without a platform channel.

final class PlaybackEngineFamily extends $Family
    with $FunctionalFamilyOverride<PlaybackEngine, String> {
  PlaybackEngineFamily._()
    : super(
        retry: null,
        name: r'playbackEngineProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Builds the playback engine.
  ///
  /// The single seam between the application and the video package: overriding
  /// this provider swaps the entire playback implementation, which is how the
  /// player is tested without a platform channel.

  PlaybackEngineProvider call(String contentId) =>
      PlaybackEngineProvider._(argument: contentId, from: this);

  @override
  String toString() => r'playbackEngineProvider';
}

/// Where resume points are stored. Phase 7 points this at the database.

@ProviderFor(playbackProgressRepository)
final playbackProgressRepositoryProvider =
    PlaybackProgressRepositoryProvider._();

/// Where resume points are stored. Phase 7 points this at the database.

final class PlaybackProgressRepositoryProvider
    extends
        $FunctionalProvider<
          PlaybackProgressRepository,
          PlaybackProgressRepository,
          PlaybackProgressRepository
        >
    with $Provider<PlaybackProgressRepository> {
  /// Where resume points are stored. Phase 7 points this at the database.
  PlaybackProgressRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playbackProgressRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playbackProgressRepositoryHash();

  @$internal
  @override
  $ProviderElement<PlaybackProgressRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PlaybackProgressRepository create(Ref ref) {
    return playbackProgressRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlaybackProgressRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlaybackProgressRepository>(value),
    );
  }
}

String _$playbackProgressRepositoryHash() =>
    r'9109b927d684df2f1042e9629098cb301ada5977';

/// Drives playback for one title.
///
/// Resolves the title, opens its stream, and republishes engine state. It is
/// also where playback position will be persisted in phase 7 — the throttling
/// seam ([_reportProgress]) is already in place so that adding persistence
/// does not mean rewriting the update path.

@ProviderFor(PlayerNotifier)
final playerProvider = PlayerNotifierFamily._();

/// Drives playback for one title.
///
/// Resolves the title, opens its stream, and republishes engine state. It is
/// also where playback position will be persisted in phase 7 — the throttling
/// seam ([_reportProgress]) is already in place so that adding persistence
/// does not mean rewriting the update path.
final class PlayerNotifierProvider
    extends $NotifierProvider<PlayerNotifier, PlaybackState> {
  /// Drives playback for one title.
  ///
  /// Resolves the title, opens its stream, and republishes engine state. It is
  /// also where playback position will be persisted in phase 7 — the throttling
  /// seam ([_reportProgress]) is already in place so that adding persistence
  /// does not mean rewriting the update path.
  PlayerNotifierProvider._({
    required PlayerNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'playerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$playerNotifierHash();

  @override
  String toString() {
    return r'playerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PlayerNotifier create() => PlayerNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlaybackState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlaybackState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PlayerNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$playerNotifierHash() => r'da936cef0ce1c8450216e28461673665869ef42f';

/// Drives playback for one title.
///
/// Resolves the title, opens its stream, and republishes engine state. It is
/// also where playback position will be persisted in phase 7 — the throttling
/// seam ([_reportProgress]) is already in place so that adding persistence
/// does not mean rewriting the update path.

final class PlayerNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          PlayerNotifier,
          PlaybackState,
          PlaybackState,
          PlaybackState,
          String
        > {
  PlayerNotifierFamily._()
    : super(
        retry: null,
        name: r'playerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Drives playback for one title.
  ///
  /// Resolves the title, opens its stream, and republishes engine state. It is
  /// also where playback position will be persisted in phase 7 — the throttling
  /// seam ([_reportProgress]) is already in place so that adding persistence
  /// does not mean rewriting the update path.

  PlayerNotifierProvider call(String contentId) =>
      PlayerNotifierProvider._(argument: contentId, from: this);

  @override
  String toString() => r'playerProvider';
}

/// Drives playback for one title.
///
/// Resolves the title, opens its stream, and republishes engine state. It is
/// also where playback position will be persisted in phase 7 — the throttling
/// seam ([_reportProgress]) is already in place so that adding persistence
/// does not mean rewriting the update path.

abstract class _$PlayerNotifier extends $Notifier<PlaybackState> {
  late final _$args = ref.$arg as String;
  String get contentId => _$args;

  PlaybackState build(String contentId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PlaybackState, PlaybackState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PlaybackState, PlaybackState>,
              PlaybackState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
