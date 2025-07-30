import 'package:flutter_test/flutter_test.dart';
import 'package:phone_away/screens/timer/timer_constants.dart';

void main() {
  group('TimerConstants Tests', () {
    test('should have correct page title', () {
      expect(TimerConstants.pageTitle, 'Timer');
    });

    test('should have correct button texts', () {
      expect(TimerConstants.startButtonText, 'Start');
      expect(TimerConstants.stopButtonText, 'Stop');
    });

    test('should have motivational texts', () {
      expect(TimerConstants.focusedMotivationalText, 'Stay focused and keep going!');
      expect(TimerConstants.defaultMotivationalText, 'Set a goal and earn apples!');
    });

    test('should have correct bottom padding', () {
      expect(TimerConstants.bottomPadding, 16.0);
    });

    test('should have non-empty string constants', () {
      expect(TimerConstants.pageTitle.isNotEmpty, isTrue);
      expect(TimerConstants.startButtonText.isNotEmpty, isTrue);
      expect(TimerConstants.stopButtonText.isNotEmpty, isTrue);
      expect(TimerConstants.focusedMotivationalText.isNotEmpty, isTrue);
      expect(TimerConstants.defaultMotivationalText.isNotEmpty, isTrue);
    });
  });
}
