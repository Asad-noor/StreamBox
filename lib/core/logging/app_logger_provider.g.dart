// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_logger_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Log verbosity follows the flavor: development logs everything, staging drops
/// debug noise, production emits nothing from this logger at all.

@ProviderFor(appLogger)
final appLoggerProvider = AppLoggerProvider._();

/// Log verbosity follows the flavor: development logs everything, staging drops
/// debug noise, production emits nothing from this logger at all.

final class AppLoggerProvider
    extends $FunctionalProvider<AppLogger, AppLogger, AppLogger>
    with $Provider<AppLogger> {
  /// Log verbosity follows the flavor: development logs everything, staging drops
  /// debug noise, production emits nothing from this logger at all.
  AppLoggerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appLoggerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appLoggerHash();

  @$internal
  @override
  $ProviderElement<AppLogger> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppLogger create(Ref ref) {
    return appLogger(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppLogger value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppLogger>(value),
    );
  }
}

String _$appLoggerHash() => r'378e690650c44a5344896e854859ab1ce999326e';
