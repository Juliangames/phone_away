import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:phone_away/core/services/db_service.dart';

class TimerService {
  final DBService dbService;
  final String userId;

  Timer? _timer;
  DateTime? _startTime;
  int _durationSeconds = 0;

  final _timeStreamController = StreamController<int>.broadcast();

  TimerService._internal({required this.dbService, required this.userId}) {
    _initializeTimer();
  }

  static TimerService? _instance;

  factory TimerService({required DBService dbService, required String userId}) {
    if (_instance == null) {
      _instance = TimerService._internal(dbService: dbService, userId: userId);
    }
    return _instance!;
  }

  Future<void> _initializeTimer() async {
    await resumeIfPossible();
  }

  bool get isRunning => _startTime != null;

  Stream<int> get timeStream => Stream<int>.multi((listener) {
    listener.add(_calculateRemaining());
    final sub = _timeStreamController.stream.listen(listener.add);
    listener.onCancel = sub.cancel;
  });

  Future<void> start(int totalSeconds) async {
    _startTime = DateTime.now();
    _durationSeconds = totalSeconds;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('timerStart', _startTime!.toIso8601String());
    await prefs.setInt('timerDuration', _durationSeconds);

    _startTicker();
    _timeStreamController.add(_calculateRemaining());
  }

  Future<void> resumeIfPossible() async {
    final prefs = await SharedPreferences.getInstance();
    final startStr = prefs.getString('timerStart');
    final duration = prefs.getInt('timerDuration');

    if (startStr == null || duration == null) return;

    final parsedStart = DateTime.tryParse(startStr);
    if (parsedStart == null) return;

    final elapsed = DateTime.now().difference(parsedStart).inSeconds;
    final remaining = duration - elapsed;

    if (remaining > 0) {
      _startTime = parsedStart;
      _durationSeconds = duration;
      _startTicker();
      _timeStreamController.add(_calculateRemaining());
    } else {
      await dbService.addApple(userId, 1);
      await _clearPrefs();
      _timeStreamController.add(0);
    }
  }

  Future<void> stop() async {
    final remaining = _calculateRemaining();

    if (remaining <= 0) {
      await dbService.addApple(userId, 1);
    } else {
      await dbService.addRottenApple(userId, 1);
    }

    _timer?.cancel();
    _startTime = null;
    _durationSeconds = 0;
    _timeStreamController.add(0);
    await _clearPrefs();
  }

  int _calculateRemaining() {
    if (_startTime == null || _durationSeconds == 0) return 0;
    final elapsed = DateTime.now().difference(_startTime!).inSeconds;
    return (_durationSeconds - elapsed).clamp(0, _durationSeconds);
  }

  void _startTicker() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final remaining = _calculateRemaining();
      if (remaining <= 0) {
        stop();
      } else {
        _timeStreamController.add(remaining);
      }
    });
  }

  Future<void> _clearPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('timerStart');
    await prefs.remove('timerDuration');
  }

  void dispose() {
    _timer?.cancel();
    _timeStreamController.close();
    _instance = null;
  }
}
