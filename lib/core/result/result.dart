import 'package:streambox/core/error/app_exception.dart';

/// The return type of every repository method.
///
/// Repositories never throw: they translate failures into [Failure] so that
/// callers are forced by the type system to consider the error path. Use Dart
/// pattern matching to consume it:
///
/// ```dart
/// switch (await repository.load()) {
///   case Success(:final value):
///     // ...
///   case Failure(:final error):
///     // ...
/// }
/// ```
sealed class Result<T> {
  const Result();

  /// Wraps a successful [value].
  const factory Result.success(T value) = Success<T>;

  /// Wraps a failed [error].
  const factory Result.failure(AppException error) = Failure<T>;

  /// Runs [action], converting any thrown error into a [Failure].
  ///
  /// Errors that are already an [AppException] are passed through unchanged;
  /// anything else is wrapped in an [UnknownException] so no raw error escapes.
  static Future<Result<T>> guard<T>(Future<T> Function() action) async {
    try {
      return Success<T>(await action());
    } on AppException catch (error) {
      return Failure<T>(error);
    } on Object catch (error, stackTrace) {
      return Failure<T>(UnknownException(cause: error, stackTrace: stackTrace));
    }
  }

  bool get isSuccess => this is Success<T>;

  bool get isFailure => this is Failure<T>;

  /// The value on success, or `null` on failure.
  T? get valueOrNull => switch (this) {
    Success<T>(:final value) => value,
    Failure<T>() => null,
  };

  /// The error on failure, or `null` on success.
  AppException? get errorOrNull => switch (this) {
    Success<T>() => null,
    Failure<T>(:final error) => error,
  };

  /// Collapses both branches into a single value of type [R].
  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(AppException error) onFailure,
  }) => switch (this) {
    Success<T>(:final value) => onSuccess(value),
    Failure<T>(:final error) => onFailure(error),
  };

  /// Transforms the success value, leaving a failure untouched.
  Result<R> map<R>(R Function(T value) transform) => switch (this) {
    Success<T>(:final value) => Success<R>(transform(value)),
    Failure<T>(:final error) => Failure<R>(error),
  };

  /// Like [map], but for transforms that can themselves fail.
  Result<R> flatMap<R>(Result<R> Function(T value) transform) => switch (this) {
    Success<T>(:final value) => transform(value),
    Failure<T>(:final error) => Failure<R>(error),
  };

  /// The success value, or [fallback] when this is a [Failure].
  T getOrElse(T Function(AppException error) fallback) => switch (this) {
    Success<T>(:final value) => value,
    Failure<T>(:final error) => fallback(error),
  };
}

/// A [Result] carrying a successfully produced [value].
final class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Success<T> && other.value == value;

  @override
  int get hashCode => Object.hash(runtimeType, value);

  @override
  String toString() => 'Success<$T>($value)';
}

/// A [Result] carrying the [error] that prevented a value from being produced.
final class Failure<T> extends Result<T> {
  const Failure(this.error);

  final AppException error;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Failure<T> && other.error == error;

  @override
  int get hashCode => Object.hash(runtimeType, error);

  @override
  String toString() => 'Failure<$T>($error)';
}
