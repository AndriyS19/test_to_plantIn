import 'package:test_to_plantin/models/user_model.dart';

import 'storage_service.dart';

/// Мок-сервіс аутентифікації з власними користувачами та паролями
class MockAuthService {
  final StorageService _storage = StorageService();

  // Визначте тут своїх користувачів з паролями
  static const Map<String, String> _mockUsers = {
    'admin@plantin.com': 'admin123',
    'user@plantin.com': 'user123',
    'test@example.com': 'password',
    'eve.holt@reqres.in': 'cityslicka',
  };

  Future<User> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (!_mockUsers.containsKey(email)) {
      throw Exception('User not found');
    }

    if (_mockUsers[email] != password) {
      throw Exception('Invalid password');
    }

    final token = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';

    final user = User(email: email, token: token);

    await _storage.saveToken(user.token);
    await _storage.saveEmail(user.email);

    return user;
  }

  Future<bool> isAuthenticated() async {
    return await _storage.hasToken();
  }

  Future<void> logout() async {
    await _storage.clearAll();
  }

  Future<String?> getStoredEmail() async {
    return await _storage.getEmail();
  }

  static List<Map<String, String>> getTestUsers() {
    return _mockUsers.entries.map((e) => {'email': e.key, 'password': e.value}).toList();
  }
}
