import 'package:flutter_test/flutter_test.dart';
import 'package:streambox/core/logging/app_logger.dart';

void main() {
  group('LogLevel', () {
    test('is ordered by severity', () {
      final values = LogLevel.values.map((level) => level.value).toList();

      expect(values, orderedEquals([...values]..sort()));
    });

    test('maps onto the dart:developer scale', () {
      expect(LogLevel.debug.value, 500);
      expect(LogLevel.info.value, 800);
      expect(LogLevel.warning.value, 900);
      expect(LogLevel.error.value, 1000);
    });
  });

  group('DeveloperAppLogger', () {
    late List<({String message, int level, Object? error})> written;

    DeveloperAppLogger loggerAt(LogLevel minimum) => DeveloperAppLogger(
      minimumLevel: minimum,
      sink:
          (
            message, {
            String name = '',
            int level = 0,
            Object? error,
            StackTrace? stackTrace,
          }) => written.add((message: message, level: level, error: error)),
    );

    setUp(() => written = []);

    test('records its minimum level', () {
      expect(const DeveloperAppLogger().minimumLevel, LogLevel.debug);
      expect(
        const DeveloperAppLogger(minimumLevel: LogLevel.warning).minimumLevel,
        LogLevel.warning,
      );
    });

    test('writes every severity at the lowest threshold', () {
      loggerAt(LogLevel.debug)
        ..debug('d')
        ..info('i')
        ..warning('w')
        ..error('e');

      expect(written.map((entry) => entry.level), [
        LogLevel.debug.value,
        LogLevel.info.value,
        LogLevel.warning.value,
        LogLevel.error.value,
      ]);
    });

    test('drops everything below its threshold', () {
      loggerAt(LogLevel.warning)
        ..debug('dropped')
        ..info('dropped')
        ..warning('kept')
        ..error('kept');

      expect(written.map((entry) => entry.message), ['kept', 'kept']);
    });

    test('an error threshold admits only errors', () {
      loggerAt(LogLevel.error)
        ..debug('x')
        ..info('x')
        ..warning('x')
        ..error('kept');

      expect(written, hasLength(1));
      expect(written.single.level, LogLevel.error.value);
    });

    test('passes the cause through for diagnosis', () {
      loggerAt(LogLevel.debug).error('failed', error: 'the cause');

      expect(written.single.error, 'the cause');
    });
  });

  group('SilentAppLogger', () {
    test('discards every severity', () {
      const logger = SilentAppLogger();

      expect(() => logger.debug('d'), returnsNormally);
      expect(() => logger.info('i'), returnsNormally);
      expect(() => logger.warning('w'), returnsNormally);
      expect(
        () => logger.error('e', error: 'cause', stackTrace: StackTrace.empty),
        returnsNormally,
      );
    });
  });
}
