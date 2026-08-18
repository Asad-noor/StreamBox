// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The application's [GoRouter], exposed as a provider so screens and tests
/// resolve it the same way as any other dependency.
///
/// Kept alive for the lifetime of the app: rebuilding the router would reset
/// every navigation stack.

@ProviderFor(appRouter)
final appRouterProvider = AppRouterProvider._();

/// The application's [GoRouter], exposed as a provider so screens and tests
/// resolve it the same way as any other dependency.
///
/// Kept alive for the lifetime of the app: rebuilding the router would reset
/// every navigation stack.

final class AppRouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  /// The application's [GoRouter], exposed as a provider so screens and tests
  /// resolve it the same way as any other dependency.
  ///
  /// Kept alive for the lifetime of the app: rebuilding the router would reset
  /// every navigation stack.
  AppRouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appRouterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appRouterHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return appRouter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }
}

String _$appRouterHash() => r'12bd7fe69c3e5fd2ba2105b27ffd9e40b1a24c9c';
