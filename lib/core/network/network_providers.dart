import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:streambox/core/config/app_config_provider.dart';
import 'package:streambox/core/logging/app_logger_provider.dart';
import 'package:streambox/core/network/api_client.dart';
import 'package:streambox/core/network/logging_interceptor.dart';

part 'network_providers.g.dart';

/// The configured Dio instance. Kept private to the networking layer by
/// convention: consumers depend on [apiClientProvider] instead.
@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final config = ref.watch(appConfigProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: config.apiBaseUrl,
      connectTimeout: config.connectTimeout,
      receiveTimeout: config.receiveTimeout,
      sendTimeout: config.sendTimeout,
      responseType: ResponseType.json,
      headers: const {'Accept': 'application/json'},
    ),
  );

  if (config.isNetworkLoggingEnabled) {
    dio.interceptors.add(LoggingInterceptor(ref.watch(appLoggerProvider)));
  }

  ref.onDispose(dio.close);

  return dio;
}

@Riverpod(keepAlive: true)
ApiClient apiClient(Ref ref) => ApiClient(dio: ref.watch(dioProvider));
