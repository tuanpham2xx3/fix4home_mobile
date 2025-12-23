import 'package:dio/dio.dart';
import '../../domain/models/chat_api_models.dart';
import '../../core/config/api_config.dart';

class ApiMessageRepository {
  final Dio _dio;

  ApiMessageRepository(this._dio);

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
          return Exception('Không tìm thấy messages');
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

  /// Get messages in a conversation
  Future<PageResponse<MessageDTO>> getMessages({
    required int conversationId,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await _dio.get(
        ApiConfig.messagesEndpoint(conversationId),
        queryParameters: {
          'page': page,
          'size': size,
        },
      );

      final responseData = response.data as Map<String, dynamic>;
      final data = _parseResponse(responseData);

      return PageResponse<MessageDTO>.fromJson(
        data,
        (json) => MessageDTO.fromJson(json),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Lấy messages thất bại: ${e.toString()}');
    }
  }

  /// Get messages before a specific date (for infinite scroll)
  Future<PageResponse<MessageDTO>> getMessagesBefore({
    required int conversationId,
    required DateTime beforeDate,
    int size = 20,
  }) async {
    try {
      final response = await _dio.get(
        ApiConfig.messagesBeforeEndpoint(conversationId),
        queryParameters: {
          'beforeDate': beforeDate.toIso8601String(),
          'size': size,
        },
      );

      final responseData = response.data as Map<String, dynamic>;
      final data = _parseResponse(responseData);

      return PageResponse<MessageDTO>.fromJson(
        data,
        (json) => MessageDTO.fromJson(json),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Lấy messages thất bại: ${e.toString()}');
    }
  }

  /// Mark messages as read
  Future<void> markMessagesAsRead({
    required int conversationId,
    List<int>? messageIds,
  }) async {
    try {
      final body = <String, dynamic>{
        'conversationId': conversationId,
      };

      if (messageIds != null) {
        body['messageIds'] = messageIds;
      }

      await _dio.post(
        ApiConfig.markMessagesReadEndpoint,
        data: body,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Đánh dấu đã đọc thất bại: ${e.toString()}');
    }
  }

  /// Get unread messages
  Future<List<MessageDTO>> getUnreadMessages() async {
    try {
      final response = await _dio.get(ApiConfig.unreadMessagesEndpoint);

      final responseData = response.data as Map<String, dynamic>;
      final data = _parseResponse(responseData);

      if (data is List) {
        return (data as List<dynamic>)
            .map((e) => MessageDTO.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      throw Exception('Invalid response format');
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Lấy unread messages thất bại: ${e.toString()}');
    }
  }
}

