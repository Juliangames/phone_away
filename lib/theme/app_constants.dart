import 'package:flutter/material.dart';

class AppDimensions {
  // Common spacing
  static const double horizontalPadding = 20.0;
  static const double verticalPadding = 20.0;
  static const double sectionSpacing = 20.0;
  static const double smallSpacing = 12.0;
  static const double mediumSpacing = 16.0;
  static const double beforeLogoutSpacing = 30.0;
  static const double largeSpacing = 24.0;
  static const double extraLargeSpacing = 40.0;

  // Border radius
  static const double borderRadius = 12.0;
  static const double fabBorderRadius = 100.0;

  // AppBar
  static const double appBarHeight = 80.0;
  static const double appBarTopPadding = 16.0;

  // Buttons
  static const double buttonVerticalPadding = 16.0;
  static const double fabWidth = 154.0;
  static const double fabHeight = 54.0;

  // Form elements
  static const double textFieldSpacing = 16.0;
  static const double textFieldVerticalPadding = 8.0;
  static const double textFieldWidth = 150.0;

  // Container padding
  static const double containerPaddingVertical = 10.0;
  static const double containerPaddingHorizontal = 12.0;
  static const double largeContainerPaddingVertical = 20.0;
  static const double containerMarginVertical = 6.0;

  // Avatar and icons
  static const double circleAvatarRadius = 16.0;
  static const double largeAvatarRadius = 32.0;
  static const double iconSize = 18.0;
  static const double largeIconSize = 32.0;

  // Slider and progress indicators
  static const double strokeWidth = 8.0;
  static const double sliderSize = 340.0;
}

class AppTypography {
  // Font sizes
  static const double titleFontSize = 64.0;
  static const double headingFontSize = 16.0;
  static const double bodyFontSize = 14.0;
  static const double buttonFontSize = 16.0;
  static const double timerFontSize = 32.0;

  // Font weights
  static const FontWeight titleFontWeight = FontWeight.w800;
  static const FontWeight boldWeight = FontWeight.bold;
}

class AppValues {
  // Form validation
  static const int minimumPasswordLength = 6;

  // Layout proportions
  static const int titleFlexValue = 2;
  static const int formFlexValue = 3;

  // Timer defaults
  static const int defaultTimerSeconds = 1500; // 25 minutes
  static const double minSliderValue = 0.0;
  static const double maxSliderValue = 3000.0;
  static const double startAngle = 270.0;
  static const double angleRange = 360.0;

  // Time formatting
  static const int secondsPerMinute = 60;
  static const int padLength = 2;

  // Default values
  static const int defaultApples = 0;
  static const int defaultRottenApples = 0;
  static const int rankOffset = 1;

  // Business logic values
  static const int maxTimerMinutes = 90;
  static const int easterEggTriggerCount = 10;
  static const int easterEggResetCount = 0;
  static const String defaultUsername = 'Unknown User';
}

class AppStrings {
  // Common strings
  static const String padCharacter = '0';
  static const String timeSeparator = ':';
  static const String nullValue = 'null';
  static const String defaultUsername = '';
  static const String defaultAvatar = '';
  static const String unknownErrorMessage = 'An unknown error occurred.';

  // Form field keys
  static const String emailFieldKey = 'email';
  static const String passwordFieldKey = 'password';

  // Database keys
  static const String applesKey = 'apples';
  static const String rottenApplesKey = 'rotten_apples';
  static const String usernameKey = 'username';
  static const String idKey = 'id';
  static const String nameKey = 'name';
  static const String isCurrentUserKey = 'isCurrentUser';
  static const String avatarUrlKey = 'avatarUrl';
  static const String rankKey = 'rank';
  static const String avatarKey = 'avatar';
  static const String notificationsKey = 'notifications';

  // Common UI text
  static const String cancelText = 'Cancel';
  static const String hideText = 'Hide';

  // Default values
  static const bool defaultNotifications = true;
}
