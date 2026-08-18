import 'package:dio/dio.dart';
import 'package:streambox/core/error/app_exception.dart';

/// Translates Dio's transport-level failures into the application's
/// [AppException] vocabulary.
///
/// This is the only place in the codebase allowed to know about
/// [DioException]; everything above the networking layer deals in
/// [AppException] alone.
final class DioExceptionMapper {
  const DioExceptionMapper();

  AppException map(DioException exception) {
    final stackTrace = exception.stackTrace;

    return switch (exception.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.transformTimeout => RequestTimeoutException(
        cause: exception,
        stackTrace: stackTrace,
      ),
      DioExceptionType.connectionError => NetworkException(
        cause: exception,
        stackTrace: stackTrace,
      ),
      DioExceptionType.cancel => RequestCancelledException(
        cause: exception,
        stackTrace: stackTrace,
      ),
      DioExceptionType.badCertificate => NetworkException(
        message: 'Could not establish a secure connection.',
        cause: exception,
        stackTrace: stackTrace,
      ),
      DioExceptionType.badResponse => _mapStatusCode(
        exception,
        stackTrace: stackTrace,
      ),
      DioExceptionType.unknown => _mapUnknown(
        exception,
        stackTrace: stackTrace,
      ),
    };
  }

  AppException _mapStatusCode(
    DioException exception, {
    StackTrace? stackTrace,
  }) {
    final statusCode = exception.response?.statusCode;

    return switch (statusCode) {
      401 ||
      403 => UnauthorizedException(cause: exception, stackTrace: stackTrace),
      404 => NotFoundException(cause: exception, stackTrace: stackTrace),
      408 => RequestTimeoutException(cause: exception, stackTrace: stackTrace),
      _ => ServerException(
        statusCode: statusCode,
        cause: exception,
        stackTrace: stackTrace,
      ),
    };
  }

  /// `DioExceptionType.unknown` is a catch-all: Dio puts socket failures and
  /// interceptor errors here, so the wrapped error decides the classification.
  AppException _mapUnknown(DioException exception, {StackTrace? stackTrace}) {
    final cause = exception.error;

    if (cause is AppException) return cause;

    if (cause is FormatException || cause is TypeError) {
      return ParsingException(cause: cause, stackTrace: stackTrace);
    }

    return UnknownException(cause: exception, stackTrace: stackTrace);
  }
}
