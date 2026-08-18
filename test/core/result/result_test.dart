import 'package:flutter_test/flutter_test.dart';
import 'package:streambox/core/error/app_exception.dart';
import 'package:streambox/core/result/result.dart';

void main() {
  const error = ServerException(statusCode: 500);

  group('Result', () {
    test('exposes the value on success and nothing on failure', () {
      const success = Result<int>.success(1);
      const failure = Result<int>.failure(error);

      expect(success.isSuccess, isTrue);
      expect(success.valueOrNull, 1);
      expect(success.errorOrNull, isNull);

      expect(failure.isFailure, isTrue);
      expect(failure.valueOrNull, isNull);
      expect(failure.errorOrNull, error);
    });

    test('map transforms a success and passes a failure through', () {
      expect(
        const Result<int>.success(2).map((value) => value * 2),
        const Success<int>(4),
      );
      expect(
        const Result<int>.failure(error).map((value) => value * 2),
        const Failure<int>(error),
      );
    });

    test('flatMap chains fallible transforms', () {
      Result<String> stringify(int value) => Success('$value');

      expect(
        const Result<int>.success(7).flatMap(stringify),
        const Success<String>('7'),
      );
      expect(
        const Result<int>.failure(error).flatMap(stringify),
        const Failure<String>(error),
      );
    });

    test('fold collapses both branches', () {
      String describe(Result<int> result) => result.fold(
        onSuccess: (value) => 'value:$value',
        onFailure: (error) => 'error:${error.runtimeType}',
      );

      expect(describe(const Success(3)), 'value:3');
      expect(describe(const Failure(error)), 'error:ServerException');
    });

    test('getOrElse substitutes a fallback only on failure', () {
      expect(const Result<int>.success(1).getOrElse((_) => 99), 1);
      expect(const Result<int>.failure(error).getOrElse((_) => 99), 99);
    });
  });

  group('Result.guard', () {
    test('wraps a returned value in Success', () async {
      final result = await Result.guard(() async => 'ok');

      expect(result, const Success<String>('ok'));
    });

    test('passes an AppException through unchanged', () async {
      final result = await Result.guard<String>(() async => throw error);

      expect(result.errorOrNull, same(error));
    });

    test('wraps an unclassified error so nothing raw escapes', () async {
      final result = await Result.guard<String>(
        () async => throw StateError('boom'),
      );

      final failure = result.errorOrNull;
      expect(failure, isA<UnknownException>());
      expect(failure?.cause, isA<StateError>());
      expect(failure?.stackTrace, isNotNull);
    });
  });
}
