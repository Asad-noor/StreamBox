// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Everything watched, newest first.

@ProviderFor(watchHistory)
final watchHistoryProvider = WatchHistoryProvider._();

/// Everything watched, newest first.

final class WatchHistoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<WatchHistoryEntry>>,
          List<WatchHistoryEntry>,
          Stream<List<WatchHistoryEntry>>
        >
    with
        $FutureModifier<List<WatchHistoryEntry>>,
        $StreamProvider<List<WatchHistoryEntry>> {
  /// Everything watched, newest first.
  WatchHistoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'watchHistoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$watchHistoryHash();

  @$internal
  @override
  $StreamProviderElement<List<WatchHistoryEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<WatchHistoryEntry>> create(Ref ref) {
    return watchHistory(ref);
  }
}

String _$watchHistoryHash() => r'89a1ac1ef4f7588403a85445b35c10c0f118955c';

/// The subset that belongs in Continue Watching: started, and not finished.
///
/// Derived here rather than in the home feed so the rule lives in one place
/// and both screens agree on what "resumable" means.

@ProviderFor(resumableHistory)
final resumableHistoryProvider = ResumableHistoryProvider._();

/// The subset that belongs in Continue Watching: started, and not finished.
///
/// Derived here rather than in the home feed so the rule lives in one place
/// and both screens agree on what "resumable" means.

final class ResumableHistoryProvider
    extends
        $FunctionalProvider<
          List<WatchHistoryEntry>,
          List<WatchHistoryEntry>,
          List<WatchHistoryEntry>
        >
    with $Provider<List<WatchHistoryEntry>> {
  /// The subset that belongs in Continue Watching: started, and not finished.
  ///
  /// Derived here rather than in the home feed so the rule lives in one place
  /// and both screens agree on what "resumable" means.
  ResumableHistoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'resumableHistoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$resumableHistoryHash();

  @$internal
  @override
  $ProviderElement<List<WatchHistoryEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<WatchHistoryEntry> create(Ref ref) {
    return resumableHistory(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<WatchHistoryEntry> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<WatchHistoryEntry>>(value),
    );
  }
}

String _$resumableHistoryHash() => r'9765972d6c673a70f9b5beef6baff6f395d9eba6';

/// Removes entries from history.

@ProviderFor(HistoryController)
final historyControllerProvider = HistoryControllerProvider._();

/// Removes entries from history.
final class HistoryControllerProvider
    extends $NotifierProvider<HistoryController, void> {
  /// Removes entries from history.
  HistoryControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'historyControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$historyControllerHash();

  @$internal
  @override
  HistoryController create() => HistoryController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$historyControllerHash() => r'f435f6870119b65820354d7e23cc588c6be38c64';

/// Removes entries from history.

abstract class _$HistoryController extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
