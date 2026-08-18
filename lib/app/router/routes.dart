import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:streambox/app/design_gallery/design_gallery_page.dart';
import 'package:streambox/app/shell/app_shell.dart';
import 'package:streambox/features/details/presentation/pages/content_details_page.dart';
import 'package:streambox/features/favorites/presentation/pages/favorites_page.dart';
import 'package:streambox/features/history/presentation/pages/history_page.dart';
import 'package:streambox/features/home/presentation/pages/home_page.dart';
import 'package:streambox/features/player/presentation/pages/player_page.dart';
import 'package:streambox/features/profile/presentation/pages/profile_page.dart';
import 'package:streambox/features/search/presentation/pages/search_page.dart';

part 'routes.g.dart';

/// The route table, expressed as types rather than strings.
///
/// `go_router_builder` turns each class below into a generated helper, so
/// navigation reads `const ContentDetailsRoute(contentId: id).push(context)`
/// and a typo becomes a compile error instead of a blank screen.
///
/// Routes carry identifiers only — never entities. A screen resolves its own
/// data from its providers, which keeps deep links and in-app navigation on
/// exactly the same code path.

// -----------------------------------------------------------------------------
// Shell
// -----------------------------------------------------------------------------

@TypedStatefulShellRoute<AppShellRoute>(
  branches: [
    TypedStatefulShellBranch<HomeBranch>(
      routes: [TypedGoRoute<HomeRoute>(path: HomeRoute.path)],
    ),
    TypedStatefulShellBranch<SearchBranch>(
      routes: [TypedGoRoute<SearchRoute>(path: SearchRoute.path)],
    ),
    TypedStatefulShellBranch<FavoritesBranch>(
      routes: [TypedGoRoute<FavoritesRoute>(path: FavoritesRoute.path)],
    ),
    TypedStatefulShellBranch<ProfileBranch>(
      routes: [TypedGoRoute<ProfileRoute>(path: ProfileRoute.path)],
    ),
  ],
)
class AppShellRoute extends StatefulShellRouteData {
  const AppShellRoute();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) => AppShell(navigationShell: navigationShell);
}

class HomeBranch extends StatefulShellBranchData {
  const HomeBranch();
}

class SearchBranch extends StatefulShellBranchData {
  const SearchBranch();
}

class FavoritesBranch extends StatefulShellBranchData {
  const FavoritesBranch();
}

class ProfileBranch extends StatefulShellBranchData {
  const ProfileBranch();
}

// -----------------------------------------------------------------------------
// Branch roots
// -----------------------------------------------------------------------------

class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();

  static const String path = '/home';

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomePage();
}

class SearchRoute extends GoRouteData with $SearchRoute {
  const SearchRoute();

  static const String path = '/search';

  @override
  Widget build(BuildContext context, GoRouterState state) => const SearchPage();
}

class FavoritesRoute extends GoRouteData with $FavoritesRoute {
  const FavoritesRoute();

  static const String path = '/favourites';

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const FavoritesPage();
}

class ProfileRoute extends GoRouteData with $ProfileRoute {
  const ProfileRoute();

  static const String path = '/profile';

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ProfilePage();
}

// -----------------------------------------------------------------------------
// Full-screen routes
//
// Declared outside the shell so they cover the bottom navigation bar.
// -----------------------------------------------------------------------------

@TypedGoRoute<ContentDetailsRoute>(path: ContentDetailsRoute.path)
class ContentDetailsRoute extends GoRouteData with $ContentDetailsRoute {
  const ContentDetailsRoute({required this.contentId});

  static const String path = '/content/:contentId';

  final String contentId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ContentDetailsPage(contentId: contentId);
}

@TypedGoRoute<PlayerRoute>(path: PlayerRoute.path)
class PlayerRoute extends GoRouteData with $PlayerRoute {
  const PlayerRoute({required this.contentId});

  static const String path = '/watch/:contentId';

  final String contentId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      PlayerPage(contentId: contentId);
}

@TypedGoRoute<HistoryRoute>(path: HistoryRoute.path)
class HistoryRoute extends GoRouteData with $HistoryRoute {
  const HistoryRoute();

  static const String path = '/history';

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const HistoryPage();
}

// -----------------------------------------------------------------------------
// Development tools
//
// Registered unconditionally because the generated route table is static;
// `appRouter` redirects away from this prefix outside development builds.
// -----------------------------------------------------------------------------

@TypedGoRoute<DesignGalleryRoute>(path: DesignGalleryRoute.path)
class DesignGalleryRoute extends GoRouteData with $DesignGalleryRoute {
  const DesignGalleryRoute();

  /// Everything under this prefix is development-only.
  static const String devPrefix = '/dev';

  static const String path = '$devPrefix/gallery';

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const DesignGalleryPage();
}
