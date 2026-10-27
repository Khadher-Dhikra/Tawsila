import '../../models/user_profile.dart';
import '../user_repository.dart';

class FakeUserRepository implements UserRepository {
  final Map<String, UserProfile> _profiles = {};

  @override
  Future<UserProfile?> getProfile(String uid) async => _profiles[uid];

  @override
  Future<void> saveProfile(UserProfile profile) async {
    _profiles[profile.uid] = profile;
  }
}