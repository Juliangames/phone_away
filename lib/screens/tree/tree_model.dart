import 'package:phone_away/core/services/db_service.dart';
import 'package:flutter/material.dart';

class TreeModel extends ChangeNotifier {
  final String userId;
  TreeModel({required this.userId});

  int apples = 0;
  int rottenApples = 0;

  final DBService _dbService = DBService();

  Future<void> loadApples() async {
    // Lade normale Äpfel
    final applesSnapshot = await _dbService.getApples(userId);
    if (applesSnapshot.exists) {
      apples = applesSnapshot.value as int? ?? 0;
    }

    // Lade faule Äpfel
    final rottenApplesSnapshot = await _dbService.getRottenApples(userId);
    if (rottenApplesSnapshot.exists) {
      rottenApples = rottenApplesSnapshot.value as int? ?? 0;
    }

    notifyListeners();
  }
}
