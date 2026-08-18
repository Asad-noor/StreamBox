import 'package:dio/dio.dart';
import 'package:streambox/core/error/app_exception.dart';
import 'package:streambox/core/network/dio_exception_mapper.dart';

/// Signature for turning a decoded response body into a domain-facing type.
typedef ResponseParser<T> = T Function(Object? data);

/// The application's single HTTP entry point.
///
/// Wraps Dio so that no other file needs to import it. Callers supply a
/// [ResponseParser]; parsing failures are caught here and reported as
/// [ParsingException] rather than escaping as raw `TypeError`s.
///
/// Methods throw [AppException] on failure. Repositories are responsible for
/// converting those throws into `Result` via `Result.guard`, which keeps this
/// class composable for data sources that issue several calls in sequence.
final class ApiClient {
  const ApiClient({
    required Dio dio,
    this.exceptionMapper = const DioExceptionMapper(),
    // The lint's suggested fix (`this._dio`) is illegal: named parameters
    // cannot be private. Dio stays private so it cannot leak past this class.
    // ignore: prefer_initializing_formals
  }) : _dio = dio;

  final Dio _dio;

  /// Injectable so tests can assert on error translation without a live Dio.
  final DioExceptionMapper exceptionMapper;

  Future<T> get<T>(
    String path, {
    required ResponseParser<T> parse,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) => _send(
    parse: parse,
    request: () => _dio.get<dynamic>(
      path,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
    ),
  );

  Future<T> post<T>(
    String path, {
    required ResponseParser<T> parse,
    Object? body,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) => _send(
    parse: parse,
    request: () => _dio.post<dynamic>(
      path,
      data: body,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
    ),
  );

  Future<T> delete<T>(
    String path, {
    required ResponseParser<T> parse,
    Object? body,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) => _send(
    parse: parse,
    request: () => _dio.delete<dynamic>(
      path,
      data: body,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
    ),
  );

  Future<T> _send<T>({
    required Future<Response<dynamic>> Function() request,
    required ResponseParser<T> parse,
  }) async {
    final Response<dynamic> response;
    try {
      response = await request();
    } on DioException catch (exception) {
      throw exceptionMapper.map(exception);
    }

    try {
      return parse(response.data);
    } on Object catch (error, stackTrace) {
      throw ParsingException(cause: error, stackTrace: stackTrace);
    }
  }
}
