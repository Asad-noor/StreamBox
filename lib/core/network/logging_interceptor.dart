import 'package:dio/dio.dart';
import 'package:streambox/core/logging/app_logger.dart';

/// Logs request and response metadata for non-production builds.
///
/// Deliberately logs only method, URI, status and duration. Headers and bodies
/// are omitted because they routinely carry tokens and personal data, and a log
/// line is the easiest way to leak both.
final class LoggingInterceptor extends Interceptor {
  LoggingInterceptor(this._logger);

  final AppLogger _logger;

  static const String _name = 'StreamBox.Network';
  static const String _startedAtKey = 'startedAt';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra[_startedAtKey] = DateTime.now();
    _logger.debug('--> ${options.method} ${options.uri}', name: _name);
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _logger.debug(
      '<-- ${response.statusCode} ${response.requestOptions.uri}'
      '${_elapsedSuffix(response.requestOptions)}',
      name: _name,
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.warning(
      '<-- ${err.type.name} ${err.requestOptions.uri}'
      '${_elapsedSuffix(err.requestOptions)}',
      name: _name,
      error: err.message,
    );
    handler.next(err);
  }

  String _elapsedSuffix(RequestOptions options) {
    final startedAt = options.extra[_startedAtKey];
    if (startedAt is! DateTime) return '';

    return ' (${DateTime.now().difference(startedAt).inMilliseconds}ms)';
  }
}
