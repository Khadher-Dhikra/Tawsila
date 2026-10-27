import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/user_profile.dart';
import '../user_repository.dart';

class FirebaseUserRepository implements UserRepository {
  final FirebaseFirestore _db;

  FirebaseUserRepository({FirebaseFirestore? db})
      : _db = db ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _col => _db.collection('users');

  @override
  Future<UserProfile?> getProfile(String uid) async {
    final doc = await _col.doc(uid).get();
    return doc.exists ? UserProfile.fromFirestore(doc) : null;
  }

  @override
  Future<void> saveProfile(UserProfile profile) =>
      _col.doc(profile.uid).set(profile.toMap());
}