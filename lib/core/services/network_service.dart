import 'dart:async';
import 'dart:io';

// Custom Network Exceptions
class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);

  @override
  String toString() => message;
}

class NetworkTimeoutException extends NetworkException {
  NetworkTimeoutException(super.message);
}

class NetworkConnectionException extends NetworkException {
  NetworkConnectionException(super.message);
}

class NetworkService {
  static final NetworkService _instance = NetworkService._internal();
  factory NetworkService() => _instance;
  NetworkService._internal();

  final StreamController<bool> _connectionStatusController =
      StreamController<bool>.broadcast();

  Stream<bool> get connectionStatusStream => _connectionStatusController.stream;

  bool _isConnected = true;
  bool get isConnected => _isConnected;

  // Timeout constants
  static const Duration defaultTimeout = Duration(seconds: 10);
  static const Duration quickTimeout = Duration(seconds: 5);

  Timer? _connectivityTimer;

  void startMonitoring() {
    _connectivityTimer?.cancel();
    _connectivityTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _checkConnectivity(),
    );
    // Initial check
    _checkConnectivity();
  }

  void stopMonitoring() {
    _connectivityTimer?.cancel();
  }

  Future<void> _checkConnectivity() async {
    final wasConnected = _isConnected;

    try {
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(quickTimeout);
      _isConnected = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on TimeoutException {
      _isConnected = false;
    } on SocketException {
      _isConnected = false;
    } catch (_) {
      _isConnected = false;
    }

    // Only notify if status changed
    if (wasConnected != _isConnected) {
      _connectionStatusController.add(_isConnected);
    }
  }

  /// Executes a network operation with timeout and error handling
  Future<T> executeWithTimeout<T>(
    Future<T> Function() operation, {
    Duration? timeout,
  }) async {
    try {
      return await operation().timeout(timeout ?? defaultTimeout);
    } on TimeoutException {
      throw NetworkTimeoutException(
        'Request timed out. Please check your internet connection.',
      );
    } on SocketException {
      throw NetworkConnectionException(
        'No internet connection. Please check your network settings.',
      );
    } catch (e) {
      throw NetworkException('Network error occurred: $e');
    }
  }

  Future<bool> checkConnection() async {
    await _checkConnectivity();
    return _isConnected;
  }

  void dispose() {
    _connectivityTimer?.cancel();
    _connectionStatusController.close();
  }
}
