// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'details_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getContentDetailsUseCase)
final getContentDetailsUseCaseProvider = GetContentDetailsUseCaseProvider._();

final class GetContentDetailsUseCaseProvider
    extends
        $FunctionalProvider<
          GetContentDetailsUseCase,
          GetContentDetailsUseCase,
          GetContentDetailsUseCase
        >
    with $Provider<GetContentDetailsUseCase> {
  GetContentDetailsUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getContentDetailsUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getContentDetailsUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetContentDetailsUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetContentDetailsUseCase create(Ref ref) {
    return getContentDetailsUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetContentDetailsUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetContentDetailsUseCase>(value),
    );
  }
}

String _$getContentDetailsUseCaseHash() =>
    r'988d39c30f505d0d542d651981fa639ed9b0ac0b';

/// The details payload for one title.
///
/// Keyed by identifier, so two details screens on the navigation stack hold
/// their own state and neither invalidates the other. Auto-disposed: leaving
/// the screen releases the record rather than accumulating every title the
/// viewer has ever opened.

@ProviderFor(ContentDetailsNotifier)
final contentDetailsProvider = ContentDetailsNotifierFamily._();

/// The details payload for one title.
///
/// Keyed by identifier, so two details screens on the navigation stack hold
/// their own state and neither invalidates the other. Auto-disposed: leaving
/// the screen releases the record rather than accumulating every title the
/// viewer has ever opened.
final class ContentDetailsNotifierProvider
    extends $AsyncNotifierProvider<ContentDetailsNotifier, ContentDetails> {
  /// The details payload for one title.
  ///
  /// Keyed by identifier, so two details screens on the navigation stack hold
  /// their own state and neither invalidates the other. Auto-disposed: leaving
  /// the screen releases the record rather than accumulating every title the
  /// viewer has ever opened.
  ContentDetailsNotifierProvider._({
    required ContentDetailsNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'contentDetailsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$contentDetailsNotifierHash();

  @override
  String toString() {
    return r'contentDetailsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ContentDetailsNotifier create() => ContentDetailsNotifier();

  @override
  bool operator ==(Object other) {
    return other is ContentDetailsNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$contentDetailsNotifierHash() =>
    r'04183b72e1ee953c49d76d70eddfd54aafab041a';

/// The details payload for one title.
///
/// Keyed by identifier, so two details screens on the navigation stack hold
/// their own state and neither invalidates the other. Auto-disposed: leaving
/// the screen releases the record rather than accumulating every title the
/// viewer has ever opened.

final class ContentDetailsNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          ContentDetailsNotifier,
          AsyncValue<ContentDetails>,
          ContentDetails,
          FutureOr<ContentDetails>,
          String
        > {
  ContentDetailsNotifierFamily._()
    : super(
        retry: null,
        name: r'contentDetailsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The details payload for one title.
  ///
  /// Keyed by identifier, so two details screens on the navigation stack hold
  /// their own state and neither invalidates the other. Auto-disposed: leaving
  /// the screen releases the record rather than accumulating every title the
  /// viewer has ever opened.

  ContentDetailsNotifierProvider call(String contentId) =>
      ContentDetailsNotifierProvider._(argument: contentId, from: this);

  @override
  String toString() => r'contentDetailsProvider';
}

/// The details payload for one title.
///
/// Keyed by identifier, so two details screens on the navigation stack hold
/// their own state and neither invalidates the other. Auto-disposed: leaving
/// the screen releases the record rather than accumulating every title the
/// viewer has ever opened.

abstract class _$ContentDetailsNotifier extends $AsyncNotifier<ContentDetails> {
  late final _$args = ref.$arg as String;
  String get contentId => _$args;

  FutureOr<ContentDetails> build(String contentId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ContentDetails>, ContentDetails>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ContentDetails>, ContentDetails>,
              AsyncValue<ContentDetails>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

/// Which season the viewer is looking at.
///
/// Held outside [ContentDetailsNotifier] because it is view state, not data:
/// changing it must not invalidate the loaded record or trigger a refetch.

@ProviderFor(SelectedSeason)
final selectedSeasonProvider = SelectedSeasonFamily._();

/// Which season the viewer is looking at.
///
/// Held outside [ContentDetailsNotifier] because it is view state, not data:
/// changing it must not invalidate the loaded record or trigger a refetch.
final class SelectedSeasonProvider
    extends $NotifierProvider<SelectedSeason, int> {
  /// Which season the viewer is looking at.
  ///
  /// Held outside [ContentDetailsNotifier] because it is view state, not data:
  /// changing it must not invalidate the loaded record or trigger a refetch.
  SelectedSeasonProvider._({
    required SelectedSeasonFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'selectedSeasonProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$selectedSeasonHash();

  @override
  String toString() {
    return r'selectedSeasonProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SelectedSeason create() => SelectedSeason();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SelectedSeasonProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$selectedSeasonHash() => r'92feb97a4cf91d939ca1a01cbb2e3d75d162d194';

/// Which season the viewer is looking at.
///
/// Held outside [ContentDetailsNotifier] because it is view state, not data:
/// changing it must not invalidate the loaded record or trigger a refetch.

final class SelectedSeasonFamily extends $Family
    with $ClassFamilyOverride<SelectedSeason, int, int, int, String> {
  SelectedSeasonFamily._()
    : super(
        retry: null,
        name: r'selectedSeasonProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Which season the viewer is looking at.
  ///
  /// Held outside [ContentDetailsNotifier] because it is view state, not data:
  /// changing it must not invalidate the loaded record or trigger a refetch.

  SelectedSeasonProvider call(String contentId) =>
      SelectedSeasonProvider._(argument: contentId, from: this);

  @override
  String toString() => r'selectedSeasonProvider';
}

/// Which season the viewer is looking at.
///
/// Held outside [ContentDetailsNotifier] because it is view state, not data:
/// changing it must not invalidate the loaded record or trigger a refetch.

abstract class _$SelectedSeason extends $Notifier<int> {
  late final _$args = ref.$arg as String;
  String get contentId => _$args;

  int build(String contentId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
