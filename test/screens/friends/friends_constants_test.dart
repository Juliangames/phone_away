import 'package:flutter_test/flutter_test.dart';
import 'package:phone_away/screens/friends/friends_constants.dart';

void main() {
  group('FriendsConstants Business Logic Tests', () {
    test('should provide consistent spacing for UI calculations', () {
      // Test that spacing is positive and reasonable for UI layout
      expect(FriendsConstants.spacingBetweenAvatarAndText, greaterThan(0));
      expect(FriendsConstants.spacingBetweenAvatarAndText, lessThan(50)); // reasonable UI spacing
    });

    test('should have all required text constants defined', () {
      // Test that no constants are null or empty (would break UI)
      final requiredTexts = [
        FriendsConstants.pageTitle,
        FriendsConstants.rankHeader,
        FriendsConstants.userHeader,
        FriendsConstants.applesHeader,
        FriendsConstants.noFriendsMessage,
        FriendsConstants.retryButtonLabel,
        FriendsConstants.friendAddedMessage,
        FriendsConstants.inviteText,
        FriendsConstants.offlineMessage,
      ];
      
      for (final text in requiredTexts) {
        expect(text.trim().isNotEmpty, isTrue, reason: 'Text constant should not be empty');
        expect(text.length, greaterThan(1), reason: 'Text should be meaningful');
      }
    });

    test('should provide user-friendly error messages', () {
      // Test that error messages are helpful for users
      expect(FriendsConstants.offlineMessage.toLowerCase(), anyOf([
        contains('internet'),
        contains('network'),
        contains('connection'),
      ]), reason: 'Offline message should mention connectivity');
      
      expect(FriendsConstants.linkCreationError.isNotEmpty, isTrue);
    });

    test('should have consistent text casing for UI elements', () {
      // Test that headers use consistent casing (important for UI consistency)
      final headers = [
        FriendsConstants.rankHeader,
        FriendsConstants.userHeader,
        FriendsConstants.applesHeader,
      ];
      
      for (final header in headers) {
        // Check that headers start with capital letter (UI convention)
        expect(header[0], matches(RegExp(r'[A-Z]')), 
               reason: 'Headers should start with capital letter');
        // Check that headers are not all caps (better UX)
        expect(header, isNot(equals(header.toUpperCase())), 
               reason: 'Headers should not be all caps for better readability');
      }
    });

    test('should provide appropriate invite text structure', () {
      // Test that invite text is suitable for sharing
      expect(FriendsConstants.inviteText.length, greaterThan(10), 
             reason: 'Invite text should be descriptive enough');
      expect(FriendsConstants.inviteText.toLowerCase(), anyOf([
        contains('join'),
        contains('add'),
        contains('friend'),
      ]), reason: 'Invite text should be clear about its purpose');
    });

    test('should use appropriate language for user feedback', () {
      // Test that user-facing messages are polite and helpful
      expect(FriendsConstants.friendAddedMessage.toLowerCase(), 
             anyOf([contains('friend'), contains('success'), contains('added')]),
             reason: 'Success message should be clear');
      
      expect(FriendsConstants.noFriendsMessage.toLowerCase(), 
             contains('friend'),
             reason: 'No friends message should explain what is missing');
    });
  });
}
