// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The single database connection.
///
/// Kept alive for the process: opening SQLite per screen would be wasteful and
/// would break Drift's change notifications, which are what make the
/// favourites and history screens update reactively.

@ProviderFor(appDatabase)
final appDatabaseProvider = AppDatabaseProvider._();

/// The single database connection.
///
/// Kept alive for the process: opening SQLite per screen would be wasteful and
/// would break Drift's change notifications, which are what make the
/// favourites and history screens update reactively.

final class AppDatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  /// The single database connection.
  ///
  /// Kept alive for the process: opening SQLite per screen would be wasteful and
  /// would break Drift's change notifications, which are what make the
  /// favourites and history screens update reactively.
  AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$appDatabaseHash() => r'44154e51c3f3079ee293d8ad0ebd1e17cca871ed';
