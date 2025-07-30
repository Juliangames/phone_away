import 'package:flutter_test/flutter_test.dart';
import 'package:phone_away/screens/timer/timer_constants.dart';

void main() {
  group('TimerConstants Tests', () {
    test('text constants have correct values', () {
      expect(TimerConstants.pageTitle, equals('Timer'));
      expect(TimerConstants.startButtonText, equals('Start'));
      expect(TimerConstants.stopButtonText, equals('Stop'));
      expect(TimerConstants.focusedMotivationalText,
          equals('Stay focused and keep going!'));
      expect(TimerConstants.defaultMotivationalText,
          equals('Set a goal and earn apples!'));
    });

    test('dimension constants have correct values', () {
      expect(TimerConstants.bottomPadding, equals(16.0));
    });

    test('button text constants are different', () {
      expect(TimerConstants.startButtonText,
          isNot(equals(TimerConstants.stopButtonText)));
    });

    test('motivational text constants are different', () {
      expect(TimerConstants.focusedMotivationalText,
          isNot(equals(TimerConstants.defaultMotivationalText)));
    });

    test('all text constants are not empty', () {
      expect(TimerConstants.pageTitle, isNotEmpty);
      expect(TimerConstants.startButtonText, isNotEmpty);
      expect(TimerConstants.stopButtonText, isNotEmpty);
      expect(TimerConstants.focusedMotivationalText, isNotEmpty);
      expect(TimerConstants.defaultMotivationalText, isNotEmpty);
    });

    test('dimension constants are positive', () {
      expect(TimerConstants.bottomPadding, greaterThan(0));
    });

    test('page title matches expected format', () {
      expect(TimerConstants.pageTitle, matches(RegExp(r'^[A-Z][a-zA-Z]*$')));
    });

    test('button texts are appropriate length', () {
      expect(TimerConstants.startButtonText.length, lessThanOrEqualTo(10));
      expect(TimerConstants.stopButtonText.length, lessThanOrEqualTo(10));
    });

    test('motivational texts are reasonably long', () {
      expect(TimerConstants.focusedMotivationalText.length, greaterThan(10));
      expect(TimerConstants.defaultMotivationalText.length, greaterThan(10));
    });
  });
}
