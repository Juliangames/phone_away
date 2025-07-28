import 'dart:async';
import 'package:phone_away/core/providers/user_repository_provider.dart';

import '../services/network_service.dart';
import '../services/timer_service.dart';

class SyncManager {
  static final SyncManager _instance = SyncManager._internal();
  factory SyncManager() => _instance;
  SyncManager._internal();

  final NetworkService _networkService = NetworkService();
  StreamSubscription<bool>? _connectivitySubscription;
  bool _isInitialized = false;

  /// Initialize sync manager to listen for connectivity changes
  void initialize(String userId) {
    if (_isInitialized) return;

    _isInitialized = true;
    _networkService.startMonitoring();

    _connectivitySubscription = _networkService.connectionStatusStream.listen((
      isConnected,
    ) {
      if (isConnected) {
        _performSync(userId);
      }
    });
  }

  /// Perform sync when connection is restored
  Future<void> _performSync(String userId) async {
    // Create services
    final timerService = TimerService(
      userRepository: UserRepositoryProvider.instance,
      userId: userId,
    );

    // Sync offline timer updates
    await timerService.syncOfflineUpdates();
  }

  /// Force sync now (for manual retry)
  Future<void> forceSyncNow(String userId) async {
    final isConnected = await _networkService.checkConnection();
    if (isConnected) {
      await _performSync(userId);
    } else {
      throw NetworkConnectionException(
        'No internet connection available for sync',
      );
    }
  }

  /// Dispose resources
  void dispose() {
    _connectivitySubscription?.cancel();
    _networkService.stopMonitoring();
    _isInitialized = false;
  }
}
