import '../repositories/user_repository.dart';
import '../services/firebase_user_repository.dart';

class UserRepositoryProvider {
  static UserRepository? _userRepository;

  static UserRepository get instance {
    _userRepository ??= FirebaseUserRepository();
    return _userRepository!;
  }

  static void setUserRepository(UserRepository userRepository) {
    _userRepository = userRepository;
  }
}
