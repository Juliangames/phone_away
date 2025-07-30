import 'package:flutter_test/flutter_test.dart';
import 'package:phone_away/screens/settings/settings_constants.dart';

void main() {
  group('SettingsConstants Tests', () {
    test('should have correct page title', () {
      expect(SettingsConstants.pageTitle, 'Settings');
    });

    test('should have correct section texts', () {
      expect(SettingsConstants.changeAvatarText, 'Change Avatar');
      expect(SettingsConstants.usernameText, 'Username');
      expect(SettingsConstants.notificationsText, 'Notifications');
      expect(SettingsConstants.appearanceText, 'Appearance');
      expect(SettingsConstants.logoutText, 'Logout');
    });

    test('should have theme option texts', () {
      expect(SettingsConstants.lightThemeText, 'Light');
      expect(SettingsConstants.darkThemeText, 'Dark');
      expect(SettingsConstants.systemThemeText, 'System');
    });

    test('should have logout confirmation texts', () {
      expect(SettingsConstants.logoutConfirmTitle, 'Logout');
      expect(SettingsConstants.logoutConfirmMessage, 'Are you sure you want to logout?');
      expect(SettingsConstants.logoutFailedPrefix, 'Logout failed: ');
    });

    test('should have easter egg constants', () {
      expect(SettingsConstants.easterEggTitle, '🧙‍♂️ Seepold has appeared!');
      expect(SettingsConstants.easterEggImagePath, 'assets/images/seepold.png');
    });

    test('should have log message constants', () {
      expect(SettingsConstants.pickingImageLog, 'Picking image...');
      expect(SettingsConstants.imagePickedLog, 'Image picked: ');
      expect(SettingsConstants.avatarUrlFromStorageLog, 'Avatar URL from storage: ');
    });

    test('should have non-empty string constants', () {
      expect(SettingsConstants.pageTitle.isNotEmpty, isTrue);
      expect(SettingsConstants.changeAvatarText.isNotEmpty, isTrue);
      expect(SettingsConstants.usernameText.isNotEmpty, isTrue);
      expect(SettingsConstants.notificationsText.isNotEmpty, isTrue);
      expect(SettingsConstants.appearanceText.isNotEmpty, isTrue);
      expect(SettingsConstants.logoutText.isNotEmpty, isTrue);
    });

    test('should have valid asset path format', () {
      expect(SettingsConstants.easterEggImagePath.startsWith('assets/'), isTrue);
      expect(SettingsConstants.easterEggImagePath.endsWith('.png'), isTrue);
    });

    test('should have themed text options', () {
      final themeTexts = [
        SettingsConstants.lightThemeText,
        SettingsConstants.darkThemeText,
        SettingsConstants.systemThemeText,
      ];
      
      expect(themeTexts.length, 3);
      expect(themeTexts.every((text) => text.isNotEmpty), isTrue);
    });
  });
}
