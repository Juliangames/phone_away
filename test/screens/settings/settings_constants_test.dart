import 'package:flutter_test/flutter_test.dart';
import 'package:phone_away/screens/settings/settings_constants.dart';

void main() {
  group('SettingsConstants Tests', () {
    test('text constants have correct values', () {
      expect(SettingsConstants.pageTitle, equals('Settings'));
      expect(SettingsConstants.changeAvatarText, equals('Change Avatar'));
      expect(SettingsConstants.usernameText, equals('Username'));
      expect(SettingsConstants.notificationsText, equals('Notifications'));
      expect(SettingsConstants.appearanceText, equals('Appearance'));
      expect(SettingsConstants.logoutText, equals('Logout'));
    });

    test('theme constants have correct values', () {
      expect(SettingsConstants.lightThemeText, equals('Light'));
      expect(SettingsConstants.darkThemeText, equals('Dark'));
      expect(SettingsConstants.systemThemeText, equals('System'));
    });

    test('dialog constants have correct values', () {
      expect(SettingsConstants.logoutConfirmTitle, equals('Logout'));
      expect(SettingsConstants.logoutConfirmMessage,
          equals('Are you sure you want to logout?'));
      expect(SettingsConstants.logoutFailedPrefix, equals('Logout failed: '));
    });

    test('easter egg constants have correct values', () {
      expect(SettingsConstants.easterEggTitle,
          equals('🧙‍♂️ Seepold has appeared!'));
      expect(SettingsConstants.easterEggImagePath,
          equals('assets/images/seepold.png'));
    });

    test('logging constants have correct values', () {
      expect(SettingsConstants.pickingImageLog, equals('Picking image...'));
      expect(SettingsConstants.imagePickedLog, equals('Image picked: '));
      expect(SettingsConstants.avatarUrlFromStorageLog,
          equals('Avatar URL from storage: '));
    });

    test('all text constants are not empty', () {
      expect(SettingsConstants.pageTitle, isNotEmpty);
      expect(SettingsConstants.changeAvatarText, isNotEmpty);
      expect(SettingsConstants.usernameText, isNotEmpty);
      expect(SettingsConstants.notificationsText, isNotEmpty);
      expect(SettingsConstants.appearanceText, isNotEmpty);
      expect(SettingsConstants.logoutText, isNotEmpty);
    });

    test('theme texts are different', () {
      expect(SettingsConstants.lightThemeText,
          isNot(equals(SettingsConstants.darkThemeText)));
      expect(SettingsConstants.darkThemeText,
          isNot(equals(SettingsConstants.systemThemeText)));
      expect(SettingsConstants.lightThemeText,
          isNot(equals(SettingsConstants.systemThemeText)));
    });

    test('dialog title matches action', () {
      expect(SettingsConstants.logoutConfirmTitle,
          equals(SettingsConstants.logoutText));
    });

    test('easter egg title contains emoji', () {
      expect(SettingsConstants.easterEggTitle, contains('🧙‍♂️'));
      expect(SettingsConstants.easterEggTitle, contains('Seepold'));
    });

    test('easter egg image path is valid', () {
      expect(SettingsConstants.easterEggImagePath, startsWith('assets/'));
      expect(SettingsConstants.easterEggImagePath, endsWith('.png'));
      expect(SettingsConstants.easterEggImagePath, contains('seepold'));
    });

    test('log messages are descriptive', () {
      expect(SettingsConstants.pickingImageLog, contains('image'));
      expect(SettingsConstants.imagePickedLog, contains('Image picked'));
      expect(SettingsConstants.avatarUrlFromStorageLog, contains('Avatar URL'));
    });

    test('logout confirmation message is questioning', () {
      expect(SettingsConstants.logoutConfirmMessage, contains('Are you sure'));
      expect(SettingsConstants.logoutConfirmMessage, contains('?'));
    });

    test('settings categories are meaningful', () {
      expect(SettingsConstants.usernameText, equals('Username'));
      expect(SettingsConstants.notificationsText, equals('Notifications'));
      expect(SettingsConstants.appearanceText, equals('Appearance'));
    });

    test('theme options cover main cases', () {
      final themes = [
        SettingsConstants.lightThemeText,
        SettingsConstants.darkThemeText,
        SettingsConstants.systemThemeText,
      ];

      expect(themes, hasLength(3));
      expect(themes, contains('Light'));
      expect(themes, contains('Dark'));
      expect(themes, contains('System'));
    });

    test('error prefix ends with appropriate separator', () {
      expect(SettingsConstants.logoutFailedPrefix, endsWith(': '));
    });
  });
}
