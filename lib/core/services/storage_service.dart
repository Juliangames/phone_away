import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart'; // für kIsWeb
import 'dart:io' show File;

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Pfad: avatars/{userId}.jpg
  Future<String> uploadAvatar(String userId, XFile file) async {

    final ref = _storage.ref().child('avatars').child('$userId.jpg');

    if (!kIsWeb) {
      final File imageFile = File(file.path);
      await ref.putFile(imageFile);
    }

    final url = await ref.getDownloadURL();
    return url;
  }

  /// Holt die URL eines existierenden Avatars – wirft Fehler, wenn nicht vorhanden
  Future<String> getAvatarUrl(String userId) async {
    final ref = _storage.ref().child('avatars').child('$userId.jpg');
    final url = await ref.getDownloadURL();
    return url;
  }

  /// Optional: Avatar löschen
  Future<void> deleteAvatar(String userId) async {
    final ref = _storage.ref().child('avatars').child('$userId.jpg');
    await ref.delete();
  }
}
