import 'package:flutter_test/flutter_test.dart';
import 'package:phone_away/screens/friends/friends_constants.dart';

void main() {
  group('FriendsConstants Tests', () {
    test('essential UI texts exist', () {
      expect(FriendsConstants.pageTitle, isNotEmpty);
      expect(FriendsConstants.rankHeader, isNotEmpty);
      expect(FriendsConstants.userHeader, isNotEmpty);
      expect(FriendsConstants.applesHeader, isNotEmpty);
      expect(FriendsConstants.currentUserDisplayName, isNotEmpty);
      expect(FriendsConstants.retryButtonLabel, isNotEmpty);
      expect(FriendsConstants.inviteButtonLabel, isNotEmpty);
    });

    test('table headers are unique', () {
      final headers = [
        FriendsConstants.rankHeader,
        FriendsConstants.userHeader,
        FriendsConstants.applesHeader,
      ];
      expect(headers.toSet().length, equals(3)); // All unique
    });

    test('dimensions are positive', () {
      expect(FriendsConstants.spacingBetweenAvatarAndText, greaterThan(0));
    });

    test('deep link path is valid', () {
      expect(FriendsConstants.friendsPath, startsWith('/'));
      expect(FriendsConstants.fromParameter, isNotEmpty);
    });
  });
}
