import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:streambox/core/config/app_config.dart';
import 'package:streambox/core/config/app_config_provider.dart';
import 'package:streambox/core/logging/app_logger.dart';

part 'app_logger_provider.g.dart';

/// Log verbosity follows the flavor: development logs everything, staging drops
/// debug noise, production emits nothing from this logger at all.
@Riverpod(keepAlive: true)
AppLogger appLogger(Ref ref) {
  final config = ref.watch(appConfigProvider);

  if (config.flavor == Flavor.production) return const SilentAppLogger();

  return DeveloperAppLogger(
    minimumLevel: config.isVerboseLoggingEnabled
        ? LogLevel.debug
        : LogLevel.info,
  );
}
