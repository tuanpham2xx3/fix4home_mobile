import 'package:dio/dio.dart';
import '../../domain/models/chat_api_models.dart';
import '../../core/config/api_config.dart';

class ApiConversationRepository {
  final Dio _dio;

  ApiConversationRepository(this._dio);

  // Helper method to parse API response with { success, message, data } structure
  Map<String, dynamic> _parseResponse(Map<String, dynamic> responseData) {
    if (responseData['success'] != true) {
      final message = responseData['message'] ?? 'Request failed';
      throw Exception(message);
    }

    if (responseData['data'] == null) {
      throw Exception('Response data is null');
    }

    return responseData['data'] as Map<String, dynamic>;
  }

  // Helper method to handle Dio errors
  Exception _handleDioError(DioException error) {
    if (error.response != null) {
      final statusCode = error.response!.statusCode;
      final data = error.response!.data;

      String message = 'Đã xảy ra lỗi';

      if (data is Map<String, dynamic>) {
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
          return Exception('Không có quyền truy cập. Vui lòng đăng nhập lại');
        case 403:
          return Exception('Bạn không có quyền thực hiện hành động này');
        case 404:
          return Exception('Không tìm thấy conversation');
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

  /// Get all conversations
  Future<List<ConversationDTO>> getConversations() async {
    try {
      final response = await _dio.get(ApiConfig.conversationsEndpoint);

      final responseData = response.data as Map<String, dynamic>;
      final data = _parseResponse(responseData);

      if (data is List) {
        return (data as List<dynamic>)
            .map((e) => ConversationDTO.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      throw Exception('Invalid response format');
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Lấy danh sách conversations thất bại: ${e.toString()}');
    }
  }

  /// Get conversations with pagination
  Future<PageResponse<ConversationDTO>> getConversationsPaginated({
    int page = 0,
    int size = 10,
  }) async {
    try {
      final response = await _dio.get(
        ApiConfig.conversationsPaginatedEndpoint,
        queryParameters: {
          'page': page,
          'size': size,
        },
      );

      final responseData = response.data as Map<String, dynamic>;
      final data = _parseResponse(responseData);

      return PageResponse<ConversationDTO>.fromJson(
        data,
        (json) => ConversationDTO.fromJson(json),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Lấy danh sách conversations thất bại: ${e.toString()}');
    }
  }

  /// Get conversation by ID
  Future<ConversationDTO> getConversationById(int id) async {
    try {
      final response = await _dio.get(
        ApiConfig.conversationByIdEndpoint(id),
      );

      final responseData = response.data as Map<String, dynamic>;
      final data = _parseResponse(responseData);

      return ConversationDTO.fromJson(data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Lấy chi tiết conversation thất bại: ${e.toString()}');
    }
  }

  /// Find or create conversation with another user
  Future<ConversationDTO> findOrCreateConversation(int otherUserId) async {
    try {
      final response = await _dio.post(
        ApiConfig.findOrCreateConversationEndpoint,
        queryParameters: {
          'otherUserId': otherUserId,
        },
      );

      final responseData = response.data as Map<String, dynamic>;
      final data = _parseResponse(responseData);

      return ConversationDTO.fromJson(data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Tìm hoặc tạo conversation thất bại: ${e.toString()}');
    }
  }

  /// Archive conversation
  Future<void> archiveConversation(int id) async {
    try {
      await _dio.put(ApiConfig.archiveConversationEndpoint(id));
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Archive conversation thất bại: ${e.toString()}');
    }
  }
}

