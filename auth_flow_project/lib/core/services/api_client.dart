import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:flutter/foundation.dart';

import 'token_storage_service.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../features/auth/application/auth_controller.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.example.com', // This will be replaced by dotenv
  ));

  dio.interceptors.add(AuthInterceptor(ref, dio));

  if (kDebugMode) {
    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
    ));
  }

  return dio;
});

class AuthInterceptor extends Interceptor {
  final Ref _ref;
  final Dio _dio;

  AuthInterceptor(this._ref, this._dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final tokens = await _ref.read(tokenStorageServiceProvider).getTokens();
    if (tokens != null) {
      options.headers['Authorization'] = 'Bearer ${tokens.accessToken}';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final tokenStorageService = _ref.read(tokenStorageServiceProvider);
      final authRepository = _ref.read(authRepositoryProvider);

      final oldTokens = await tokenStorageService.getTokens();
      if (oldTokens == null) {
        return handler.next(err);
      }

      _dio.lock();
      try {
        final newAccessToken = await authRepository.refreshToken(refreshToken: oldTokens.refreshToken);
        final newTokens = oldTokens.copyWith(accessToken: newAccessToken);
        await tokenStorageService.saveTokens(newTokens);

        _dio.unlock();

        // Retry the original request with the new token
        final options = err.requestOptions;
        options.headers['Authorization'] = 'Bearer $newAccessToken';

        final response = await _dio.fetch(options);
        return handler.resolve(response);

      } catch (e) {
        // If refresh token fails, logout the user
        _ref.read(authControllerProvider.notifier).logout();
        _dio.unlock();
        return handler.next(err);
      }
    }
    handler.next(err);
  }
}
