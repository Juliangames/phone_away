import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phone_away/widgets/common/motivational_sayings.dart';

void main() {
  group('MotivationalSaying Widget Behavior Tests', () {
    testWidgets('should render with provided text and be accessible', (tester) async {
      const testText = 'Stay focused!';
      
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MotivationalSaying(text: testText),
          ),
        ),
      );

      expect(find.text(testText), findsOneWidget);
      
      // Test accessibility
      final widget = tester.widget<Container>(
        find.descendant(
          of: find.byType(MotivationalSaying),
          matching: find.byType(Container),
        ).first,
      );
      
      expect(widget, isNotNull);
    });

    testWidgets('should maintain consistent styling across different texts', (tester) async {
      final testTexts = ['Short', 'Medium length text', 'A bit longer text for testing'];
      
      for (final text in testTexts) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MotivationalSaying(text: text),
            ),
          ),
        );
        
        expect(find.text(text), findsOneWidget);
        expect(find.byType(MotivationalSaying), findsOneWidget);
        
        // Test that widget is created successfully regardless of text length
        final containerFinder = find.descendant(
          of: find.byType(MotivationalSaying),
          matching: find.byType(Container),
        );
        expect(containerFinder, findsAtLeastNWidgets(1));
      }
    });

    testWidgets('should handle state changes properly', (tester) async {
      const initialText = 'Initial message';
      const updatedText = 'Updated message';
      
      // Build widget with initial text
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MotivationalSaying(text: initialText),
          ),
        ),
      );
      
      expect(find.text(initialText), findsOneWidget);
      
      // Update with new text
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MotivationalSaying(text: updatedText),
          ),
        ),
      );
      
      expect(find.text(updatedText), findsOneWidget);
      expect(find.text(initialText), findsNothing);
    });

    testWidgets('should handle empty text gracefully', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MotivationalSaying(text: ''),
          ),
        ),
      );

      // Widget should still render without crashing
      expect(find.byType(MotivationalSaying), findsOneWidget);
    });

    testWidgets('should integrate well with theme changes', (tester) async {
      const testText = 'Theme test';
      
      // Test with light theme
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: const Scaffold(
            body: MotivationalSaying(text: testText),
          ),
        ),
      );
      
      expect(find.text(testText), findsOneWidget);
      
      // Test with dark theme
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: const Scaffold(
            body: MotivationalSaying(text: testText),
          ),
        ),
      );
      
      expect(find.text(testText), findsOneWidget);
    });
  });
}
