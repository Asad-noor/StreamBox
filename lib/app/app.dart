import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streambox/app/router/app_router.dart';
import 'package:streambox/app/theme/app_theme.dart';

/// The root widget: theme, routing, and nothing else.
///
/// Bootstrapping lives in `main.dart` and features own their own state, so this
/// stays small enough to read at a glance.
class StreamBoxApp extends ConsumerWidget {
  const StreamBoxApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'StreamBox',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      routerConfig: ref.watch(appRouterProvider),
      builder: _clampTextScale,
    );
  }

  /// Honours the user's text-size preference while capping it at the point
  /// where the densest layouts (metadata rows, card titles) would break.
  static Widget _clampTextScale(BuildContext context, Widget? child) {
    final mediaQuery = MediaQuery.of(context);

    return MediaQuery(
      data: mediaQuery.copyWith(
        textScaler: mediaQuery.textScaler.clamp(
          minScaleFactor: 0.8,
          maxScaleFactor: 1.4,
        ),
      ),
      child: child ?? const SizedBox.shrink(),
    );
  }
}
