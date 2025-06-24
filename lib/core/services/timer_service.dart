import 'dart:async';

import 'package:phone_away/core/services/db_service.dart';

class TimerService {
  final DBService dbService;
  final String userId;
  TimerService({required this.userId, required this.dbService});

  int _remainingSeconds = 0;
  int get remainingSeconds => _remainingSeconds;

  bool _isRunning = false;
  bool get isRunning => _isRunning;

  Timer? _timer;

  final StreamController<int> _timeStreamController =
      StreamController<int>.broadcast();

  /// Expose a stream that immediately emits the current _remainingSeconds on new subscription
  Stream<int> get timeStream => Stream<int>.multi((listener) {
    // First emit current remainingSeconds immediately
    listener.add(_remainingSeconds);

    // Then forward all future events from the main controller
    final subscription = _timeStreamController.stream.listen(listener.add);

    // Cancel subscription on cancel
    listener.onCancel = subscription.cancel;
  });

  void start(int totalSeconds) {
    _remainingSeconds = totalSeconds;
    _isRunning = true;
    _timeStreamController.add(_remainingSeconds);

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _remainingSeconds--;
      if (_remainingSeconds <= 0) {
        stop();
      } else {
        _timeStreamController.add(_remainingSeconds);
      }
    });
  }

  void stop() {
    // Prüfe ob Ziel erreicht wurde
    if (_remainingSeconds <= 0) {
      print('Timer completed successfully.');
      dbService.addApple(userId, 1);
    } else {
      print('Timer stopped before reaching zero.');
      dbService.addRottenApple(userId, 1);
    }

    _timer?.cancel();
    _timer = null;
    _isRunning = false;
    _timeStreamController.add(_remainingSeconds);
  }

  void dispose() {
    _timer?.cancel();
    _timeStreamController.close();
  }
}
