import '../models/user_profile.dart';

abstract class UserRepository {
  Future<UserProfile?> getProfile(String uid);
  Future<void> saveProfile(UserProfile profile);
}