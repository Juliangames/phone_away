abstract class UserRepository {
  Future<void> saveUserData({
    required String userId,
    required String username,
    required String avatarUrl,
    required int apples,
    required int rottenApples,
    required bool notifications,
  });

  Future<void> createDefaultUser(String userId);
  Future<void> updateApples(String userId, int newApples);
  Future<void> updateRottenApples(String userId, int newRottenApples);
  Future<int> getApples(String userId);
  Future<int> getRottenApples(String userId);

  Future<void> addApple(String userId, int count);
  Future<void> addRottenApple(String userId, int count);

  Future<Map<String, dynamic>?> getUserData(String userId);
  Future<void> updateUsername(String userId, String newUsername);
  Future<void> updateAvatar(String userId, String newAvatarUrl);
  Future<void> updateNotifications(String userId, bool enabled);

  Future<void> addFriend(String userId, String friendId);
  Future<void> removeFriend(String userId, String friendId);
  Future<List<String>> getFriends(String userId);
}
