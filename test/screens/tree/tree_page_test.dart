import 'package:flutter_test/flutter_test.dart';
import 'package:phone_away/screens/tree/tree_constants.dart';

void main() {
  group('TreeConstants Tests', () {
    test('essential values exist', () {
      expect(TreeConstants.baseTreeSize, greaterThan(0));
      expect(TreeConstants.unknownErrorMessage, isNotEmpty);
    });
  });
}