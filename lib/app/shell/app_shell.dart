import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Persistent chrome around the four primary destinations.
///
/// [StatefulNavigationShell] gives each destination its own navigation stack,
/// so switching tabs preserves scroll position and any pushed routes — the
/// behaviour users expect from a streaming app.
class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  static const List<_Destination> _destinations = [
    _Destination(
      label: 'Home',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
    ),
    _Destination(
      label: 'Search',
      icon: Icons.search_outlined,
      selectedIcon: Icons.search_rounded,
    ),
    _Destination(
      label: 'Favourites',
      icon: Icons.favorite_outline_rounded,
      selectedIcon: Icons.favorite_rounded,
    ),
    _Destination(
      label: 'Profile',
      icon: Icons.person_outline_rounded,
      selectedIcon: Icons.person_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: [
          for (final (index, destination) in _destinations.indexed)
            NavigationDestination(
              label: destination.label,
              tooltip: destination.label,
              icon: Icon(destination.icon),
              selectedIcon: Icon(
                destination.selectedIcon,
                color: Theme.of(context).colorScheme.primary,
              ),
              key: ValueKey('shell-destination-$index'),
            ),
        ],
      ),
    );
  }

  /// Re-selecting the active destination pops that branch back to its root,
  /// matching the platform convention for tabbed navigation.
  void _onDestinationSelected(int index) => navigationShell.goBranch(
    index,
    initialLocation: index == navigationShell.currentIndex,
  );
}

class _Destination {
  const _Destination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}
