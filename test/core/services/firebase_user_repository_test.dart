import 'package:mockito/mockito.dart';
import 'package:firebase_database/firebase_database.dart';

// Mock classes
class MockFirebaseDatabase extends Mock implements FirebaseDatabase {}

class MockDatabaseReference extends Mock implements DatabaseReference {}

class MockDataSnapshot extends Mock implements DataSnapshot {}

void main() {}
