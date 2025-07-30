import 'package:firebase_database/firebase_database.dart';
import '../repositories/user_repository.dart';

class FirebaseUserRepository implements UserRepository {
  final FirebaseDatabase _db = FirebaseDatabase.instance;

  // Konstante für die maximale Anzahl an Äpfeln/faulen Äpfeln
  static const int maxApples = 20;

  DatabaseReference get _usersRef => _db.ref().child('users');
  DatabaseReference get _friendsRef => _db.ref().child('friends');

  /// Speichert oder aktualisiert alle Nutzerdaten
  @override
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

  /// Legt einen neuen Nutzer mit Standardwerten an
  @override
  Future<void> createDefaultUser(String userId) async {
    await _usersRef.child(userId).set({
      'username': 'Neuer Nutzer',
      'avatar': '', // Leerer String oder Default-URL, falls vorhanden
      'apples': 0,
      'rotten_apples': 0,
      'notifications': true,
    });
  }

  /// Holt alle Daten eines Users
  @override
  Future<Map<String, dynamic>?> getUserData(String userId) async {
    final snapshot = await _usersRef.child(userId).get();
    if (snapshot.exists && snapshot.value != null) {
      return Map<String, dynamic>.from(snapshot.value as Map);
    }
    return null; // Falls keine Daten vorhanden sind
  }

  /// Aktualisiert den Benutzernamen
  @override
  Future<void> updateUsername(String userId, String newUsername) async {
    await _usersRef.child(userId).update({'username': newUsername});
  }

  /// Aktualisiert das Avatar-Bild
  @override
  Future<void> updateAvatar(String userId, String newAvatarUrl) async {
    await _usersRef.child(userId).update({'avatar': newAvatarUrl});
  }

  /// Aktualisiert die Benachrichtigungs-Einstellung
  @override
  Future<void> updateNotifications(String userId, bool enabled) async {
    await _usersRef.child(userId).update({'notifications': enabled});
  }

  /// Aktualisiert die Anzahl an Äpfeln
  @override
  Future<void> updateApples(String userId, int newApples) async {
    await _usersRef.child(userId).update({'apples': newApples});
  }

  /// Ruft Äpfel-Daten eines Users ab
  @override
  Future<int> getApples(String userId) async {
    final snapshot = await _usersRef.child(userId).child('apples').get();
    return snapshot.exists ? (snapshot.value as int?) ?? 0 : 0;
  }

  /// Aktualisiert die Anzahl an faulen Äpfeln
  @override
  Future<void> updateRottenApples(String userId, int newRottenApples) async {
    await _usersRef.child(userId).update({'rotten_apples': newRottenApples});
  }

  /// Fügt einem User Äpfel hinzu
  /// Maximal 20 Äpfel. Überschreitet der Wert 20, wird ein fauler Apfel abgezogen.
  @override
  Future<void> addApple(String userId, int count) async {
    int currentApples = await getApples(userId);
    int newApples = currentApples + count;

    if (newApples > maxApples) {
      await addRottenApple(userId, -1);
      newApples = maxApples;
    }
    await updateApples(userId, newApples);
  }

  /// Fügt einem User faule Äpfel hinzu
  /// Maximal 20 faule Äpfel. Überschreitet der Wert 20, wird ein guter Apfel abgezogen.
  @override
  Future<void> addRottenApple(String userId, int count) async {
    int currentRottenApples = await getRottenApples(userId);
    int newRottenApples = currentRottenApples + count;

    if (newRottenApples > maxApples) {
      await addApple(userId, -1);
      newRottenApples = maxApples;
    }
    await updateRottenApples(userId, newRottenApples);
  }

  /// Ruft faule Äpfel-Daten eines Users ab
  @override
  Future<int> getRottenApples(String userId) async {
    final snapshot = await _usersRef.child(userId).child('rotten_apples').get();
    return snapshot.exists ? (snapshot.value as int?) ?? 0 : 0;
  }

  /// Fügt eine Freundschaft hinzu (bidirektional)
  @override
  Future<void> addFriend(String userId, String friendId) async {
    await _friendsRef.child(userId).child(friendId).set(true);
    await _friendsRef.child(friendId).child(userId).set(true);
  }

  /// Entfernt eine Freundschaft (bidirektional)
  @override
  Future<void> removeFriend(String userId, String friendId) async {
    await _friendsRef.child(userId).child(friendId).remove();
    await _friendsRef.child(friendId).child(userId).remove();
  }

  /// Gibt die Freundesliste eines Users zurück
  @override
  Future<List<String>> getFriends(String userId) async {
    final snapshot = await _friendsRef.child(userId).get();
    if (!snapshot.exists || snapshot.value == null) return [];

    final data = Map<String, dynamic>.from(snapshot.value as Map);
    return data.keys.toList();
  }
}
