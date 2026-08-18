// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Where catalogue data comes from.
///
/// Currently the in-memory fake. Pointing this at a Dio-backed implementation
/// is the single change required to move the whole application onto a real
/// backend — nothing above the data layer references this type.

@ProviderFor(contentRemoteDataSource)
final contentRemoteDataSourceProvider = ContentRemoteDataSourceProvider._();

/// Where catalogue data comes from.
///
/// Currently the in-memory fake. Pointing this at a Dio-backed implementation
/// is the single change required to move the whole application onto a real
/// backend — nothing above the data layer references this type.

final class ContentRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          ContentRemoteDataSource,
          ContentRemoteDataSource,
          ContentRemoteDataSource
        >
    with $Provider<ContentRemoteDataSource> {
  /// Where catalogue data comes from.
  ///
  /// Currently the in-memory fake. Pointing this at a Dio-backed implementation
  /// is the single change required to move the whole application onto a real
  /// backend — nothing above the data layer references this type.
  ContentRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contentRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contentRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<ContentRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ContentRemoteDataSource create(Ref ref) {
    return contentRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ContentRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ContentRemoteDataSource>(value),
    );
  }
}

String _$contentRemoteDataSourceHash() =>
    r'dc7f7b0c0ed6e8e9a17413206f4c4d02a8a8ad42';

/// The repository is kept alive: its in-memory feed cache is the reason
/// returning to the home tab does not re-issue a request.

@ProviderFor(contentRepository)
final contentRepositoryProvider = ContentRepositoryProvider._();

/// The repository is kept alive: its in-memory feed cache is the reason
/// returning to the home tab does not re-issue a request.

final class ContentRepositoryProvider
    extends
        $FunctionalProvider<
          ContentRepository,
          ContentRepository,
          ContentRepository
        >
    with $Provider<ContentRepository> {
  /// The repository is kept alive: its in-memory feed cache is the reason
  /// returning to the home tab does not re-issue a request.
  ContentRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contentRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contentRepositoryHash();

  @$internal
  @override
  $ProviderElement<ContentRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ContentRepository create(Ref ref) {
    return contentRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ContentRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ContentRepository>(value),
    );
  }
}

String _$contentRepositoryHash() => r'9b1b4639200ffebf86676ec0e73eba1a86dbde68';
