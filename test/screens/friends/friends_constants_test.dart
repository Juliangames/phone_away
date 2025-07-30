import 'package:flutter_test/flutter_test.dart';
import 'package:phone_away/screens/friends/friends_constants.dart';

void main() {
  group('FriendsConstants Tests', () {
    test('essential UI texts exist and are not empty', () {
      expect(FriendsConstants.pageTitle, isNotEmpty);
      expect(FriendsConstants.rankHeader, isNotEmpty);
      expect(FriendsConstants.userHeader, isNotEmpty);
      expect(FriendsConstants.applesHeader, isNotEmpty);
      expect(FriendsConstants.currentUserDisplayName, isNotEmpty);
      expect(FriendsConstants.noFriendsMessage, isNotEmpty);
      expect(FriendsConstants.retryButtonLabel, isNotEmpty);
      expect(FriendsConstants.inviteButtonLabel, isNotEmpty);
    });

    test('error and info messages exist', () {
      expect(FriendsConstants.noFriendsSubMessage, isNotEmpty);
      expect(FriendsConstants.offlineMessage, isNotEmpty);
      expect(FriendsConstants.friendAddedMessage, isNotEmpty);
      expect(FriendsConstants.inviteText, isNotEmpty);
      expect(FriendsConstants.linkCreationError, isNotEmpty);
      expect(FriendsConstants.networkErrorMessage, isNotEmpty);
    });

    test('deep link configuration exists', () {
      expect(FriendsConstants.friendsPath, isNotEmpty);
      expect(FriendsConstants.fromParameter, isNotEmpty);
    });

    test('logging configuration exists', () {
      expect(FriendsConstants.loggerName, isNotEmpty);
      expect(FriendsConstants.initStateLog, isNotEmpty);
      expect(FriendsConstants.deepLinkInitLog, isNotEmpty);
      expect(FriendsConstants.initialUriLog, isNotEmpty);
      expect(FriendsConstants.deepLinkReceivedLog, isNotEmpty);
    });

    test('dimensions are positive values', () {
      expect(FriendsConstants.spacingBetweenAvatarAndText, greaterThan(0));
    });

    test('deep link path is valid', () {
      expect(FriendsConstants.friendsPath, startsWith('/'));
    });

    test('table headers are unique', () {
      final headers = [
        FriendsConstants.rankHeader,
        FriendsConstants.userHeader,
        FriendsConstants.applesHeader,
      ];
      expect(headers.toSet().length, equals(3)); // All unique
    });

    test('button labels are unique', () {
      expect(FriendsConstants.retryButtonLabel, 
        isNot(equals(FriendsConstants.inviteButtonLabel)));
    });
  });
}
