import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/providers.dart';
import '../../core/router/app_router.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentProfileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: profile.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Center(child: Text('Erreur de chargement')),
        data: (p) {
          if (p == null) {
            return const Center(child: Text('Profil introuvable'));
          }
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Center(
                child: CircleAvatar(
                  radius: 40,
                  child: Text(
                    p.displayName.isEmpty
                        ? '?'
                        : p.displayName[0].toUpperCase(),
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  p.displayName,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              const SizedBox(height: 24),
              ListTile(
                leading: const Icon(Icons.phone),
                title: Text(p.phone),
              ),
              ListTile(
                leading: const Icon(Icons.location_city),
                title: Text(p.city),
              ),
              ListTile(
                leading: const Icon(Icons.star),
                title: Text(p.ratingCount == 0
                    ? 'Pas encore de note'
                    : '${p.ratingAvg.toStringAsFixed(1)} (${p.ratingCount} avis)'),
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text('Se déconnecter'),
                onPressed: () async {
                  await ref.read(authRepositoryProvider).signOut();
                  if (!context.mounted) return;
                  context.go(AppRoutes.login);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}