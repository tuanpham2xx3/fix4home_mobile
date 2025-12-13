import 'package:dio/dio.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:flutter/foundation.dart';

import 'token_storage_service.dart';
import 'device_id_service.dart';
import '../config/api_config.dart';
import '../../features/auth/application/auth_controller.dart';
import '../../domain/models/refresh_token_response.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: ApiConfig.baseUrl,
  ));

  dio.interceptors.add(DeviceIdInterceptor(ref));
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

class DeviceIdInterceptor extends Interceptor {
  final Ref _ref;

  DeviceIdInterceptor(this._ref);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      final deviceIdService = _ref.read(deviceIdServiceProvider);
      final deviceId = await deviceIdService.getDeviceId();
      options.headers['X-Device-Id'] = deviceId;
    } catch (e) {
      // If device ID cannot be obtained, continue without it
    }
    handler.next(options);
  }
}

class AuthInterceptor extends Interceptor {
  final Ref _ref;
  final Dio _dio;
  static Completer<String?>? _refreshCompleter;

  AuthInterceptor(this._ref, this._dio);

  // Check if this is an auth endpoint that shouldn't trigger token refresh
  bool _isAuthEndpoint(String path) {
    return path.contains('/auth/login') || 
           path.contains('/auth/register') ||
           path.contains('/auth/refresh');
  }

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
    // Skip token refresh for auth endpoints (login, register, refresh)
    // These endpoints should handle their own errors
    if (_isAuthEndpoint(err.requestOptions.path)) {
      return handler.next(err);
    }

    if (err.response?.statusCode == 401) {
      final tokenStorageService = _ref.read(tokenStorageServiceProvider);

      final oldTokens = await tokenStorageService.getTokens();
      if (oldTokens == null) {
        return handler.next(err);
      }

      // Only try to refresh if we have a refresh token
      if (oldTokens.refreshToken.isEmpty) {
        _ref.read(authControllerProvider.notifier).logout();
        return handler.next(err);
      }

      try {
        // If a refresh is already in progress, wait for it
        if (_refreshCompleter != null) {
          final refreshedToken = await _refreshCompleter!.future;
          if (refreshedToken == null) {
            _ref.read(authControllerProvider.notifier).logout();
            return handler.next(err);
          }
          // Retry the original request with the new token
          final options = err.requestOptions;
          options.headers['Authorization'] = 'Bearer $refreshedToken';
          final response = await _dio.fetch(options);
          return handler.resolve(response);
        }

        // Start a new refresh operation
        _refreshCompleter = Completer<String?>();
        String? newAccessToken;

        try {
          // Create a new Dio instance to avoid circular dependency
          // This Dio won't have interceptors to avoid infinite loops
          final refreshDio = Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));
          final refreshHeaders = <String, String>{
            'Content-Type': 'application/json',
            'X-Refresh-Token': oldTokens.refreshToken,
          };
          
          final refreshResponse = await refreshDio.post(
            ApiConfig.refreshTokenEndpoint,
            data: {'refreshToken': oldTokens.refreshToken},
            options: Options(headers: refreshHeaders),
          );

          // Parse response - check if it's wrapped in { success, message, data }
          Map<String, dynamic> refreshData;
          if (refreshResponse.data is Map<String, dynamic>) {
            final data = refreshResponse.data as Map<String, dynamic>;
            if (data['success'] == true && data['data'] != null) {
              // Backend returns { success, message, data }
              refreshData = data['data'] as Map<String, dynamic>;
            } else {
              // Direct response format
              refreshData = data;
            }
          } else {
            throw Exception('Invalid refresh token response format');
          }

          final refreshTokenResponse = RefreshTokenResponse.fromJson(refreshData);
          newAccessToken = refreshTokenResponse.accessToken;
          await tokenStorageService.saveAccessToken(newAccessToken);
          _refreshCompleter!.complete(newAccessToken);
        } catch (e) {
          _refreshCompleter!.complete(null);
        }

        // Wait for refresh to complete
        final refreshed = await _refreshCompleter!.future;
        _refreshCompleter = null;

        if (refreshed == null) {
          _ref.read(authControllerProvider.notifier).logout();
          return handler.next(err);
        }

        // Retry the original request with the new token
        final options = err.requestOptions;
        options.headers['Authorization'] = 'Bearer $refreshed';
        final response = await _dio.fetch(options);
        return handler.resolve(response);
      } catch (_) {
        _refreshCompleter = null;
        _ref.read(authControllerProvider.notifier).logout();
        return handler.next(err);
      }
    } else {
      handler.next(err);
    }
  }
}
