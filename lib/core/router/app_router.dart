import 'package:go_router/go_router.dart';
import 'package:tawsila/core/widgets/placeholder_screen.dart';
import 'scaffold_with_nav.dart';
import 'package:tawsila/features/auth/login_screen.dart';

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
        builder: (_, _) => const PlaceholderScreen('Démarrage')),
        GoRoute(
        path: AppRoutes.login,
        builder: (_, _) => const LoginScreen()),
    GoRoute(
        path: AppRoutes.register,
        builder: (_, _) => const PlaceholderScreen('Inscription')),
    GoRoute(
        path: AppRoutes.results,
        builder: (_, _) => const PlaceholderScreen('Résultats')),
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
        builder: (_, _) => const PlaceholderScreen('Signalement')),

    // Écrans avec barre de navigation (4 onglets)
    StatefulShellRoute.indexedStack(
      builder: (_, _, shell) => ScaffoldWithNav(navigationShell: shell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(
              path: AppRoutes.search,
              builder: (_, _) => const PlaceholderScreen('Explorer')),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
              path: AppRoutes.publish,
              builder: (_, _) => const PlaceholderScreen('Publier')),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
              path: AppRoutes.activity,
              builder: (_, _) => const PlaceholderScreen('Activité')),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
              path: AppRoutes.profile,
              builder: (_, _) => const PlaceholderScreen('Profil')),
        ]),
      ],
    ),
  ],
);
