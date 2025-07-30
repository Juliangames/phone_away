import 'package:flutter_test/flutter_test.dart';
import 'package:phone_away/theme/app_constants.dart';

void main() {
  group('AppDimensions Tests', () {
    test('should have correct horizontal padding', () {
      expect(AppDimensions.horizontalPadding, 20.0);
    });

    test('should have correct vertical padding', () {
      expect(AppDimensions.verticalPadding, 20.0);
    });

    test('should have all spacing constants defined', () {
      expect(AppDimensions.sectionSpacing, 20.0);
      expect(AppDimensions.smallSpacing, 12.0);
      expect(AppDimensions.mediumSpacing, 16.0);
      expect(AppDimensions.largeSpacing, 24.0);
      expect(AppDimensions.extraLargeSpacing, 40.0);
      expect(AppDimensions.beforeLogoutSpacing, 30.0);
    });

    test('should have border radius constants', () {
      expect(AppDimensions.borderRadius, 12.0);
      expect(AppDimensions.fabBorderRadius, 100.0);
    });

    test('should have app bar dimensions', () {
      expect(AppDimensions.appBarHeight, 80.0);
      expect(AppDimensions.appBarTopPadding, 16.0);
    });

    test('should have button dimensions', () {
      expect(AppDimensions.buttonVerticalPadding, 16.0);
      expect(AppDimensions.fabWidth, 154.0);
      expect(AppDimensions.fabHeight, 54.0);
    });

    test('should have text field dimensions', () {
      expect(AppDimensions.textFieldSpacing, 16.0);
      expect(AppDimensions.textFieldVerticalPadding, 8.0);
      expect(AppDimensions.textFieldWidth, 150.0);
    });

    test('should have container dimensions', () {
      expect(AppDimensions.containerPaddingVertical, 10.0);
      expect(AppDimensions.containerPaddingHorizontal, 12.0);
      expect(AppDimensions.largeContainerPaddingVertical, 20.0);
      expect(AppDimensions.containerMarginVertical, 6.0);
    });

    test('should have avatar and icon sizes', () {
      expect(AppDimensions.circleAvatarRadius, 16.0);
      expect(AppDimensions.largeAvatarRadius, 32.0);
      expect(AppDimensions.iconSize, 18.0);
      expect(AppDimensions.largeIconSize, 32.0);
    });

    test('should have slider and progress dimensions', () {
      expect(AppDimensions.strokeWidth, 8.0);
      expect(AppDimensions.sliderSize, 340.0);
    });
  });
}
