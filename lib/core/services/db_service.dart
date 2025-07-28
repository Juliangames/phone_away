import 'package:firebase_database/firebase_database.dart';

class DBService {
  final FirebaseDatabase _db = FirebaseDatabase.instance;

  // Konstante für die maximale Anzahl an Äpfeln/faulen Äpfeln
  static const int maxApples = 20;

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

  /// Legt einen neuen Nutzer mit Standardwerten an
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

  /// Ruft Äpfel-Daten eines Users ab
  Future<DataSnapshot> getApples(String userId) async {
    return await _usersRef.child(userId).child('apples').get();
  }

  /// Aktualisiert die Anzahl an faulen Äpfeln
  Future<void> updateRottenApples(String userId, int newRottenApples) async {
    await _usersRef.child(userId).update({'rotten_apples': newRottenApples});
  }

  /// Fügt einem User Äpfel hinzu
  /// Maximal 20 Äpfel. Überschreitet der Wert 20, wird ein fauler Apfel abgezogen.
  Future<void> addApple(String userId, int count) async {
    final applesSnapshot = await getApples(userId);
    int currentApples =
        applesSnapshot.exists ? (applesSnapshot.value as int?) ?? 0 : 0;
    int newApples = currentApples + count;

    if (newApples > maxApples) {
      // Verwendung der Konstanten
      await addRottenApple(userId, -1);
      newApples = maxApples; // Verwendung der Konstanten
    }
    await updateApples(userId, newApples);
  }

  /// Fügt einem User faule Äpfel hinzu
  /// Maximal 20 faule Äpfel. Überschreitet der Wert 20, wird ein guter Apfel abgezogen.
  Future<void> addRottenApple(String userId, int count) async {
    final rottenApplesSnapshot = await getRottenApples(userId);
    int currentRottenApples =
        rottenApplesSnapshot.exists
            ? (rottenApplesSnapshot.value as int?) ?? 0
            : 0;
    int newRottenApples = currentRottenApples + count;

    if (newRottenApples > maxApples) {
      // Verwendung der Konstanten
      await addApple(userId, -1);
      newRottenApples = maxApples; // Verwendung der Konstanten
    }
    await updateRottenApples(userId, newRottenApples);
  }

  /// Ruft faule Äpfel-Daten eines Users ab
  Future<DataSnapshot> getRottenApples(String userId) async {
    return await _usersRef.child(userId).child('rotten_apples').get();
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
