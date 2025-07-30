import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';

/// Initializes Firebase for tests
Future<void> setupFirebaseForTest() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with test configuration
  if (!Firebase.apps.any((app) => app.name == '[DEFAULT]')) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "test-api-key",
        appId: "test-app-id",
        messagingSenderId: "123456789",
        projectId: "test-project",
        storageBucket: "test-project.appspot.com",
        databaseURL: "https://test-project.firebaseio.com",
      ),
    );
  }
}

/// Tears down Firebase after tests
Future<void> teardownFirebaseForTest() async {
  for (final app in Firebase.apps) {
    await app.delete();
  }
}
