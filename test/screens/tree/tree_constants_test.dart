import 'package:flutter_test/flutter_test.dart';
import 'package:phone_away/screens/tree/tree_constants.dart';

void main() {
  group('TreeConstants Tests', () {
    test('dimension constants have correct values', () {
      expect(TreeConstants.baseTreeSize, equals(450.0));
    });

    test('error message constants have correct values', () {
      expect(TreeConstants.unknownErrorMessage, equals('Unknown error'));
    });

    test('dimension constants are positive', () {
      expect(TreeConstants.baseTreeSize, greaterThan(0));
    });

    test('base tree size is reasonable', () {
      // Should be large enough to be visible but not too large for mobile screens
      expect(TreeConstants.baseTreeSize, greaterThanOrEqualTo(300.0));
      expect(TreeConstants.baseTreeSize, lessThanOrEqualTo(600.0));
    });

    test('error message is not empty', () {
      expect(TreeConstants.unknownErrorMessage, isNotEmpty);
    });

    test('error message is descriptive', () {
      expect(TreeConstants.unknownErrorMessage, contains('error'));
    });

    test('error message follows proper capitalization', () {
      expect(TreeConstants.unknownErrorMessage, startsWith('U'));
    });

    test('base tree size is a round number', () {
      expect(TreeConstants.baseTreeSize % 50, equals(0.0));
    });

    test('constants are properly typed', () {
      expect(TreeConstants.baseTreeSize, isA<double>());
      expect(TreeConstants.unknownErrorMessage, isA<String>());
    });
  });
}
