import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streambox/core/error/app_exception.dart';
import 'package:streambox/core/network/dio_exception_mapper.dart';

void main() {
  const mapper = DioExceptionMapper();
  final requestOptions = RequestOptions(path: '/content');

  DioException exception(
    DioExceptionType type, {
    int? statusCode,
    Object? error,
  }) => DioException(
    requestOptions: requestOptions,
    type: type,
    error: error,
    response: statusCode == null
        ? null
        : Response<dynamic>(
            requestOptions: requestOptions,
            statusCode: statusCode,
          ),
  );

  group('DioExceptionMapper', () {
    test('maps every timeout variant to RequestTimeoutException', () {
      const timeouts = [
        DioExceptionType.connectionTimeout,
        DioExceptionType.sendTimeout,
        DioExceptionType.receiveTimeout,
        DioExceptionType.transformTimeout,
      ];

      for (final type in timeouts) {
        expect(
          mapper.map(exception(type)),
          isA<RequestTimeoutException>(),
          reason: '$type should map to a timeout',
        );
      }
    });

    test('maps connection and certificate errors to NetworkException', () {
      expect(
        mapper.map(exception(DioExceptionType.connectionError)),
        isA<NetworkException>(),
      );
      expect(
        mapper.map(exception(DioExceptionType.badCertificate)),
        isA<NetworkException>(),
      );
    });

    test('maps cancellation to RequestCancelledException', () {
      expect(
        mapper.map(exception(DioExceptionType.cancel)),
        isA<RequestCancelledException>(),
      );
    });

    test('maps 401 and 403 to UnauthorizedException', () {
      for (final statusCode in [401, 403]) {
        expect(
          mapper.map(
            exception(DioExceptionType.badResponse, statusCode: statusCode),
          ),
          isA<UnauthorizedException>(),
          reason: '$statusCode should map to unauthorized',
        );
      }
    });

    test('maps 404 to NotFoundException', () {
      expect(
        mapper.map(exception(DioExceptionType.badResponse, statusCode: 404)),
        isA<NotFoundException>(),
      );
    });

    test('maps 408 to RequestTimeoutException', () {
      expect(
        mapper.map(exception(DioExceptionType.badResponse, statusCode: 408)),
        isA<RequestTimeoutException>(),
      );
    });

    test('retains the status code on ServerException', () {
      final result = mapper.map(
        exception(DioExceptionType.badResponse, statusCode: 503),
      );

      expect(result, isA<ServerException>());
      expect((result as ServerException).statusCode, 503);
    });

    test('unwraps an AppException carried inside an unknown DioException', () {
      const original = CacheException();

      expect(
        mapper.map(exception(DioExceptionType.unknown, error: original)),
        same(original),
      );
    });

    test('classifies decoding failures as ParsingException', () {
      expect(
        mapper.map(
          exception(
            DioExceptionType.unknown,
            error: const FormatException('bad json'),
          ),
        ),
        isA<ParsingException>(),
      );
    });

    test('falls back to UnknownException', () {
      expect(
        mapper.map(exception(DioExceptionType.unknown)),
        isA<UnknownException>(),
      );
    });

    test('always preserves the originating error for logging', () {
      final result = mapper.map(exception(DioExceptionType.connectionError));

      expect(result.cause, isA<DioException>());
    });
  });
}
