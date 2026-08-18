import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart' show Override;
import 'package:streambox/core/riverpod/retry_policy.dart';

/// The application's provider scope.
///
/// Exists so the container configuration — currently the retry policy — lives
/// in one place and travels with the app. A bare `ProviderScope` silently
/// restores Riverpod's automatic retry, which would leave failed screens
/// spinning instead of showing their error state, so nothing should construct
/// one directly.
class AppProviderScope extends StatelessWidget {
  const AppProviderScope({
    required this.child,
    this.overrides = const [],
    super.key,
  });

  final Widget child;
  final List<Override> overrides;

  @override
  Widget build(BuildContext context) => ProviderScope(
    retry: noAutomaticRetry,
    overrides: overrides,
    child: child,
  );
}

/// The same configuration as [AppProviderScope], for callers that need the
/// container before a widget tree exists — application bootstrap, and tests
/// that read providers directly.
ProviderContainer createAppProviderContainer({
  List<Override> overrides = const [],
}) => ProviderContainer(retry: noAutomaticRetry, overrides: overrides);
