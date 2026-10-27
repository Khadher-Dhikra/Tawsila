import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_profile.dart';
import '../repositories/auth_repository.dart';
import '../repositories/firebase/firebase_auth_repository.dart';
import '../repositories/firebase/firebase_user_repository.dart';
import '../repositories/user_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => FirebaseAuthRepository(),
);

final userRepositoryProvider = Provider<UserRepository>(
  (ref) => FirebaseUserRepository(),
);

/// uid de l'utilisateur connecté, ou null s'il est déconnecté
final authStateProvider = StreamProvider<String?>(
  (ref) => ref.watch(authRepositoryProvider).authStateChanges(),
);

/// Profil Firestore de l'utilisateur connecté (null si déconnecté)
final currentProfileProvider = FutureProvider<UserProfile?>((ref) async {
  final uid = ref.watch(authStateProvider).value;
  if (uid == null) return null;
  return ref.watch(userRepositoryProvider).getProfile(uid);
});