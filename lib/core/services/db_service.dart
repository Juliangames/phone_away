import 'package:firebase_database/firebase_database.dart';

class DBService {
  final FirebaseDatabase _db = FirebaseDatabase.instance;

  DatabaseReference get _usersRef => _db.ref().child('users');
  DatabaseReference get _friendsRef => _db.ref().child('friends');

  /// Speichert oder aktualisiert alle Nutzerdaten
  Future<void> saveUserData({
    required String userId,
    required String username,
    required String avatarUrl,
    required int apples,
    required int rottenApples,
    required bool notifications,
  }) async {
    await _usersRef.child(userId).set({
      'username': username,
      'avatar': avatarUrl,
      'apples': apples,
      'rotten_apples': rottenApples,
      'notifications': notifications,
    });
  }

  /// Holt alle Daten eines Users
  Future<DataSnapshot> getUserData(String userId) async {
    return await _usersRef.child(userId).get();
  }

  /// Aktualisiert den Benutzernamen
  Future<void> updateUsername(String userId, String newUsername) async {
    await _usersRef.child(userId).update({'username': newUsername});
  }

  /// Aktualisiert das Avatar-Bild
  Future<void> updateAvatar(String userId, String newAvatarUrl) async {
    await _usersRef.child(userId).update({'avatar': newAvatarUrl});
  }

  /// Aktualisiert die Benachrichtigungs-Einstellung
  Future<void> updateNotifications(String userId, bool enabled) async {
    await _usersRef.child(userId).update({'notifications': enabled});
  }

  /// Aktualisiert die Anzahl an Äpfeln
  Future<void> updateApples(String userId, int newApples) async {
    await _usersRef.child(userId).update({'apples': newApples});
  }

  /// Aktualisiert die Anzahl an faulen Äpfeln
  Future<void> updateRottenApples(String userId, int newRottenApples) async {
    await _usersRef.child(userId).update({'rotten_apples': newRottenApples});
  }

  /// Fügt eine Freundschaft hinzu (bidirektional)
  Future<void> addFriend(String userId, String friendId) async {
    await _friendsRef.child(userId).child(friendId).set(true);
    await _friendsRef.child(friendId).child(userId).set(true);
  }

  /// Entfernt eine Freundschaft (bidirektional)
  Future<void> removeFriend(String userId, String friendId) async {
    await _friendsRef.child(userId).child(friendId).remove();
    await _friendsRef.child(friendId).child(userId).remove();
  }

  /// Gibt die Freundesliste eines Users zurück
  Future<DataSnapshot> getFriends(String userId) async {
    return await _friendsRef.child(userId).get();
  }
}
