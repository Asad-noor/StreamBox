import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streambox/app/router/routes.dart';
import 'package:streambox/app/theme/app_spacing.dart';
import 'package:streambox/core/config/app_config.dart';
import 'package:streambox/core/config/app_config_provider.dart';

/// Profile and settings.
///
/// Deliberately small: it exists to make watch history reachable and to show
/// which build is running. There is no account system in this application, so
/// there is nothing here to invent.
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.history_rounded),
            title: const Text('Watch history'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => const HistoryRoute().push<void>(context),
          ),
          ListTile(
            leading: const Icon(Icons.favorite_outline_rounded),
            title: const Text('My list'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => const FavoritesRoute().go(context),
          ),
          const Divider(),
          if (config.flavor != Flavor.production)
            ListTile(
              leading: const Icon(Icons.palette_outlined),
              title: const Text('Design system'),
              subtitle: const Text('Development builds only'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => const DesignGalleryRoute().push<void>(context),
            ),
          const Padding(
            padding: EdgeInsets.all(AppSpacing.pageGutter),
            child: _BuildInfo(),
          ),
        ],
      ),
    );
  }
}

class _BuildInfo extends ConsumerWidget {
  const _BuildInfo();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigProvider);

    return Text(
      'StreamBox · ${config.flavor.name}',
      style: Theme.of(context).textTheme.labelSmall,
    );
  }
}
