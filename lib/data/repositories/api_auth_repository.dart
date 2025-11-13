import 'package:dio/dio.dart';
import '../../domain/models/user.dart';
import '../../domain/models/tokens.dart';
import '../../domain/models/auth_response.dart';
import '../../domain/models/refresh_token_response.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../core/config/api_config.dart';
import '../../core/services/device_id_service.dart';
import '../../core/services/token_storage_service.dart';

class ApiAuthRepository implements AuthRepository {
  final Dio _dio;
  final DeviceIdService _deviceIdService;
  final TokenStorageService _tokenStorageService;

  ApiAuthRepository(
    this._dio,
    this._deviceIdService,
    this._tokenStorageService,
  );

  // Helper method to get device ID and add to headers
  Future<Map<String, String>> _getHeaders() async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    try {
      final deviceId = await _deviceIdService.getDeviceId();
      headers['X-Device-Id'] = deviceId;
    } catch (e) {
      // If device ID cannot be obtained, continue without it
    }
    return headers;
  }

  // Helper method to parse backend response with { success, message, data } structure
  AuthResponse _parseAuthResponse(Map<String, dynamic> responseData) {
    // Kiểm tra success
    if (responseData['success'] != true) {
      final message = responseData['message'] ?? 
                     responseData['userMessage'] ?? 
                     'Request failed';
      throw Exception(message);
    }
    
    // Lấy data object
    if (responseData['data'] == null) {
      throw Exception('Response data is null');
    }
    
    final data = responseData['data'] as Map<String, dynamic>;
    
    // Map từ data sang AuthResponse structure
    return AuthResponse(
      accessToken: data['accessToken'] as String,
      refreshToken: data['refreshToken'] as String?,
      user: User(
        id: data['userId'].toString(), // Convert userId (number) to String
        name: data['username'] as String, // username từ backend
        email: data['email'] as String,
      ),
      status: data['status'] as String,
    );
  }

  @override
  Future<(User, Tokens)> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final headers = await _getHeaders();
      
      // Chỉ gửi các trường cần thiết cho CUSTOMER registration
      // Backend sẽ tự tạo username, không cần fullName và phoneNumber
      final requestData = <String, dynamic>{
        'email': email,
        'password': password,
        'role': 'CUSTOMER',
      };

      final response = await _dio.post(
        ApiConfig.registerEndpoint,
        data: requestData,
        options: Options(headers: headers),
      );

      // Backend trả về { success, message, data }
      final responseData = response.data as Map<String, dynamic>;
      final authResponse = _parseAuthResponse(responseData);
      
      // Save tokens if available
      if (authResponse.refreshToken != null && authResponse.refreshToken!.isNotEmpty) {
        await _tokenStorageService.saveTokens(
          Tokens(
            accessToken: authResponse.accessToken,
            refreshToken: authResponse.refreshToken!,
          ),
        );
      } else {
        // For web (no refreshToken), only save accessToken
        await _tokenStorageService.saveAccessToken(authResponse.accessToken);
      }

      return (
        authResponse.user,
        Tokens(
          accessToken: authResponse.accessToken,
          refreshToken: authResponse.refreshToken ?? '',
        ),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Đăng ký thất bại: ${e.toString()}');
    }
  }

  @override
  Future<(User, Tokens)> login({
    required String email,
    required String password,
  }) async {
    try {
      final headers = await _getHeaders();
      
      // Backend yêu cầu field name là 'usernameOrEmail' thay vì 'email'
      final requestData = <String, dynamic>{
        'usernameOrEmail': email, // Email được dùng làm usernameOrEmail
        'password': password,
      };

      final response = await _dio.post(
        ApiConfig.loginEndpoint,
        data: requestData,
        options: Options(headers: headers),
      );

      // Backend trả về { success, message, data }
      final responseData = response.data as Map<String, dynamic>;
      final authResponse = _parseAuthResponse(responseData);
      
      // Save tokens if available
      if (authResponse.refreshToken != null && authResponse.refreshToken!.isNotEmpty) {
        await _tokenStorageService.saveTokens(
          Tokens(
            accessToken: authResponse.accessToken,
            refreshToken: authResponse.refreshToken!,
          ),
        );
      } else {
        // For web (no refreshToken), only save accessToken
        await _tokenStorageService.saveAccessToken(authResponse.accessToken);
      }

      return (
        authResponse.user,
        Tokens(
          accessToken: authResponse.accessToken,
          refreshToken: authResponse.refreshToken ?? '',
        ),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Đăng nhập thất bại: ${e.toString()}');
    }
  }

  @override
  Future<String> refreshToken({
    required String refreshToken,
  }) async {
    try {
      final headers = <String, String>{
        'Content-Type': 'application/json',
        'X-Refresh-Token': refreshToken,
      };

      final response = await _dio.post(
        ApiConfig.refreshTokenEndpoint,
        data: {'refreshToken': refreshToken},
        options: Options(headers: headers),
      );

      final refreshResponse = RefreshTokenResponse.fromJson(response.data);
      
      // Save new access token
      await _tokenStorageService.saveAccessToken(refreshResponse.accessToken);
      
      return refreshResponse.accessToken;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Làm mới token thất bại: ${e.toString()}');
    }
  }

  @override
  Future<(User, Tokens)> googleSignIn({
    required String idToken,
  }) async {
    // TODO: Implement Google Sign-In when backend endpoint is available
    throw UnimplementedError('Google Sign-In chưa được hỗ trợ');
  }

  @override
  Future<void> activateAccount({
    required String token,
  }) async {
    // TODO: Implement when backend endpoint is available
    throw UnimplementedError('Kích hoạt tài khoản chưa được hỗ trợ');
  }

  @override
  Future<void> resendActivation({
    required String email,
  }) async {
    // TODO: Implement when backend endpoint is available
    throw UnimplementedError('Gửi lại email kích hoạt chưa được hỗ trợ');
  }

  @override
  Future<void> forgotPassword({
    required String email,
  }) async {
    // TODO: Implement when backend endpoint is available
    throw UnimplementedError('Quên mật khẩu chưa được hỗ trợ');
  }

  @override
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    // TODO: Implement when backend endpoint is available
    throw UnimplementedError('Đặt lại mật khẩu chưa được hỗ trợ');
  }

  // Helper method to handle Dio errors and convert to user-friendly messages
  Exception _handleDioError(DioException error) {
    if (error.response != null) {
      final statusCode = error.response!.statusCode;
      final data = error.response!.data;
      
      String message = 'Đã xảy ra lỗi';
      
      if (data is Map<String, dynamic>) {
        // Try to extract error message from response
        // Ưu tiên userMessage vì nó thân thiện với người dùng hơn
        message = data['userMessage'] ?? 
                 data['message'] ?? 
                 data['error'] ?? 
                 data['errorMessage'] ?? 
                 message;
      }
      
      switch (statusCode) {
        case 400:
          return Exception('Yêu cầu không hợp lệ: $message');
        case 401:
          return Exception('Email hoặc mật khẩu không đúng');
        case 403:
          return Exception('Bạn không có quyền thực hiện hành động này');
        case 404:
          return Exception('Không tìm thấy tài nguyên');
        case 409:
          return Exception('Email đã được sử dụng');
        case 422:
          return Exception('Dữ liệu không hợp lệ: $message');
        case 500:
        case 502:
        case 503:
          return Exception('Lỗi máy chủ. Vui lòng thử lại sau');
        default:
          return Exception('Lỗi $statusCode: $message');
      }
    } else if (error.type == DioExceptionType.connectionTimeout ||
               error.type == DioExceptionType.receiveTimeout ||
               error.type == DioExceptionType.sendTimeout) {
      return Exception('Kết nối quá thời gian. Vui lòng kiểm tra kết nối mạng');
    } else if (error.type == DioExceptionType.connectionError) {
      return Exception('Không thể kết nối đến máy chủ. Vui lòng kiểm tra kết nối mạng');
    } else {
      return Exception('Đã xảy ra lỗi: ${error.message}');
    }
  }
}

