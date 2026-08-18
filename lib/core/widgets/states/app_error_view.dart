import 'package:flutter/material.dart';
import 'package:streambox/app/theme/app_spacing.dart';
import 'package:streambox/core/error/app_exception.dart';

/// The single error surface for the application.
///
/// Takes the [AppException] itself rather than a pre-formatted string so that
/// the icon and the retry affordance can follow the failure kind: an expired
/// session is not something "try again" can fix, a dropped connection is.
class AppErrorView extends StatelessWidget {
  const AppErrorView({required this.error, this.onRetry, super.key});

  final AppException error;

  /// Omitted when the caller has no meaningful way to retry.
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canRetry = onRetry != null && _isRecoverable;

    return Semantics(
      liveRegion: true,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_icon, size: 48, color: theme.colorScheme.error),
              const SizedBox(height: AppSpacing.md),
              Text(
                _title,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                error.message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              if (canRetry) ...[
                const SizedBox(height: AppSpacing.xl),
                FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded, size: 20),
                  label: const Text('Try again'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Retrying an unauthorised or missing resource just reproduces the failure.
  bool get _isRecoverable => switch (error) {
    UnauthorizedException() ||
    NotFoundException() ||
    PlaybackUnavailableException() => false,
    _ => true,
  };

  IconData get _icon => switch (error) {
    NetworkException() => Icons.wifi_off_rounded,
    RequestTimeoutException() => Icons.hourglass_disabled_rounded,
    UnauthorizedException() => Icons.lock_outline_rounded,
    NotFoundException() => Icons.search_off_rounded,
    ServerException() => Icons.cloud_off_rounded,
    ParsingException() || CacheException() => Icons.broken_image_outlined,
    PlaybackException() => Icons.play_disabled_rounded,
    PlaybackUnavailableException() => Icons.schedule_rounded,
    RequestCancelledException() ||
    UnknownException() => Icons.error_outline_rounded,
  };

  String get _title => switch (error) {
    NetworkException() => 'You are offline',
    RequestTimeoutException() => 'This is taking too long',
    UnauthorizedException() => 'Session expired',
    NotFoundException() => 'Nothing here',
    ServerException() => 'Service unavailable',
    PlaybackException() => 'Cannot play this title',
    PlaybackUnavailableException() => 'Not available yet',
    _ => 'Something went wrong',
  };
}
