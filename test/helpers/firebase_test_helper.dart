import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';

// Mock Firebase setup for tests
class MockFirebaseApp implements FirebaseApp {
  @override
  String get name => '[DEFAULT]';

  @override
  FirebaseOptions get options => const FirebaseOptions(
        apiKey: 'test-api-key',
        appId: 'test-app-id',
        messagingSenderId: 'test-sender-id',
        projectId: 'test-project-id',
      );

  @override
  bool get isAutomaticDataCollectionEnabled => false;

  @override
  Future<void> delete() async {}

  @override
  Future<void> setAutomaticDataCollectionEnabled(bool enabled) async {}

  @override
  Future<void> setAutomaticResourceManagementEnabled(bool enabled) async {}
}

/// Setup Firebase for tests
Future<void> setupFirebaseForTest() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase with mock options
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'test-api-key',
        appId: 'test-app-id',
        messagingSenderId: 'test-sender-id',
        projectId: 'test-project-id',
      ),
    );
  } catch (e) {
    // Firebase might already be initialized, ignore the error
    print('Firebase initialization warning: $e');
  }
}

/// Teardown Firebase after tests
Future<void> tearDownFirebaseForTest() async {
  try {
    await Firebase.app().delete();
  } catch (e) {
    // Ignore deletion errors in tests
    print('Firebase deletion warning: $e');
  }
}
