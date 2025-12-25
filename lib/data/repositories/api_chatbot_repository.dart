import 'package:dio/dio.dart';
import '../../domain/models/chatbot_message_response.dart';
import '../../domain/models/chatbot_history_dto.dart';
import '../../domain/models/page.dart';
import '../../domain/models/send_chatbot_message_request.dart';
import '../../domain/repositories/chatbot_repository.dart';
import '../../core/config/api_config.dart';

class ApiChatbotRepository implements ChatbotRepository {
  final Dio _dio;

  ApiChatbotRepository(this._dio);

  // Helper method to parse API response with { success, message, data } structure
  Map<String, dynamic> _parseResponse(Map<String, dynamic> responseData) {
    if (responseData['success'] != true) {
      final message = responseData['message'] ?? 
                     responseData['userMessage'] ?? 
                     'Request failed';
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
          return Exception('Không tìm thấy dữ liệu');
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

  @override
  Future<ChatbotMessageResponse> sendMessage({
    required String message,
    String? sessionId,
  }) async {
    try {
      final request = SendChatbotMessageRequest(
        message: message,
        sessionId: sessionId,
      );

      final response = await _dio.post(
        ApiConfig.chatbotSendEndpoint,
        data: request.toJson(),
      );

      final responseData = response.data as Map<String, dynamic>;
      final data = _parseResponse(responseData);
      return ChatbotMessageResponse.fromJson(data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Gửi tin nhắn thất bại: ${e.toString()}');
    }
  }

  @override
  Future<Page<ChatbotHistoryDTO>> getChatHistory({
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await _dio.get(
        ApiConfig.chatbotHistoryEndpoint,
        queryParameters: {
          'page': page,
          'size': size,
        },
      );

      final responseData = response.data as Map<String, dynamic>;
      final data = _parseResponse(responseData);
      return Page.fromJson(data, (json) => ChatbotHistoryDTO.fromJson(json));
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Lấy lịch sử chat thất bại: ${e.toString()}');
    }
  }

  @override
  Future<List<ChatbotHistoryDTO>> getSessionHistory(String sessionId) async {
    try {
      final response = await _dio.get(
        ApiConfig.chatbotSessionHistoryEndpoint(sessionId),
      );

      final responseData = response.data as Map<String, dynamic>;
      
      // Check if response has success and data
      if (responseData['success'] != true) {
        final message = responseData['message'] ?? 
                       responseData['userMessage'] ?? 
                       'Request failed';
        throw Exception(message);
      }
      
      // Get data which should be a List for session history
      final data = responseData['data'];
      
      if (data is List) {
        return data
            .map((e) => ChatbotHistoryDTO.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Invalid response format');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Lấy lịch sử session thất bại: ${e.toString()}');
    }
  }
}

