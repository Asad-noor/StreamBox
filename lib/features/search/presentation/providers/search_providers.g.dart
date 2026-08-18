// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(searchContentUseCase)
final searchContentUseCaseProvider = SearchContentUseCaseProvider._();

final class SearchContentUseCaseProvider
    extends
        $FunctionalProvider<
          SearchContentUseCase,
          SearchContentUseCase,
          SearchContentUseCase
        >
    with $Provider<SearchContentUseCase> {
  SearchContentUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchContentUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchContentUseCaseHash();

  @$internal
  @override
  $ProviderElement<SearchContentUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SearchContentUseCase create(Ref ref) {
    return searchContentUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SearchContentUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SearchContentUseCase>(value),
    );
  }
}

String _$searchContentUseCaseHash() =>
    r'f9291c540f464afd6b41040c4e1ba17f4affd3f5';

/// Owns the search screen's state.
///
/// Two things this class exists to get right:
///
/// * **Debounce.** Typing does not issue a request per keystroke; the query
///   settles for [_debounce] first.
/// * **Staleness.** Debounce alone is not enough. A slow response for "har"
///   can still land after a fast one for "harbour" and overwrite it, so every
///   request carries a token and only the newest one is allowed to write.

@ProviderFor(SearchNotifier)
final searchProvider = SearchNotifierProvider._();

/// Owns the search screen's state.
///
/// Two things this class exists to get right:
///
/// * **Debounce.** Typing does not issue a request per keystroke; the query
///   settles for [_debounce] first.
/// * **Staleness.** Debounce alone is not enough. A slow response for "har"
///   can still land after a fast one for "harbour" and overwrite it, so every
///   request carries a token and only the newest one is allowed to write.
final class SearchNotifierProvider
    extends $NotifierProvider<SearchNotifier, SearchState> {
  /// Owns the search screen's state.
  ///
  /// Two things this class exists to get right:
  ///
  /// * **Debounce.** Typing does not issue a request per keystroke; the query
  ///   settles for [_debounce] first.
  /// * **Staleness.** Debounce alone is not enough. A slow response for "har"
  ///   can still land after a fast one for "harbour" and overwrite it, so every
  ///   request carries a token and only the newest one is allowed to write.
  SearchNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchNotifierHash();

  @$internal
  @override
  SearchNotifier create() => SearchNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SearchState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SearchState>(value),
    );
  }
}

String _$searchNotifierHash() => r'f3f23eb38d7bba308ccab30c8f42d0288ea6e211';

/// Owns the search screen's state.
///
/// Two things this class exists to get right:
///
/// * **Debounce.** Typing does not issue a request per keystroke; the query
///   settles for [_debounce] first.
/// * **Staleness.** Debounce alone is not enough. A slow response for "har"
///   can still land after a fast one for "harbour" and overwrite it, so every
///   request carries a token and only the newest one is allowed to write.

abstract class _$SearchNotifier extends $Notifier<SearchState> {
  SearchState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SearchState, SearchState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SearchState, SearchState>,
              SearchState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
