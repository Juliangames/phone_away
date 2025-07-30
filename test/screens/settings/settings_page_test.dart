import 'package:flutter_test/flutter_test.dart';
import 'package:phone_away/screens/settings/settings_constants.dart';

void main() {
  group('SettingsConstants Tests', () {
    test('essential UI texts exist', () {
      expect(SettingsConstants.pageTitle, isNotEmpty);
      expect(SettingsConstants.changeAvatarText, isNotEmpty);
      expect(SettingsConstants.usernameText, isNotEmpty);
      expect(SettingsConstants.notificationsText, isNotEmpty);
      expect(SettingsConstants.appearanceText, isNotEmpty);
      expect(SettingsConstants.logoutText, isNotEmpty);
    });

    test('theme options exist', () {
      expect(SettingsConstants.lightThemeText, isNotEmpty);
      expect(SettingsConstants.darkThemeText, isNotEmpty);
      expect(SettingsConstants.systemThemeText, isNotEmpty);
    });

    test('dialog texts exist', () {
      expect(SettingsConstants.logoutConfirmTitle, isNotEmpty);
      expect(SettingsConstants.logoutConfirmMessage, isNotEmpty);
      expect(SettingsConstants.logoutFailedPrefix, isNotEmpty);
    });

    test('easter egg configuration exists', () {
      expect(SettingsConstants.easterEggTitle, isNotEmpty);
      expect(SettingsConstants.easterEggImagePath, isNotEmpty);
    });

    test('theme options are unique', () {
      final themes = [
        SettingsConstants.lightThemeText,
        SettingsConstants.darkThemeText,
        SettingsConstants.systemThemeText,
      ];
      expect(themes.toSet().length, equals(3)); // All unique
    });
  });
}
