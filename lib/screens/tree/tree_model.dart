import 'package:phone_away/core/providers/user_repository_provider.dart';
import 'package:phone_away/core/repositories/user_repository.dart';
import 'package:flutter/material.dart';

class TreeModel extends ChangeNotifier {
  final String userId;
  TreeModel({required this.userId});

  int apples = 0;
  int rottenApples = 0;

  final UserRepository _dbService = UserRepositoryProvider.instance;

  Future<void> loadApples() async {
    // Lade normale Äpfel (direkt int? zurück)
    final applesValue = await _dbService.getApples(userId);
    apples = applesValue;

    // Lade faule Äpfel (direkt int? zurück)
    final rottenApplesValue = await _dbService.getRottenApples(userId);
    rottenApples = rottenApplesValue;

    notifyListeners();
  }
}
