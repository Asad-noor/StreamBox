import 'dart:developer' as developer;

/// Severity levels, ordered from least to most severe.
enum LogLevel {
  debug(500),
  info(800),
  warning(900),
  error(1000);

  const LogLevel(this.value);

  /// Maps onto the `dart:developer` level scale.
  final int value;
}

/// Application-wide logging seam.
///
/// Everything logs through this interface rather than `print`, which keeps
/// release builds quiet and makes it possible to swap in a crash-reporting
/// sink later without touching call sites.
abstract interface class AppLogger {
  void debug(String message, {String? name});

  void info(String message, {String? name});

  void warning(String message, {String? name, Object? error});

  void error(
    String message, {
    String? name,
    Object? error,
    StackTrace? stackTrace,
  });
}

/// Where a log line ends up. Matches `dart:developer`'s `log` signature.
typedef LogSink =
    void Function(
      String message, {
      String name,
      int level,
      Object? error,
      StackTrace? stackTrace,
    });

/// Writes to the Dart developer log. Intended for development and staging.
final class DeveloperAppLogger implements AppLogger {
  const DeveloperAppLogger({
    this.minimumLevel = LogLevel.debug,
    this.sink = developer.log,
  });

  /// Messages below this level are dropped.
  final LogLevel minimumLevel;

  /// Injectable so that severity filtering is observable in a test. The
  /// developer log offers no interception hook, and a filter nothing can see
  /// is a filter nothing can verify.
  final LogSink sink;

  static const String _defaultName = 'StreamBox';

  @override
  void debug(String message, {String? name}) =>
      _log(LogLevel.debug, message, name: name);

  @override
  void info(String message, {String? name}) =>
      _log(LogLevel.info, message, name: name);

  @override
  void warning(String message, {String? name, Object? error}) =>
      _log(LogLevel.warning, message, name: name, error: error);

  @override
  void error(
    String message, {
    String? name,
    Object? error,
    StackTrace? stackTrace,
  }) => _log(
    LogLevel.error,
    message,
    name: name,
    error: error,
    stackTrace: stackTrace,
  );

  void _log(
    LogLevel level,
    String message, {
    String? name,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (level.value < minimumLevel.value) return;

    sink(
      message,
      name: name ?? _defaultName,
      level: level.value,
      error: error,
      stackTrace: stackTrace,
    );
  }
}

/// Discards everything. Used in tests and anywhere logging would be noise.
final class SilentAppLogger implements AppLogger {
  const SilentAppLogger();

  @override
  void debug(String message, {String? name}) {}

  @override
  void info(String message, {String? name}) {}

  @override
  void warning(String message, {String? name, Object? error}) {}

  @override
  void error(
    String message, {
    String? name,
    Object? error,
    StackTrace? stackTrace,
  }) {}
}
