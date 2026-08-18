/// Build-time deployment target.
enum Flavor {
  development,
  staging,
  production;

  static Flavor fromName(String name) => switch (name.toLowerCase()) {
    'staging' => Flavor.staging,
    'production' || 'prod' => Flavor.production,
    _ => Flavor.development,
  };
}

/// Immutable, build-time application configuration.
///
/// Values are supplied via `--dart-define` so nothing environment-specific is
/// compiled into every build and no secrets need to live in the repository:
///
/// ```sh
/// flutter run --dart-define=FLAVOR=staging \
///             --dart-define=API_BASE_URL=https://staging.example.com
/// ```
///
/// Resolution is `const`, so the values are tree-shaken per build.
final class AppConfig {
  const AppConfig({
    required this.flavor,
    required this.apiBaseUrl,
    required this.connectTimeout,
    required this.receiveTimeout,
    required this.sendTimeout,
  });

  /// Reads the configuration for the current build.
  factory AppConfig.resolve() {
    const flavorName = String.fromEnvironment(
      _flavorKey,
      defaultValue: 'development',
    );
    const baseUrlOverride = String.fromEnvironment(_apiBaseUrlKey);

    final flavor = Flavor.fromName(flavorName);

    return AppConfig(
      flavor: flavor,
      apiBaseUrl: baseUrlOverride.isNotEmpty
          ? baseUrlOverride
          : defaultBaseUrlFor(flavor),
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 15),
    );
  }

  static const String _flavorKey = 'FLAVOR';
  static const String _apiBaseUrlKey = 'API_BASE_URL';

  /// Placeholder hosts. The catalogue is served by a local fake data source
  /// until a real backend is wired up; these exist so the networking layer is
  /// configured end-to-end from day one.
  static String defaultBaseUrlFor(Flavor flavor) => switch (flavor) {
    Flavor.development => 'https://dev.api.streambox.invalid',
    Flavor.staging => 'https://staging.api.streambox.invalid',
    Flavor.production => 'https://api.streambox.invalid',
  };

  final Flavor flavor;
  final String apiBaseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final Duration sendTimeout;

  /// Verbose request/response logging is limited to non-production builds.
  bool get isNetworkLoggingEnabled => flavor != Flavor.production;

  /// Whether diagnostic logs below the warning level are emitted.
  bool get isVerboseLoggingEnabled => flavor == Flavor.development;
}
