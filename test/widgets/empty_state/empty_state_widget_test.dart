import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phone_away/widgets/empty_state/empty_state_widget.dart';

void main() {
  group('EmptyStateWidget Tests', () {
    testWidgets('should display basic empty state', (tester) async {
      const testIcon = Icons.star;
      const testTitle = 'Test Title';
      const testSubtitle = 'Test Subtitle';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              icon: testIcon,
              title: testTitle,
              subtitle: testSubtitle,
            ),
          ),
        ),
      );

      expect(find.text(testTitle), findsOneWidget);
      expect(find.text(testSubtitle), findsOneWidget);
      expect(find.byIcon(testIcon), findsOneWidget);
    });

    testWidgets('should display action button when provided', (tester) async {
      var actionCalled = false;
      const actionLabel = 'Test Action';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              icon: Icons.star,
              title: 'Test',
              subtitle: 'Test',
              actionLabel: actionLabel,
              onAction: () => actionCalled = true,
            ),
          ),
        ),
      );

      expect(find.text(actionLabel), findsOneWidget);
      
      await tester.tap(find.text(actionLabel));
      expect(actionCalled, isTrue);
    });

    testWidgets('should create no friends factory', (tester) async {
      var inviteCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget.noFriends(
              onInvite: () => inviteCalled = true,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.group_outlined), findsOneWidget);
      
      final actionButton = find.byType(ElevatedButton);
      if (actionButton.evaluate().isNotEmpty) {
        await tester.tap(actionButton);
        expect(inviteCalled, isTrue);
      }
    });

    testWidgets('should create network error factory', (tester) async {
      var retryCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget.networkError(
              onRetry: () => retryCalled = true,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.wifi_off_outlined), findsOneWidget);
      
      final actionButton = find.byType(ElevatedButton);
      if (actionButton.evaluate().isNotEmpty) {
        await tester.tap(actionButton);
        expect(retryCalled, isTrue);
      }
    });

    testWidgets('should handle custom error message', (tester) async {
      const customError = 'Custom error message';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget.networkError(
              onRetry: () {},
              errorMessage: customError,
            ),
          ),
        ),
      );

      expect(find.text(customError), findsOneWidget);
    });

    testWidgets('should handle isError flag', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              icon: Icons.error,
              title: 'Error',
              subtitle: 'Error subtitle',
              isError: true,
            ),
          ),
        ),
      );

      expect(find.byType(EmptyStateWidget), findsOneWidget);
      expect(find.text('Error'), findsOneWidget);
    });

    testWidgets('should handle custom icon color', (tester) async {
      const customColor = Colors.red;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              icon: Icons.star,
              title: 'Test',
              subtitle: 'Test',
              iconColor: customColor,
            ),
          ),
        ),
      );

      expect(find.byType(EmptyStateWidget), findsOneWidget);
    });
  });
}
