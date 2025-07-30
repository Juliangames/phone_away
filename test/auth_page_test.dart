import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';
import 'package:phone_away/screens/auth/auth_page.dart';
import 'package:phone_away/screens/auth/auth_constants.dart';
import 'package:phone_away/core/services/auth_service.dart';
import 'package:phone_away/core/repositories/user_repository.dart';
import 'package:phone_away/theme/app_constants.dart';

// Mock classes
class MockAuthService extends Mock implements AuthService {}

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService();
  });

  group('AuthPage Appearance Tests', () {
    testWidgets('renders correctly in login mode', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: AuthPage()));

      expect(find.text(AuthConstants.appTitle), findsOneWidget);
      expect(find.text(AuthConstants.emailLabel), findsOneWidget);
      expect(find.text(AuthConstants.passwordLabel), findsOneWidget);
      expect(find.text(AuthConstants.loginButtonText), findsOneWidget);
      expect(find.text(AuthConstants.noAccountText), findsOneWidget);
    });

    testWidgets('renders correctly in register mode', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: AuthPage()));

      // Tap to switch to register mode
      await tester.tap(find.text(AuthConstants.noAccountText));
      await tester.pump();

      expect(find.text(AuthConstants.registerButtonText), findsOneWidget);
      expect(find.text(AuthConstants.haveAccountText), findsOneWidget);
    });

    testWidgets('shows loading indicator when submitting', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: AuthPage()));

      // Enter valid email and password
      await tester.enterText(
        find.byKey(const ValueKey(AppStrings.emailFieldKey)),
        'test@example.com',
      );
      await tester.enterText(
        find.byKey(const ValueKey(AppStrings.passwordFieldKey)),
        'password123',
      );

      // Tap login button
      await tester.tap(find.text(AuthConstants.loginButtonText));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('AuthPage Form Validation', () {
    testWidgets('shows error for invalid email', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: AuthPage()));

      // Enter invalid email
      await tester.enterText(
        find.byKey(const ValueKey(AppStrings.emailFieldKey)),
        'invalid-email',
      );
      await tester.enterText(
        find.byKey(const ValueKey(AppStrings.passwordFieldKey)),
        'password123',
      );

      // Tap login button
      await tester.tap(find.text(AuthConstants.loginButtonText));
      await tester.pump();

      expect(find.text(AuthConstants.emailValidationError), findsOneWidget);
    });

    testWidgets('shows error for short password', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: AuthPage()));

      // Enter valid email and short password
      await tester.enterText(
        find.byKey(const ValueKey(AppStrings.emailFieldKey)),
        'test@example.com',
      );
      await tester.enterText(
        find.byKey(const ValueKey(AppStrings.passwordFieldKey)),
        'short',
      );

      // Tap login button
      await tester.tap(find.text(AuthConstants.loginButtonText));
      await tester.pump();

      expect(find.text(AuthConstants.passwordValidationError), findsOneWidget);
    });
  });

  group('AuthPage Interaction Tests', () {
    testWidgets('toggles between login and register modes', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: AuthPage()));

      // Initial state is login
      expect(find.text(AuthConstants.loginButtonText), findsOneWidget);
      expect(find.text(AuthConstants.registerButtonText), findsNothing);

      // Switch to register
      await tester.tap(find.text(AuthConstants.noAccountText));
      await tester.pump();
      expect(find.text(AuthConstants.registerButtonText), findsOneWidget);
      expect(find.text(AuthConstants.loginButtonText), findsNothing);

      // Switch back to login
      await tester.tap(find.text(AuthConstants.haveAccountText));
      await tester.pump();
      expect(find.text(AuthConstants.loginButtonText), findsOneWidget);
      expect(find.text(AuthConstants.registerButtonText), findsNothing);
    });

    testWidgets('calls signIn when in login mode with valid credentials', (
      WidgetTester tester,
    ) async {
      // Setup mock
      when(
        mockAuthService.signIn(
          email: 'test@example.com',
          password: 'password123',
        ),
      ).thenAnswer((_) => Future.value());

      await tester.pumpWidget(
        MaterialApp(home: AuthPage(authService: mockAuthService)),
      );

      // Enter valid credentials
      await tester.enterText(
        find.byKey(const ValueKey(AppStrings.emailFieldKey)),
        'test@example.com',
      );
      await tester.enterText(
        find.byKey(const ValueKey(AppStrings.passwordFieldKey)),
        'password123',
      );

      // Tap login button
      await tester.tap(find.text(AuthConstants.loginButtonText));
      await tester.pump();

      // Verify signIn was called
      verify(
        mockAuthService.signIn(
          email: 'test@example.com',
          password: 'password123',
        ),
      ).called(1);
    });

    testWidgets('shows error message when authentication fails', (
      WidgetTester tester,
    ) async {
      // Setup mock to throw error
      when(
        mockAuthService.signIn(
          email: 'test@example.com',
          password: 'wrongpassword',
        ),
      ).thenThrow(
        FirebaseAuthException(
          message: 'Invalid credentials',
          code: 'ERROR_INVALID_CREDENTIALS',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(home: AuthPage(authService: mockAuthService)),
      );

      // Enter credentials
      await tester.enterText(
        find.byKey(const ValueKey(AppStrings.emailFieldKey)),
        'test@example.com',
      );
      await tester.enterText(
        find.byKey(const ValueKey(AppStrings.passwordFieldKey)),
        'wrongpassword',
      );

      // Tap login button
      await tester.tap(find.text(AuthConstants.loginButtonText));
      await tester.pumpAndSettle();

      // Verify error message is shown
      expect(find.text('Invalid credentials'), findsOneWidget);
    });
  });

  group('Test Variants', () {
    final isLoginVariants = ValueVariant<bool>({true, false});

    testWidgets('shows correct button text based on mode', (
      WidgetTester tester,
    ) async {
      final isLogin = isLoginVariants.currentValue!;

      await tester.pumpWidget(MaterialApp(home: AuthPage()));

      if (!isLogin) {
        // Switch to register mode if needed
        await tester.tap(find.text(AuthConstants.noAccountText));
        await tester.pump();
      }

      expect(
        find.text(
          isLogin
              ? AuthConstants.loginButtonText
              : AuthConstants.registerButtonText,
        ),
        findsOneWidget,
      );
    }, variant: isLoginVariants);

    testWidgets('shows correct toggle text based on mode', (
      WidgetTester tester,
    ) async {
      final isLogin = isLoginVariants.currentValue!;

      await tester.pumpWidget(MaterialApp(home: AuthPage()));

      if (!isLogin) {
        // Switch to register mode if needed
        await tester.tap(find.text(AuthConstants.noAccountText));
        await tester.pump();
      }

      expect(
        find.text(
          isLogin ? AuthConstants.noAccountText : AuthConstants.haveAccountText,
        ),
        findsOneWidget,
      );
    }, variant: isLoginVariants);
  });
}
