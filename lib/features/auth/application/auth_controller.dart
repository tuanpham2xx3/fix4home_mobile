import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../domain/auth_state.dart';
import '../../../data/repositories/mock_auth_repository.dart';
import '../../../domain/models/user.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return MockAuthRepository();
});

final authControllerProvider =
    AsyncNotifierProvider<AuthController, AuthState>(() {
  return AuthController();
});

class AuthController extends AsyncNotifier<AuthState> {
  late final AuthRepository _authRepository;

  @override
  Future<AuthState> build() async {
    _authRepository = ref.watch(authRepositoryProvider);
    // Auto-login with mock data for development
    return AuthState.authenticated(
      user: User(
        id: 'mock_user_1',
        name: 'Thợ Việt',
        email: 'thoviet@fix4home.com',
      ),
    );
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final (user, _) = await _authRepository.login(email: email, password: password);
      return AuthState.authenticated(user: user);
    });
  }

  Future<void> register(String name, String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
       await _authRepository.register(name: name, email: email, password: password);
      // After registration, the user needs to activate the account,
      // so we don't log them in immediately.
      return const AuthState.unauthenticated();
    });
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      // In a real app, you'd clear stored tokens here
      return const AuthState.unauthenticated();
    });
  }

  Future<void> activateAccount(String token) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _authRepository.activateAccount(token: token);
      return const AuthState.unauthenticated(); // Stay on login screen
    });
  }

  Future<void> forgotPassword(String email) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _authRepository.forgotPassword(email: email);
      return const AuthState.unauthenticated();
    });
  }

  Future<void> resetPassword(String token, String newPassword) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _authRepository.resetPassword(token: token, newPassword: newPassword);
      return const AuthState.unauthenticated();
    });
  }
}
