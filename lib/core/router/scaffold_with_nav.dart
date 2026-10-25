import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithNav extends StatelessWidget {
  const ScaffoldWithNav({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (i) => navigationShell.goBranch(
          i,
          initialLocation: i == navigationShell.currentIndex,
        ),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.search), label: 'Explorer'),
          NavigationDestination(
              icon: Icon(Icons.add_circle_outline), label: 'Publier'),
          NavigationDestination(
              icon: Icon(Icons.event_note_outlined), label: 'Activité'),
          NavigationDestination(
              icon: Icon(Icons.person_outline), label: 'Profil'),
        ],
      ),
    );
  }
}
