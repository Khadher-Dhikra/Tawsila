import 'package:firebase_auth/firebase_auth.dart';

import '../auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _auth;

  FirebaseAuthRepository({FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance;

  @override
  Stream<String?> authStateChanges() =>
      _auth.authStateChanges().map((user) => user?.uid);

  @override
  String? get currentUserId => _auth.currentUser?.uid;

  @override
  Future<String> signUp({required String email, required String password}) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred.user!.uid;
  }

  @override
  Future<String> signIn({required String email, required String password}) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred.user!.uid;
  }

  @override
  Future<void> signOut() => _auth.signOut();
}