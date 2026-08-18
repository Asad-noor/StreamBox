import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:streambox/app/router/routes.dart';
import 'package:streambox/core/config/app_config_provider.dart';
import 'package:streambox/core/logging/app_logger_provider.dart';
import 'package:streambox/core/widgets/placeholder_page.dart';

part 'app_router.g.dart';

/// The application's [GoRouter], exposed as a provider so screens and tests
/// resolve it the same way as any other dependency.
///
/// Kept alive for the lifetime of the app: rebuilding the router would reset
/// every navigation stack.
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final logger = ref.watch(appLoggerProvider);
  final config = ref.watch(appConfigProvider);

  final router = GoRouter(
    routes: $appRoutes,
    initialLocation: HomeRoute.path,
    debugLogDiagnostics: config.isVerboseLoggingEnabled,
    errorBuilder: (context, state) {
      logger.warning(
        'Unresolved route: ${state.uri}',
        name: 'StreamBox.Router',
        error: state.error,
      );

      return const PlaceholderPage(
        title: 'Not found',
        subtitle: 'That page does not exist.',
      );
    },
  );

  ref.onDispose(router.dispose);

  return router;
}
