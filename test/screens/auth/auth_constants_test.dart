import 'package:flutter_test/flutter_test.dart';
import 'package:phone_away/screens/auth/auth_constants.dart';

void main() {
  group('AuthConstants Tests', () {
    test('should have correct app title', () {
      expect(AuthConstants.appTitle, 'PhoneAway');
    });

    test('should have form field labels', () {
      expect(AuthConstants.emailLabel, 'Email');
      expect(AuthConstants.passwordLabel, 'Password');
    });

    test('should have button texts', () {
      expect(AuthConstants.loginButtonText, 'Login');
      expect(AuthConstants.registerButtonText, 'Register');
    });

    test('should have account switch texts', () {
      expect(AuthConstants.noAccountText, 'Don\'t have an account? Register');
      expect(AuthConstants.haveAccountText, 'Already have an account? Login');
    });

    test('should have validation error messages', () {
      expect(AuthConstants.emailValidationError, 'Enter a valid email');
      expect(AuthConstants.passwordValidationError, 'Password must be at least 6 characters');
    });

    test('should have registration failure message', () {
      expect(AuthConstants.registrationFailureMessage, 'Registrierung fehlgeschlagen: user ist null');
    });

    test('should have circle 1 properties', () {
      expect(AuthConstants.circle1Size, 120.0);
      expect(AuthConstants.circle1Top, -60.0);
      expect(AuthConstants.circle1Left, -40.0);
      expect(AuthConstants.circle1Opacity, 0.8);
    });

    test('should have circle 2 properties', () {
      expect(AuthConstants.circle2Size, 250.0);
      expect(AuthConstants.circle2Top, -40.0);
      expect(AuthConstants.circle2Right, -50.0);
      expect(AuthConstants.circle2Opacity, 1.0);
    });

    test('should have circle 3 properties', () {
      expect(AuthConstants.circle3Size, 340.0);
      expect(AuthConstants.circle3Top, -200.0);
      expect(AuthConstants.circle3Left, 75.0);
      expect(AuthConstants.circle3Opacity, 0.8);
    });

    test('should have circle 4 properties', () {
      expect(AuthConstants.circle4Size, 90.0);
      expect(AuthConstants.circle4Top, 100.0);
      expect(AuthConstants.circle4Left, -70.0);
      expect(AuthConstants.circle4Opacity, 0.35);
    });

    test('should have circle 5 properties', () {
      expect(AuthConstants.circle5Size, 70.0);
      expect(AuthConstants.circle5Top, 160.0);
      expect(AuthConstants.circle5Right, -60.0);
      expect(AuthConstants.circle5Opacity, 0.25);
    });

    test('should have circle 6 properties', () {
      expect(AuthConstants.circle6Size, 100.0);
      expect(AuthConstants.circle6Top, 60.0);
      expect(AuthConstants.circle6CenterOffset, 150.0);
      expect(AuthConstants.circle6Opacity, 0.25);
    });

    test('should have valid opacity values', () {
      expect(AuthConstants.circle1Opacity, greaterThanOrEqualTo(0.0));
      expect(AuthConstants.circle1Opacity, lessThanOrEqualTo(1.0));
      expect(AuthConstants.circle2Opacity, greaterThanOrEqualTo(0.0));
      expect(AuthConstants.circle2Opacity, lessThanOrEqualTo(1.0));
      expect(AuthConstants.circle3Opacity, greaterThanOrEqualTo(0.0));
      expect(AuthConstants.circle3Opacity, lessThanOrEqualTo(1.0));
    });
  });
}
