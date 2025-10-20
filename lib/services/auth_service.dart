import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test_to_plantin/models/user_model.dart';
import 'storage_service.dart';

class AuthService {
  static const String _baseUrl = 'https://reqres.in/api';
  final StorageService _storage = StorageService();

  Future<User> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = User(email: email, token: data['token'] ?? '');

        await _storage.saveToken(user.token);
        await _storage.saveEmail(user.email);

        return user;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['error'] ?? 'Login failed');
      }
    } catch (e) {
      if (e.toString().contains('Exception:')) {
        rethrow;
      }
      throw Exception('Network error. Please check your connection.');
    }
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
}
