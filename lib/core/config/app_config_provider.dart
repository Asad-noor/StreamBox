import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:streambox/core/config/app_config.dart';

part 'app_config_provider.g.dart';

/// Build-time configuration. Overridden in tests to exercise other flavors.
@Riverpod(keepAlive: true)
AppConfig appConfig(Ref ref) => AppConfig.resolve();
