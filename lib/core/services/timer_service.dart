import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:phone_away/core/services/db_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import '../helpers/error_handler.dart';

class TimerService {
  final DBService dbService;
  final String userId;

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  Timer? _timer;
  DateTime? _startTime;
  int _durationSeconds = 0;

  final _timeStreamController = StreamController<int>.broadcast();

  TimerService._internal({required this.dbService, required this.userId}) {
    _initializeTimer();
  }

  static TimerService? _instance;

  factory TimerService({required DBService dbService, required String userId}) {
    _instance ??= TimerService._internal(dbService: dbService, userId: userId);
    return _instance!;
  }

  Future<void> _initializeTimer() async {
    await _requestNotificationPermission();
    await _notifications.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );
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
    await _showConcentrationNotification();
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
      await _showConcentrationNotification();
      _timeStreamController.add(_calculateRemaining());
    } else {
      try {
        await ErrorHandler.executeWithErrorHandling(() async {
          await dbService.addApple(userId, 1);
        });
      } catch (e) {
        // If offline, save for later sync
        await _saveOfflineUpdate('apple');
      }
      await _clearPrefs();
      _timeStreamController.add(0);
    }
  }

  Future<void> stop() async {
    final remaining = _calculateRemaining();

    try {
      await ErrorHandler.executeWithErrorHandling(() async {
        if (remaining <= 0) {
          await dbService.addApple(userId, 1);
        } else {
          await dbService.addRottenApple(userId, 1);
        }
      });
    } catch (e) {
      // If offline, save locally for later sync
      await _saveOfflineUpdate(remaining <= 0 ? 'apple' : 'rotten_apple');
    }

    _timer?.cancel();
    _startTime = null;
    _durationSeconds = 0;
    _timeStreamController.add(0);
    await _clearPrefs();
    await _cancelConcentrationNotification();
  }

  Future<void> _saveOfflineUpdate(String type) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> offlineUpdates =
        prefs.getStringList('offline_updates') ?? [];

    offlineUpdates.add('${DateTime.now().toIso8601String()}:$type:$userId');
    await prefs.setStringList('offline_updates', offlineUpdates);
  }

  // Method to sync offline updates when back online
  Future<void> syncOfflineUpdates() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> offlineUpdates =
        prefs.getStringList('offline_updates') ?? [];

    if (offlineUpdates.isEmpty) return;

    await ErrorHandler.executeWithErrorHandling(() async {
      for (final update in offlineUpdates) {
        final parts = update.split(':');
        if (parts.length >= 3) {
          final type = parts[1];
          final updateUserId = parts[2];

          if (type == 'apple') {
            await dbService.addApple(updateUserId, 1);
          } else if (type == 'rotten_apple') {
            await dbService.addRottenApple(updateUserId, 1);
          }
        }
      }

      // Clear offline updates after successful sync
      await prefs.remove('offline_updates');
    });
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

  Future<void> _showConcentrationNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'concentration_channel',
      'Concentration Phase',
      channelDescription: 'Notifies when concentration mode is active',
      importance: Importance.max,
      priority: Priority.high,
      ongoing: true,
      autoCancel: false,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _notifications.show(
      0,
      'Concentration Phase Running!',
      'Turn off your phone to earn apples!',
      notificationDetails,
    );
  }

  Future<void> _cancelConcentrationNotification() async {
    await _notifications.cancel(0);
  }

  Future<void> _requestNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isDenied || status.isPermanentlyDenied) {
      await Permission.notification.request();
    }
  }
}
