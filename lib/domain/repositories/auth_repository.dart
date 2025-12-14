import '../models/user.dart';
import '../models/tokens.dart';
import '../models/verify_activation_token_response.dart';
import '../models/check_activation_status_response.dart';

abstract class AuthRepository {
  Future<(User, Tokens)> register({
    required String name,
    required String email,
    required String password,
  });

  Future<(User, Tokens)> login({
    required String email,
    required String password,
  });

  Future<(User, Tokens)> googleSignIn({
    required String idToken,
  });

  Future<void> activateAccount({
    required String token,
  });

  Future<VerifyActivationTokenResponse> verifyActivationToken({
    required String token,
  });

  Future<CheckActivationStatusResponse> checkActivationStatus({
    required String email,
  });

  Future<void> resendActivation({
    required String email,
  });

  Future<void> forgotPassword({
    required String email,
  });

  Future<void> resetPassword({
    required String token,
    required String newPassword,
  });

  Future<String> refreshToken({
    required String refreshToken,
  });
}
