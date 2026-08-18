import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streambox/core/error/app_exception.dart';
import 'package:streambox/core/widgets/states/app_error_view.dart';

/// Renders one [AsyncValue] across all four of its states.
///
/// Every asynchronous screen routes through this so loading, error, empty and
/// success behave identically application-wide, and no feature has to remember
/// to handle the error branch.
///
/// [skeleton] takes a widget rather than a builder so callers pass a skeleton
/// shaped like their real content, which is what prevents layout shift when
/// data arrives.
class AsyncValueView<T> extends StatelessWidget {
  const AsyncValueView({
    required this.value,
    required this.data,
    this.skeleton,
    this.onRetry,
    this.isEmpty,
    this.empty,
    super.key,
  });

  final AsyncValue<T> value;
  final Widget Function(T value) data;

  /// Shown while loading. Falls back to a centred spinner.
  final Widget? skeleton;

  final VoidCallback? onRetry;

  /// Lets a caller declare what "no results" means for its own payload.
  final bool Function(T value)? isEmpty;

  /// Required for [isEmpty] to have any effect.
  final Widget? empty;

  @override
  Widget build(BuildContext context) {
    return value.when(
      skipLoadingOnRefresh: false,
      // Keep showing the previous content while a refresh is in flight rather
      // than flashing a skeleton over data the user is already reading.
      skipLoadingOnReload: true,
      data: _buildData,
      error: (error, stackTrace) => AppErrorView(
        error: error is AppException
            ? error
            : UnknownException(cause: error, stackTrace: stackTrace),
        onRetry: onRetry,
      ),
      loading: () =>
          skeleton ?? const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildData(T value) {
    if (empty case final empty? when isEmpty?.call(value) ?? false) {
      return empty;
    }

    return data(value);
  }
}
