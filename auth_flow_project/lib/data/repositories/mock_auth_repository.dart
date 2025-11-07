import '../../domain/models/tokens.dart';
import '../../domain/models/user.dart';
import '../../domain/repositories/auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  @override
  Future<void> activateAccount({required String token}) async {
    await Future.delayed(const Duration(seconds: 1));
    if (token == 'invalid_token') {
      throw Exception('Invalid activation token');
    }
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<(User, Tokens)> googleSignIn({required String idToken}) async {
    await Future.delayed(const Duration(seconds: 1));
    return (
      const User(id: '1', name: 'Google User', email: 'google@example.com'),
      const Tokens(accessToken: 'access_token', refreshToken: 'refresh_token'),
    );
  }

  @override
  Future<(User, Tokens)> login(
      {required String email, required String password}) async {
    await Future.delayed(const Duration(seconds: 1));
    if (email == 'test@example.com' && password == 'password') {
      return (
        const User(id: '1', name: 'Test User', email: 'test@example.com'),
        const Tokens(accessToken: 'access_token', refreshToken: 'refresh_token'),
      );
    } else {
      throw Exception('Invalid credentials');
    }
  }

  @override
  Future<String> refreshToken({required String refreshToken}) async {
    await Future.delayed(const Duration(seconds: 1));
    return 'new_access_token';
  }

  @override
  Future<(User, Tokens)> register(
      {required String name,
      required String email,
      required String password}) async {
    await Future.delayed(const Duration(seconds: 1));
    return (
      User(id: '2', name: name, email: email),
      const Tokens(accessToken: 'access_token', refreshToken: 'refresh_token'),
    );
  }

  @override
  Future<void> resendActivation({required String email}) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<void> resetPassword(
      {required String token, required String newPassword}) async {
    await Future.delayed(const Duration(seconds: 1));
     if (token == 'invalid_token') {
      throw Exception('Invalid reset token');
    }
  }
}
