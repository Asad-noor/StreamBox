import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streambox/app/app.dart';
import 'package:streambox/app/theme/app_theme.dart';
import 'package:streambox/core/config/app_config_provider.dart';
import 'package:streambox/core/logging/app_logger.dart';
import 'package:streambox/core/logging/app_logger_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Providers are created here rather than inside `ProviderScope` so that the
  // logger is available to the error handlers installed below.
  final container = ProviderContainer();
  final logger = container.read(appLoggerProvider);

  _installErrorHandlers(logger);

  await _applySystemChrome();

  logger.info(
    'StreamBox starting (${container.read(appConfigProvider).flavor.name})',
  );

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const StreamBoxApp(),
    ),
  );
}

/// Routes both Flutter framework errors and errors escaping the Dart zone into
/// the application logger, so nothing fails silently in a release build.
void _installErrorHandlers(AppLogger logger) {
  FlutterError.onError = (details) {
    logger.error(
      details.exceptionAsString(),
      name: 'StreamBox.Flutter',
      error: details.exception,
      stackTrace: details.stack,
    );
  };

  PlatformDispatcher.instance.onError = (Object error, StackTrace stackTrace) {
    logger.error(
      'Uncaught platform error',
      name: 'StreamBox.Platform',
      error: error,
      stackTrace: stackTrace,
    );
    return true;
  };
}

/// Portrait-only outside the player; the player opts into landscape itself.
Future<void> _applySystemChrome() async {
  SystemChrome.setSystemUIOverlayStyle(AppTheme.systemOverlayStyle);

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}
