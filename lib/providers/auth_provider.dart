import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_to_plantin/services/moc_auth_service.dart';
import '../services/auth_service.dart';

// ВИБІР СЕРВІСУ: Змініть тут для перемикання між реальним API та моком
// Варіант 1: Реальний API (reqres.in)
// final authServiceProvider = Provider((ref) => AuthService());

// Варіант 2: Мок-сервіс з власними паролями
final authServiceProvider = Provider((ref) => MockAuthService());

final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<bool>>(
  (ref) => AuthNotifier(ref.read(authServiceProvider)),
);

class AuthNotifier extends StateNotifier<AsyncValue<bool>> {
  // Використовуємо dynamic щоб підтримувати обидва типи сервісів
  final dynamic _authService;

  AuthNotifier(this._authService) : super(const AsyncValue.loading()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final isAuthenticated = await _authService.isAuthenticated();
      state = AsyncValue.data(isAuthenticated);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await _authService.login(email, password);
      state = const AsyncValue.data(true);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      state = const AsyncValue.data(false);
      rethrow;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    state = const AsyncValue.data(false);
  }

  Future<String?> getUserEmail() async {
    return await _authService.getStoredEmail();
  }
}
