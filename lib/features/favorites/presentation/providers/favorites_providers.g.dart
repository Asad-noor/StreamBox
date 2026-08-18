// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorites_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(favoritesRepository)
final favoritesRepositoryProvider = FavoritesRepositoryProvider._();

final class FavoritesRepositoryProvider
    extends
        $FunctionalProvider<
          FavoritesRepository,
          FavoritesRepository,
          FavoritesRepository
        >
    with $Provider<FavoritesRepository> {
  FavoritesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoritesRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoritesRepositoryHash();

  @$internal
  @override
  $ProviderElement<FavoritesRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FavoritesRepository create(Ref ref) {
    return favoritesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FavoritesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FavoritesRepository>(value),
    );
  }
}

String _$favoritesRepositoryHash() =>
    r'5ca78189d3a159a98ca7f8a6e07d6bebdf6fb2fa';

/// The saved titles, newest first.

@ProviderFor(favorites)
final favoritesProvider = FavoritesProvider._();

/// The saved titles, newest first.

final class FavoritesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<FavoriteEntry>>,
          List<FavoriteEntry>,
          Stream<List<FavoriteEntry>>
        >
    with
        $FutureModifier<List<FavoriteEntry>>,
        $StreamProvider<List<FavoriteEntry>> {
  /// The saved titles, newest first.
  FavoritesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoritesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoritesHash();

  @$internal
  @override
  $StreamProviderElement<List<FavoriteEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<FavoriteEntry>> create(Ref ref) {
    return favorites(ref);
  }
}

String _$favoritesHash() => r'2143db5f71d5db3987b8d7fd73b89ec2a58288c0';

/// The saved identifiers, kept current by the database.
///
/// Every screen that cares about favourites watches this one provider, so a
/// title saved on the details screen appears on the favourites tab with no
/// coordination between them.

@ProviderFor(favoriteIds)
final favoriteIdsProvider = FavoriteIdsProvider._();

/// The saved identifiers, kept current by the database.
///
/// Every screen that cares about favourites watches this one provider, so a
/// title saved on the details screen appears on the favourites tab with no
/// coordination between them.

final class FavoriteIdsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Set<String>>,
          Set<String>,
          Stream<Set<String>>
        >
    with $FutureModifier<Set<String>>, $StreamProvider<Set<String>> {
  /// The saved identifiers, kept current by the database.
  ///
  /// Every screen that cares about favourites watches this one provider, so a
  /// title saved on the details screen appears on the favourites tab with no
  /// coordination between them.
  FavoriteIdsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoriteIdsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoriteIdsHash();

  @$internal
  @override
  $StreamProviderElement<Set<String>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Set<String>> create(Ref ref) {
    return favoriteIds(ref);
  }
}

String _$favoriteIdsHash() => r'3a639aeeb123e396de8f30f03c8d85a228bae636';

/// Whether one title is saved. Watching this rather than the whole set keeps a
/// button from rebuilding when an unrelated title is favourited.

@ProviderFor(isFavorite)
final isFavoriteProvider = IsFavoriteFamily._();

/// Whether one title is saved. Watching this rather than the whole set keeps a
/// button from rebuilding when an unrelated title is favourited.

final class IsFavoriteProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether one title is saved. Watching this rather than the whole set keeps a
  /// button from rebuilding when an unrelated title is favourited.
  IsFavoriteProvider._({
    required IsFavoriteFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'isFavoriteProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$isFavoriteHash();

  @override
  String toString() {
    return r'isFavoriteProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    final argument = this.argument as String;
    return isFavorite(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is IsFavoriteProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$isFavoriteHash() => r'84c186a5a819ca5207dfeb27a2d557e4b5e0a691';

/// Whether one title is saved. Watching this rather than the whole set keeps a
/// button from rebuilding when an unrelated title is favourited.

final class IsFavoriteFamily extends $Family
    with $FunctionalFamilyOverride<bool, String> {
  IsFavoriteFamily._()
    : super(
        retry: null,
        name: r'isFavoriteProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Whether one title is saved. Watching this rather than the whole set keeps a
  /// button from rebuilding when an unrelated title is favourited.

  IsFavoriteProvider call(String contentId) =>
      IsFavoriteProvider._(argument: contentId, from: this);

  @override
  String toString() => r'isFavoriteProvider';
}

/// Applies favourite changes.
///
/// The database stream is the source of truth and re-emits as soon as a write
/// commits, so the button responds without holding its own copy of the state.
/// A failed write is surfaced to the caller rather than swallowed.

@ProviderFor(FavoritesController)
final favoritesControllerProvider = FavoritesControllerProvider._();

/// Applies favourite changes.
///
/// The database stream is the source of truth and re-emits as soon as a write
/// commits, so the button responds without holding its own copy of the state.
/// A failed write is surfaced to the caller rather than swallowed.
final class FavoritesControllerProvider
    extends $NotifierProvider<FavoritesController, void> {
  /// Applies favourite changes.
  ///
  /// The database stream is the source of truth and re-emits as soon as a write
  /// commits, so the button responds without holding its own copy of the state.
  /// A failed write is surfaced to the caller rather than swallowed.
  FavoritesControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoritesControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoritesControllerHash();

  @$internal
  @override
  FavoritesController create() => FavoritesController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$favoritesControllerHash() =>
    r'10f7c1be0ac2b5f5c196b2675ceffa64bbb3e8df';

/// Applies favourite changes.
///
/// The database stream is the source of truth and re-emits as soon as a write
/// commits, so the button responds without holding its own copy of the state.
/// A failed write is surfaced to the caller rather than swallowed.

abstract class _$FavoritesController extends $Notifier<void> {
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
