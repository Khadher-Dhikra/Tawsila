import 'package:go_router/go_router.dart';
import 'package:tawsila/core/widgets/placeholder_screen.dart';
import 'scaffold_with_nav.dart';

class AppRoutes {
  static const splash = '/splash';
  static const login = '/login';
  static const register = '/register';
  static const search = '/search';
  static const results = '/results';
  static const rideDetail = '/ride/:rideId';
  static const publish = '/publish';
  static const activity = '/activity';
  static const departureCode = '/departure-code/:bookingId';
  static const profile = '/profile';
  static const report = '/report';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    // Écrans hors barre de navigation
    GoRoute(
        path: AppRoutes.splash,
        builder: (_, __) => const PlaceholderScreen('Démarrage')),
    GoRoute(
        path: AppRoutes.login,
        builder: (_, __) => const PlaceholderScreen('Connexion')),
    GoRoute(
        path: AppRoutes.register,
        builder: (_, __) => const PlaceholderScreen('Inscription')),
    GoRoute(
        path: AppRoutes.results,
        builder: (_, __) => const PlaceholderScreen('Résultats')),
    GoRoute(
      path: AppRoutes.rideDetail,
      builder: (_, state) =>
          PlaceholderScreen('Détail ${state.pathParameters['rideId']}'),
    ),
    GoRoute(
      path: AppRoutes.departureCode,
      builder: (_, state) =>
          PlaceholderScreen('Code ${state.pathParameters['bookingId']}'),
    ),
    GoRoute(
        path: AppRoutes.report,
        builder: (_, __) => const PlaceholderScreen('Signalement')),

    // Écrans avec barre de navigation (4 onglets)
    StatefulShellRoute.indexedStack(
      builder: (_, __, shell) => ScaffoldWithNav(navigationShell: shell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(
              path: AppRoutes.search,
              builder: (_, __) => const PlaceholderScreen('Explorer')),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
              path: AppRoutes.publish,
              builder: (_, __) => const PlaceholderScreen('Publier')),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
              path: AppRoutes.activity,
              builder: (_, __) => const PlaceholderScreen('Activité')),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
              path: AppRoutes.profile,
              builder: (_, __) => const PlaceholderScreen('Profil')),
        ]),
      ],
    ),
  ],
);
