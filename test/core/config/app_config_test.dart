import 'package:flutter_test/flutter_test.dart';
import 'package:streambox/core/config/app_config.dart';

AppConfig _configFor(Flavor flavor) => AppConfig(
  flavor: flavor,
  apiBaseUrl: AppConfig.defaultBaseUrlFor(flavor),
  connectTimeout: Duration.zero,
  receiveTimeout: Duration.zero,
  sendTimeout: Duration.zero,
);

void main() {
  group('Flavor.fromName', () {
    test('recognises every deployment target', () {
      expect(Flavor.fromName('development'), Flavor.development);
      expect(Flavor.fromName('staging'), Flavor.staging);
      expect(Flavor.fromName('production'), Flavor.production);
      expect(Flavor.fromName('prod'), Flavor.production);
    });

    test('is case insensitive', () {
      expect(Flavor.fromName('STAGING'), Flavor.staging);
      expect(Flavor.fromName('Production'), Flavor.production);
    });

    test('falls back to development for anything unrecognised', () {
      expect(Flavor.fromName(''), Flavor.development);
      expect(Flavor.fromName('qa'), Flavor.development);
    });
  });

  group('AppConfig', () {
    test('defaults to development when no dart-define is supplied', () {
      final config = AppConfig.resolve();

      expect(config.flavor, Flavor.development);
      expect(
        config.apiBaseUrl,
        AppConfig.defaultBaseUrlFor(Flavor.development),
      );
    });

    test('applies a non-zero timeout to every phase of a request', () {
      final config = AppConfig.resolve();

      expect(config.connectTimeout, greaterThan(Duration.zero));
      expect(config.receiveTimeout, greaterThan(Duration.zero));
      expect(config.sendTimeout, greaterThan(Duration.zero));
    });

    test('gates network logging on everything but production', () {
      expect(_configFor(Flavor.development).isNetworkLoggingEnabled, isTrue);
      expect(_configFor(Flavor.staging).isNetworkLoggingEnabled, isTrue);
      expect(_configFor(Flavor.production).isNetworkLoggingEnabled, isFalse);
    });

    test('limits verbose logging to development', () {
      expect(_configFor(Flavor.development).isVerboseLoggingEnabled, isTrue);
      expect(_configFor(Flavor.staging).isVerboseLoggingEnabled, isFalse);
      expect(_configFor(Flavor.production).isVerboseLoggingEnabled, isFalse);
    });
  });

  group('AppConfig.defaultBaseUrlFor', () {
    test('gives every flavor its own host', () {
      final urls = Flavor.values.map(AppConfig.defaultBaseUrlFor).toSet();

      expect(urls, hasLength(Flavor.values.length));
    });

    test('never resolves to an empty or insecure URL', () {
      for (final flavor in Flavor.values) {
        final url = AppConfig.defaultBaseUrlFor(flavor);

        expect(url, isNotEmpty, reason: '$flavor');
        expect(url, startsWith('https://'), reason: '$flavor');
      }
    });
  });
}
