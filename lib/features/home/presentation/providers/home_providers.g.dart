// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getHomeFeedUseCase)
final getHomeFeedUseCaseProvider = GetHomeFeedUseCaseProvider._();

final class GetHomeFeedUseCaseProvider
    extends
        $FunctionalProvider<
          GetHomeFeedUseCase,
          GetHomeFeedUseCase,
          GetHomeFeedUseCase
        >
    with $Provider<GetHomeFeedUseCase> {
  GetHomeFeedUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getHomeFeedUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getHomeFeedUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetHomeFeedUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetHomeFeedUseCase create(Ref ref) {
    return getHomeFeedUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetHomeFeedUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetHomeFeedUseCase>(value),
    );
  }
}

String _$getHomeFeedUseCaseHash() =>
    r'26911f66eec68670c3fe40d570635e24e4327f59';

/// Owns the home screen's feed.
///
/// Exposes `AsyncValue<HomeFeed>` so the screen renders through
/// `AsyncValueView` like every other asynchronous surface. The notifier
/// converts the use case's `Result` into an error state rather than letting a
/// failure surface as an unhandled exception.

@ProviderFor(HomeFeedNotifier)
final homeFeedProvider = HomeFeedNotifierProvider._();

/// Owns the home screen's feed.
///
/// Exposes `AsyncValue<HomeFeed>` so the screen renders through
/// `AsyncValueView` like every other asynchronous surface. The notifier
/// converts the use case's `Result` into an error state rather than letting a
/// failure surface as an unhandled exception.
final class HomeFeedNotifierProvider
    extends $AsyncNotifierProvider<HomeFeedNotifier, HomeFeed> {
  /// Owns the home screen's feed.
  ///
  /// Exposes `AsyncValue<HomeFeed>` so the screen renders through
  /// `AsyncValueView` like every other asynchronous surface. The notifier
  /// converts the use case's `Result` into an error state rather than letting a
  /// failure surface as an unhandled exception.
  HomeFeedNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeFeedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeFeedNotifierHash();

  @$internal
  @override
  HomeFeedNotifier create() => HomeFeedNotifier();
}

String _$homeFeedNotifierHash() => r'8de46e4c9736d89bc1e5a397e0ec7154b74affbd';

/// Owns the home screen's feed.
///
/// Exposes `AsyncValue<HomeFeed>` so the screen renders through
/// `AsyncValueView` like every other asynchronous surface. The notifier
/// converts the use case's `Result` into an error state rather than letting a
/// failure surface as an unhandled exception.

abstract class _$HomeFeedNotifier extends $AsyncNotifier<HomeFeed> {
  FutureOr<HomeFeed> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<HomeFeed>, HomeFeed>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<HomeFeed>, HomeFeed>,
              AsyncValue<HomeFeed>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Resume position per title, keyed by identifier.
///
/// The home rails render summaries; this supplies the watched fraction each
/// card needs without every card reaching into the database itself.

@ProviderFor(resumeFractions)
final resumeFractionsProvider = ResumeFractionsProvider._();

/// Resume position per title, keyed by identifier.
///
/// The home rails render summaries; this supplies the watched fraction each
/// card needs without every card reaching into the database itself.

final class ResumeFractionsProvider
    extends
        $FunctionalProvider<
          Map<String, double>,
          Map<String, double>,
          Map<String, double>
        >
    with $Provider<Map<String, double>> {
  /// Resume position per title, keyed by identifier.
  ///
  /// The home rails render summaries; this supplies the watched fraction each
  /// card needs without every card reaching into the database itself.
  ResumeFractionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'resumeFractionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$resumeFractionsHash();

  @$internal
  @override
  $ProviderElement<Map<String, double>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Map<String, double> create(Ref ref) {
    return resumeFractions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, double> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, double>>(value),
    );
  }
}

String _$resumeFractionsHash() => r'0857ada90c11635407c8199a3331487ee349941c';

/// The home feed with Continue Watching prepended.
///
/// Composed here rather than in the repository because the catalogue and the
/// viewer's history come from different sources — one remote, one local — and
/// joining them is a presentation concern, not something the catalogue knows
/// how to do.

@ProviderFor(homeFeedWithHistory)
final homeFeedWithHistoryProvider = HomeFeedWithHistoryProvider._();

/// The home feed with Continue Watching prepended.
///
/// Composed here rather than in the repository because the catalogue and the
/// viewer's history come from different sources — one remote, one local — and
/// joining them is a presentation concern, not something the catalogue knows
/// how to do.

final class HomeFeedWithHistoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<HomeFeed>,
          AsyncValue<HomeFeed>,
          AsyncValue<HomeFeed>
        >
    with $Provider<AsyncValue<HomeFeed>> {
  /// The home feed with Continue Watching prepended.
  ///
  /// Composed here rather than in the repository because the catalogue and the
  /// viewer's history come from different sources — one remote, one local — and
  /// joining them is a presentation concern, not something the catalogue knows
  /// how to do.
  HomeFeedWithHistoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeFeedWithHistoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeFeedWithHistoryHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<HomeFeed>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<HomeFeed> create(Ref ref) {
    return homeFeedWithHistory(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<HomeFeed> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<HomeFeed>>(value),
    );
  }
}

String _$homeFeedWithHistoryHash() =>
    r'1cb00c332572ab98eeaa6f94c2a7a6bafb51f7cb';
