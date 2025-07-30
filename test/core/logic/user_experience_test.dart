import 'package:flutter_test/flutter_test.dart';

void main() {
  group('User Experience Logic Tests', () {
    test('should generate appropriate motivational messages', () {
      // Test motivational message selection logic
      String getMotivationalMessage(int currentStreak, double productivityScore) {
        if (currentStreak == 0) {
          return 'Ready to start your focus journey?';
        } else if (currentStreak < 3) {
          return 'Great start! Keep building your streak.';
        } else if (currentStreak < 7) {
          return 'Amazing consistency! You\'re on fire!';
        } else if (productivityScore > 80) {
          return 'You\'re a focus master! Incredible work!';
        } else {
          return 'Every session counts. You\'ve got this!';
        }
      }
      
      expect(getMotivationalMessage(0, 0), contains('Ready'));
      expect(getMotivationalMessage(1, 50), contains('Great start'));
      expect(getMotivationalMessage(5, 60), contains('Amazing'));
      expect(getMotivationalMessage(10, 90), contains('focus master'));
      expect(getMotivationalMessage(10, 50), contains('Every session'));
    });

    test('should calculate user level progression', () {
      // Test level calculation based on total focus time
      Map<String, dynamic> calculateUserLevel(int totalFocusMinutes) {
        const minutesPerLevel = 300; // 5 hours per level
        final level = (totalFocusMinutes / minutesPerLevel).floor() + 1;
        final currentLevelMinutes = totalFocusMinutes % minutesPerLevel;
        final progressPercent = (currentLevelMinutes / minutesPerLevel * 100).round();
        
        return {
          'level': level,
          'progressPercent': progressPercent,
          'minutesUntilNext': minutesPerLevel - currentLevelMinutes,
        };
      }
      
      final result1 = calculateUserLevel(150); // 2.5 hours
      expect(result1['level'], 1);
      expect(result1['progressPercent'], 50);
      expect(result1['minutesUntilNext'], 150);
      
      final result2 = calculateUserLevel(300); // Exactly 5 hours
      expect(result2['level'], 2);
      expect(result2['progressPercent'], 0);
      expect(result2['minutesUntilNext'], 300);
    });

    test('should determine appropriate break suggestions', () {
      // Test break suggestion logic
      String getBreakSuggestion(int continuousFocusMinutes) {
        if (continuousFocusMinutes < 25) {
          return 'Keep going! You\'re in the zone.';
        } else if (continuousFocusMinutes < 50) {
          return 'Consider a 5-minute break to recharge.';
        } else if (continuousFocusMinutes < 90) {
          return 'Time for a 10-minute break. Stretch and hydrate!';
        } else {
          return 'Take a longer break. Your brain needs rest!';
        }
      }
      
      expect(getBreakSuggestion(20), contains('Keep going'));
      expect(getBreakSuggestion(30), contains('5-minute break'));
      expect(getBreakSuggestion(70), contains('10-minute'));
      expect(getBreakSuggestion(120), contains('longer break'));
    });

    test('should validate friend comparison logic', () {
      // Test friend ranking and comparison
      List<Map<String, dynamic>> rankFriends(List<Map<String, dynamic>> friends) {
        friends.sort((a, b) => (b['apples'] as int).compareTo(a['apples'] as int));
        
        for (int i = 0; i < friends.length; i++) {
          friends[i]['rank'] = i + 1;
        }
        
        return friends;
      }
      
      final testFriends = [
        {'name': 'Alice', 'apples': 50},
        {'name': 'Bob', 'apples': 75},
        {'name': 'Charlie', 'apples': 25},
      ];
      
      final ranked = rankFriends(testFriends);
      
      expect(ranked[0]['name'], 'Bob');
      expect(ranked[0]['rank'], 1);
      expect(ranked[1]['name'], 'Alice');
      expect(ranked[1]['rank'], 2);
      expect(ranked[2]['name'], 'Charlie');
      expect(ranked[2]['rank'], 3);
    });

    test('should handle theme preference logic', () {
      // Test theme switching logic
      String getRecommendedTheme(DateTime currentTime) {
        final hour = currentTime.hour;
        
        if (hour >= 6 && hour < 18) {
          return 'light';
        } else {
          return 'dark';
        }
      }
      
      expect(getRecommendedTheme(DateTime(2023, 1, 1, 10)), 'light');
      expect(getRecommendedTheme(DateTime(2023, 1, 1, 20)), 'dark');
      expect(getRecommendedTheme(DateTime(2023, 1, 1, 6)), 'light');
      expect(getRecommendedTheme(DateTime(2023, 1, 1, 18)), 'dark');
    });
  });
}
