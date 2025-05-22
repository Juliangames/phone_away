import 'dart:async';

class TimerService {
  static final TimerService _instance = TimerService._internal();
  factory TimerService() => _instance;
  TimerService._internal();

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
