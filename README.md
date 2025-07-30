# 🌳 PhoneAway - Digital Detox App

A Flutter app that helps users break away from constant smartphone usage and create productive focus periods.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/firebase-ffca28?style=for-the-badge&logo=firebase&logoColor=black)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![Test Coverage](https://img.shields.io/badge/coverage-32.6%25-red?style=for-the-badge)
![Build Status](https://img.shields.io/github/actions/workflow/status/Juliangames/phone_away/test-coverage.yml?style=for-the-badge)

## 📱 About PhoneAway

### Abstract

PhoneAway is a gamified digital detox application designed to combat smartphone addiction and promote mindful technology usage. The app employs a Pomodoro-style timer system combined with virtual tree growth mechanics to incentivize users to take regular breaks from their devices. By transforming focus sessions into a rewarding experience through apple collection and social comparison features, PhoneAway addresses the growing need for digital wellness tools in our hyperconnected society.

### Detailed Description

PhoneAway represents a comprehensive solution to digital overwhelm, targeting the widespread issue of compulsive smartphone checking and constant connectivity. The application transforms the challenge of staying focused into an engaging, game-like experience where users nurture a virtual tree by completing timed focus sessions.

The core mechanic revolves around customizable timer sessions (defaulting to 25-minute Pomodoro intervals) during which users are encouraged to put their phones aside. Successful completion of these sessions rewards users with virtual apples that contribute to their growing digital tree, creating a visual representation of their progress toward healthier digital habits.

The social component allows users to connect with friends, share progress, and maintain accountability through gentle competition and mutual encouragement. This peer support system leverages social psychology principles to reinforce positive behavior change.

### Problem Statement

Modern smartphone usage patterns have created significant challenges:

- **Attention Fragmentation**: Average users check their phones 96 times per day, severely impacting sustained concentration
- **Productivity Loss**: Constant notifications and the urge to check devices interrupt deep work and learning
- **Mental Health Impact**: Excessive screen time correlates with increased anxiety, depression, and sleep disorders
- **Social Disconnect**: Paradoxically, while more connected than ever, many experience loneliness and reduced face-to-face interaction quality
- **Lack of Mindful Usage**: Most users underestimate their actual screen time and lack awareness of their digital consumption patterns

PhoneAway addresses these issues by providing structured, gamified interventions that promote intentional technology use rather than elimination.

### Target Personas

#### Primary Persona: "The Overwhelmed Student" (Age 18-25)

- **Characteristics**: University students struggling with academic focus due to social media distractions
- **Pain Points**: Difficulty concentrating during study sessions, FOMO-driven phone checking, poor time management
- **Goals**: Improve academic performance, develop better study habits, maintain social connections without distraction
- **Tech Comfort**: High smartphone proficiency, active on multiple social platforms

#### Secondary Persona: "The Productivity-Seeking Professional" (Age 26-35)

- **Characteristics**: Young professionals seeking work-life balance and improved focus
- **Pain Points**: Constant work notifications, difficulty with deep work, feeling overwhelmed by digital demands
- **Goals**: Increase workplace productivity, establish clear boundaries between work and personal time
- **Tech Comfort**: Moderate to high, uses productivity apps and digital tools regularly

#### Tertiary Persona: "The Mindful Parent" (Age 30-45)

- **Characteristics**: Parents wanting to model healthy technology habits for their children
- **Pain Points**: Guilt about phone usage around children, desire to be more present during family time
- **Goals**: Reduce phone dependency, increase quality family interactions, teach children healthy tech habits
- **Tech Comfort**: Moderate, values simplicity and purposeful technology use

### ✨ Key Features

- **🕐 Focus Timer**: Adjustable timers for concentration phases (default: 25 minutes)
- **🌳 Virtual Tree**: Collect apples for completed sessions and grow a digital tree
- **👥 Friends System**: Connect with friends and share your progress
- **🔔 Smart Notifications**: Notifications during concentration phases
- **⚙️ User Profiles**: Customizable profiles with avatar upload
- **🎯 Gamification**: Reward system with apples and rotten apples for early termination
- **🌙 Dark Mode**: Full dark mode support with Light, Dark, and System theme options
- **📱 Offline Support**: Full timer functionality works without internet connection
- **🔄 Auto-Sync**: Automatic synchronization when connection is restored
- **⚠️ Error Handling**: Comprehensive timeout and connection error management

## 🌐 Offline Support & Error Handling

PhoneAway is designed with robust offline capabilities and comprehensive error handling to ensure a seamless user experience regardless of network conditions.

### 📱 Offline Functionality

#### **Core Timer Operations**

- **Complete Offline Mode**: Timer sessions work entirely without internet connection
- **Local State Persistence**: Timer state, duration, and progress saved locally
- **Offline Session Completion**: Users can complete focus sessions and collect apples offline
- **Background Processing**: Timer continues running even when app is backgrounded

#### **Data Synchronization**

- **Auto-Sync on Reconnect**: Offline data automatically syncs when connection is restored
- **Queue Management**: Offline actions queued and processed in order upon reconnection
- **Conflict Resolution**: Intelligent merging of offline and online data states
- **Sync Status Indicators**: Visual feedback showing sync progress and connection status

#### **Offline Data Storage**

- **SharedPreferences**: Critical timer data and user preferences stored locally
- **Session Caching**: Completed sessions cached until successful upload
- **Avatar Caching**: Profile images cached for offline viewing
- **Friend Data**: Basic friend information cached for offline access

### ⚠️ Error Handling System

#### **Network Error Management**

- **Timeout Handling**: 10-second default timeout with 5-second quick timeout option
- **Connection Detection**: Real-time network status monitoring and user feedback
- **Graceful Degradation**: App functionality maintained with limited features during outages
- **Retry Mechanisms**: Automatic retry with exponential backoff for failed operations

#### **User-Friendly Error States**

- **Empty State Widgets**: Informative screens for no data, connection issues, and timeouts
- **Error Notifications**: Non-intrusive SnackBar notifications for temporary issues
- **Recovery Actions**: Clear "Retry" and "Try Again" buttons for user-initiated recovery
- **Connection Status Banner**: Persistent banner showing connection restoration

#### **Error Categories**

- **Timeout Errors**: "Request timed out - Check your internet connection"
- **Connection Errors**: "No internet connection - Check your network settings"
- **General Network Errors**: "Network error - [specific error message]"
- **Unexpected Errors**: "An unexpected error occurred - Please try again"

### 🔧 Technical Implementation

#### **Network Service Architecture**

```dart
class NetworkService {
  // Timeout wrapper for all network operations
  Future<T> executeWithTimeout<T>(Future<T> operation, {Duration timeout});

  // Connection monitoring
  Stream<bool> get connectionStatus;

  // Custom exception hierarchy
  // - NetworkTimeoutException
  // - NetworkConnectionException
  // - NetworkException
}
```

#### **Error Handler System**

```dart
class ErrorHandler {
  // Unified error display
  static void showErrorSnackBar(BuildContext context, Object error);

  // Error widget generation
  static Widget getErrorWidget(Object error, VoidCallback onRetry);

  // Network operation wrapper
  static Future<T> executeWithErrorHandling<T>(Future<T> operation);
}
```

#### **Sync Manager**

```dart
class SyncManager {
  // Background synchronization
  static Future<void> syncOfflineData();

  // Queue management
  static void queueOfflineUpdate(Map<String, dynamic> data);

  // Conflict resolution
  static Map<String, dynamic> mergeOfflineData(local, remote);
}
```

### 📊 Offline Capabilities by Feature

| Feature          | Offline Support        | Sync Behavior              |
| ---------------- | ---------------------- | -------------------------- |
| Timer Sessions   | ✅ Full Support        | Auto-sync on reconnect     |
| Apple Collection | ✅ Local Storage       | Synced with session data   |
| Tree Growth      | ✅ Cached State        | Updated from synced apples |
| Friend List      | 📱 Cached View         | Refreshed on reconnect     |
| Profile Updates  | ❌ Requires Connection | Queued for later upload    |
| Friend Invites   | ❌ Requires Connection | Real-time only             |

### 🎯 User Experience Benefits

- **Uninterrupted Focus**: Timer sessions never fail due to connectivity issues
- **Reliable Progress**: Apple collection and tree growth work offline
- **Transparent Recovery**: Users informed of sync status and connection issues
- **Predictable Behavior**: Consistent app behavior regardless of network state
- **Battery Efficiency**: Reduced network polling and intelligent sync scheduling

## 🚀 Technology Stack

- **Framework**: Flutter 3.3.0+
- **Backend**: Firebase (Authentication, Realtime Database, Storage)
- **State Management**: Provider for theme management + Flutter Hooks + Local State
- **Theme System**: Material 3 ColorScheme with comprehensive dark mode support
- **Notifications**: Flutter Local Notifications
- **UI Components**: Sleek Circular Slider, Custom Widgets
- **Offline Storage**: SharedPreferences + Local Caching
- **Network Handling**: Custom NetworkService with timeout management
- **Error Management**: Centralized ErrorHandler with user-friendly messages
- **Platforms**: iOS, Android, Web

## 📋 Prerequisites

- Flutter SDK 3.3.0 or higher
- Dart SDK
- Firebase project with enabled services:
  - Authentication
  - Realtime Database
  - Storage
- Xcode (for iOS)
- Android Studio (for Android)

## 🛠️ Installation

1. **Clone repository**

   ```bash
   git clone <repository-url>
   cd phone_away
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Configure Firebase**

   - Create Firebase project
   - Add `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Enable Firebase services (Auth, Database, Storage)

4. **Run the app**
   ```bash
   flutter run
   ```

## 📺 Screen Overview & Functionality

### 🔐 Authentication Screen (`auth/auth_page.dart`)

- **Primary Function**: User registration and login management
- **Key Features**:
  - Email/password authentication via Firebase Auth
  - Form validation with real-time feedback
  - Responsive design adapting to different screen sizes
  - Secure credential handling
- **User Flow**: Entry point for new and returning users to access the app

### ⏱️ Timer Screen (`timer/timer_page.dart`)

- **Primary Function**: Core focus session management
- **Key Features**:
  - Circular slider for time selection (0-50 minutes)
  - Visual progress indicator during active sessions
  - Start/stop controls with immediate feedback
  - Persistent timer state across app sessions
  - Integration with notification system
- **User Flow**: Users set desired focus duration, start sessions, and receive rewards upon completion

### 🌳 Tree Visualization Screen (`tree/tree_page.dart`)

- **Primary Function**: Progress visualization and achievement display
- **Key Features**:
  - Dynamic tree growth based on collected apples
  - Visual representation of both successful (apples) and failed (rotten apples) sessions
  - Responsive tree scaling and apple positioning
  - Achievement milestone indicators
- **User Flow**: Users view their cumulative progress and feel motivated by visual growth

### 👥 Friends Screen (`friends/friends_page.dart`)

- **Primary Function**: Social connectivity and progress sharing
- **Key Features**:
  - Friend invitation system via deep links
  - Real-time friend list with avatar display
  - Progress comparison and leaderboards
  - Share functionality for social engagement
  - Friend profile viewing with statistics
- **User Flow**: Users connect with peers, share invitation links, and compare achievements

### ⚙️ Settings Screen (`settings/settings_page.dart`)

- **Primary Function**: User profile management and app customization
- **Key Features**:
  - Profile editing with avatar upload capability
  - Username customization
  - **Theme Selection**: Choose between Light, Dark, and System theme modes
  - **Automatic System Sync**: Dark mode automatically follows system appearance settings
  - Notification preferences toggle
  - Account management (logout functionality)
  - Hidden easter egg triggers
- **User Flow**: Users personalize their experience, choose preferred appearance mode, and manage account preferences

## 🏛️ Application Architecture

### Architectural Pattern

PhoneAway implements a **layered architecture** combined with **service-oriented design** patterns, ensuring separation of concerns, maintainability, and scalability. The architecture follows Flutter best practices with clear data flow and state management.

### Layer Descriptions

#### 1. **Presentation Layer**

- **Responsibility**: UI rendering, user interaction handling, state presentation
- **Components**:
  - `Screens/`: Page-level widgets managing specific app sections
  - `Widgets/`: Reusable UI components for consistent design
  - `Theme/`: Centralized styling and design system
- **State Management**: Local state with `setState()` and `StreamBuilder` for reactive updates

#### 2. **Business Logic Layer**

- **Responsibility**: Core application logic, data processing, business rules
- **Components**:
  - `Services/`: Singleton services managing specific domains (timer, authentication, database)
  - `Models/`: Data structures and business entities
  - `Helpers/`: Utility functions and cross-cutting concerns
- **Patterns**: Service locator pattern for dependency management

#### 3. **Data Access Layer**

- **Responsibility**: External data source interaction, caching, offline support
- **Components**:
  - Firebase SDK integration for authentication and real-time data
  - Local storage via SharedPreferences for user settings and timer state
  - Repository pattern (prepared for future expansion)

### Key Architectural Decisions

### Key Architectural Decisions

#### **Service-Oriented Architecture**

- **TimerService**: Manages timer state, notifications, and persistence with offline support
- **DBService**: Handles all Firebase Realtime Database operations with timeout handling
- **StorageService**: Manages file uploads and avatar handling with error recovery
- **NetworkService**: Centralized network operations with timeout and retry logic
- **ErrorHandler**: Unified error handling and user feedback system
- **SyncManager**: Background synchronization and offline data management
- **Singleton Pattern**: Ensures single instances of critical services

#### **State Management Strategy**

- **Local State**: UI-specific state managed within individual widgets
- **Stream-Based Updates**: Real-time data flow using Dart Streams for timer updates
- **Event-Driven Communication**: Services communicate through callback mechanisms

#### **Data Persistence Strategy**

- **Remote State**: User profiles, friend connections, and progress stored in Firebase
- **Local State**: Timer sessions, user preferences cached locally for offline functionality
- **Hybrid Approach**: Critical data synced to cloud with local fallbacks
- **Offline-First Design**: Timer functionality works completely offline with automatic sync
- **Timeout Handling**: 10-second default timeout with graceful degradation
- **Error Recovery**: Automatic retry mechanisms and user-friendly error messages

#### **Scalability Considerations**

- **Modular Structure**: Clear separation allows for independent feature development
- **Service Abstraction**: Business logic isolated from UI enables testing and refactoring
- **Plugin Architecture**: External dependencies (Firebase, notifications) abstracted through services

## 🎮 How it Works

### Starting a Focus Session

1. Open the Timer tab
2. Set your desired time (using the circular slider)
3. Press "Start" to begin the focus session
4. A notification will inform you about the active concentration phase

### Reward System

- **🍎 Collect Apples**: Earn an apple for each successfully completed session
- **🍎💔 Rotten Apples**: Get these when you terminate a session prematurely
- **🌳 Tree Growth**: Your virtual tree grows with each collected apple

### Adding Friends

1. Go to the Friends tab
2. Share your invitation link or use deep links
3. See your friends' progress and motivate each other

## 🔧 Key Dependencies

```yaml
dependencies:
  flutter: sdk: flutter
  firebase_core: ^3.14.0
  firebase_auth: ^5.5.4
  firebase_database: ^11.3.6
  firebase_storage: ^12.4.7
  flutter_local_notifications: ^17.2.1+2
  provider: ^6.0.5  # Theme state management
  sleek_circular_slider: ^2.0.1
  share_plus: ^11.0.0
  image_picker: ^0.8.7+4
  cached_network_image: ^3.2.3
  permission_handler: ^11.3.1
  app_links: ^6.4.0
```

## 🎨 Design Features

- **Modern UI**: Clean and intuitive user interface
- **Responsive Design**: Works on different screen sizes
- **Material 3 Design System**: Latest Material Design principles with dynamic theming
- **Comprehensive Dark Mode**: Full dark mode support that follows system settings
- **Theme Options**: Light, Dark, and System automatic themes with persistent preferences
- **Custom ColorScheme**: Theme-aware components using Material 3 color system
- **Consistent Navigation**: Enhanced bottom navigation with better tab highlighting
- **Animations**: Smooth transitions and appealing visualizations

## 🔐 Security & Privacy

- Firebase Authentication for secure login
- Encrypted data transmission
- Local storage of sensitive timer data
- Permission-based notifications

## 🧪 Testing & Quality Assurance

This project maintains high code quality through automated testing and continuous integration.

### Test Coverage

The current test coverage is automatically tracked and updated with each commit. Our testing strategy includes:

- **Unit Tests**: Core business logic and services
- **Widget Tests**: UI components and user interactions
- **Integration Tests**: End-to-end user workflows
- **Mock Testing**: Firebase services and external dependencies

### Running Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Update coverage badge (requires lcov)
./scripts/update_coverage.sh

# Generate HTML coverage report
genhtml coverage/lcov.info -o coverage/html
```

### Test Structure

```
test/
├── auth_page_test.dart          # Authentication UI tests
├── widget_test.dart             # Basic widget tests
└── mocks/                       # Mock implementations
    ├── mock_auth_service.dart
    └── mock_user_repository.dart
```

### Continuous Integration

- Automated testing on every pull request
- Coverage reports generated and updated automatically
- Badge updates reflect current code coverage status

## 🧪 Easter Eggs

The app contains hidden features - find them out! 🧙‍♂️

## 👥 Team

Developed as part of the Mobile Applications course at HTWG Konstanz.

## 📄 License

This project was created for educational purposes.

## 🤝 Contributing

1. Fork the repository
2. Create a Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📞 Support

For questions or issues, please create an issue in the repository.

---

_Less smartphone, more life! 🌱_
