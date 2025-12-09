import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../domain/auth_state.dart';
import '../../../data/repositories/api_auth_repository.dart';
import '../../../domain/models/user.dart';
import '../../../domain/models/verify_activation_token_response.dart';
import '../../../core/services/token_storage_service.dart';
import '../../../core/services/api_client.dart';
import '../../../core/services/device_id_service.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return ApiAuthRepository(
    ref.watch(dioProvider),
    ref.watch(deviceIdServiceProvider),
    ref.watch(tokenStorageServiceProvider),
  );
});

final authControllerProvider =
    AsyncNotifierProvider<AuthController, AuthState>(() {
  return AuthController();
});

class AuthController extends AsyncNotifier<AuthState> {
  late final AuthRepository _authRepository;
  late final TokenStorageService _tokenStorageService;

  @override
  Future<AuthState> build() async {
    _authRepository = ref.watch(authRepositoryProvider);
    _tokenStorageService = ref.watch(tokenStorageServiceProvider);
    
    // DEBUG MODE: Skip login - always return authenticated state
    // TODO: Remove this for production
    return AuthState.authenticated(
      user: const User(
        id: 'debug-user-1',
        name: 'Debug User',
        email: 'debug@example.com',
      ),
    );
    
    // Original authentication check (commented out for debugging)
    /*
    // Check if we have stored tokens
    final tokens = await _tokenStorageService.getTokens();
    if (tokens != null && tokens.accessToken.isNotEmpty) {
      try {
        // Try to decode user info from JWT token
        if (JwtDecoder.isExpired(tokens.accessToken)) {
          // Token is expired, try to refresh
          if (tokens.refreshToken.isNotEmpty) {
            try {
              final newAccessToken = await _authRepository.refreshToken(
                refreshToken: tokens.refreshToken,
              );
              // Retry decoding with new token
              return _decodeUserFromToken(newAccessToken);
            } catch (e) {
              // Refresh failed, clear tokens and return unauthenticated
              await _tokenStorageService.clearTokens();
              return const AuthState.unauthenticated();
            }
          } else {
            // No refresh token, clear and return unauthenticated
            await _tokenStorageService.clearTokens();
            return const AuthState.unauthenticated();
          }
        } else {
          // Token is valid, decode user info
          return _decodeUserFromToken(tokens.accessToken);
        }
      } catch (e) {
        // If decoding fails, clear tokens and return unauthenticated
        await _tokenStorageService.clearTokens();
        return const AuthState.unauthenticated();
      }
    }
    
    // No tokens found, return unauthenticated
    return const AuthState.unauthenticated();
    */
  }

  AuthState _decodeUserFromToken(String accessToken) {
    try {
      final decodedToken = JwtDecoder.decode(accessToken);
      
      // Extract user info from token payload
      // Adjust these keys based on your JWT token structure
      final userId = decodedToken['sub'] ?? 
                     decodedToken['userId'] ?? 
                     decodedToken['id'] ?? 
                     '';
      final userEmail = decodedToken['email'] ?? '';
      final userName = decodedToken['name'] ?? 
                      decodedToken['fullName'] ?? 
                      decodedToken['username'] ?? 
                      userEmail;
      
      if (userId.isNotEmpty && userEmail.isNotEmpty) {
        return AuthState.authenticated(
          user: User(
            id: userId.toString(),
            name: userName.toString(),
            email: userEmail.toString(),
          ),
        );
      }
    } catch (e) {
      // If decoding fails, return unauthenticated
    }
    return const AuthState.unauthenticated();
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final (user, tokens) = await _authRepository.login(email: email, password: password);
      // Tokens are already saved in ApiAuthRepository
      return AuthState.authenticated(user: user);
    });
  }

  Future<void> register(String name, String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _authRepository.register(
        name: name,
        email: email,
        password: password,
      );
      // Tokens are already saved in ApiAuthRepository
      // After registration, the user needs to verify email,
      // so we don't log them in immediately.
      return const AuthState.unauthenticated();
    });
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      // Clear stored tokens
      await _tokenStorageService.clearTokens();
      return const AuthState.unauthenticated();
    });
  }

  Future<void> activateAccount(String token) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _authRepository.activateAccount(token: token);
      // After successful activation, stay unauthenticated
      // The UI will handle navigation to congratulations screen
      return const AuthState.unauthenticated();
    });
  }

  Future<VerifyActivationTokenResponse> verifyActivationToken(String token) async {
    return await _authRepository.verifyActivationToken(token: token);
  }

  Future<void> resendActivationLink(String email) async {
    await _authRepository.resendActivation(email: email);
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

  Future<void> googleSignIn(String idToken) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final (user, tokens) = await _authRepository.googleSignIn(idToken: idToken);
      // Tokens are already saved in ApiAuthRepository
      return AuthState.authenticated(user: user);
    });
  }
}
