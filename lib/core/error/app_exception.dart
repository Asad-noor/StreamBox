/// The single error currency of the application.
///
/// Every layer below the presentation layer converts its own failure modes
/// (Dio errors, platform errors, decoding errors) into an [AppException] so
/// that no infrastructure-specific exception type ever escapes the data layer.
///
/// [message] is safe to surface to the user. [cause] and [stackTrace] carry the
/// underlying technical detail and are intended for logging only.
sealed class AppException implements Exception {
  const AppException({required this.message, this.cause, this.stackTrace});

  /// User-presentable description of what went wrong.
  final String message;

  /// The underlying error, if this exception wraps one. Never shown to users.
  final Object? cause;

  /// Stack trace captured at the original failure site.
  final StackTrace? stackTrace;

  @override
  String toString() =>
      '$runtimeType(message: $message${cause == null ? '' : ', cause: $cause'})';
}

/// The device could not reach the network at all.
final class NetworkException extends AppException {
  const NetworkException({
    super.message = 'No internet connection. Check your network and try again.',
    super.cause,
    super.stackTrace,
  });
}

/// The request was issued but no response arrived in time.
final class RequestTimeoutException extends AppException {
  const RequestTimeoutException({
    super.message = 'The request took too long. Please try again.',
    super.cause,
    super.stackTrace,
  });
}

/// The server responded with a non-success status code.
final class ServerException extends AppException {
  const ServerException({
    required this.statusCode,
    super.message = 'Something went wrong on our end. Please try again.',
    super.cause,
    super.stackTrace,
  });

  final int? statusCode;

  @override
  String toString() =>
      'ServerException(statusCode: $statusCode, '
      'message: $message${cause == null ? '' : ', cause: $cause'})';
}

/// Credentials are missing, invalid, or expired.
final class UnauthorizedException extends AppException {
  const UnauthorizedException({
    super.message = 'Your session has expired. Please sign in again.',
    super.cause,
    super.stackTrace,
  });
}

/// The requested resource does not exist.
final class NotFoundException extends AppException {
  const NotFoundException({
    super.message = 'We could not find what you were looking for.',
    super.cause,
    super.stackTrace,
  });
}

/// A response arrived but did not match the expected shape.
final class ParsingException extends AppException {
  const ParsingException({
    super.message = 'We received an unexpected response. Please try again.',
    super.cause,
    super.stackTrace,
  });
}

/// A local read or write failed.
final class CacheException extends AppException {
  const CacheException({
    super.message = 'Could not access locally stored data.',
    super.cause,
    super.stackTrace,
  });
}

/// The caller cancelled the operation. Usually not worth surfacing to the user.
final class RequestCancelledException extends AppException {
  const RequestCancelledException({
    super.message = 'The request was cancelled.',
    super.cause,
    super.stackTrace,
  });
}

/// Video playback failed: the stream could not be opened, decoded, or kept
/// running. Separate from [NetworkException] because the recovery the user is
/// offered differs — retrying a stream is worth doing even when online.
final class PlaybackException extends AppException {
  const PlaybackException({
    super.message = 'This title could not be played. Please try again.',
    super.cause,
    super.stackTrace,
  });
}

/// The title exists but has no stream attached — announced but not yet
/// available. Distinct from [PlaybackException] because retrying cannot help.
final class PlaybackUnavailableException extends AppException {
  const PlaybackUnavailableException({
    super.message = 'This title is not available to stream yet.',
    super.cause,
    super.stackTrace,
  });
}

/// Fallback for anything that could not be classified.
final class UnknownException extends AppException {
  const UnknownException({
    super.message = 'Something went wrong. Please try again.',
    super.cause,
    super.stackTrace,
  });
}
