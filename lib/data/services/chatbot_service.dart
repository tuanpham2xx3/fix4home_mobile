import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../domain/models/chat_api_models.dart';
import '../../core/config/api_config.dart';
import '../../core/services/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatbotServiceProvider = Provider<ChatbotService>((ref) {
  final dio = ref.read(dioProvider);
  return ChatbotService(dio);
});

class ChatbotService {
  final Dio _dio;
  static const String _sessionIdKey = 'chatbot_session_id';

  ChatbotService(this._dio);

  /// Get or create session ID from SharedPreferences
  Future<String> getSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString(_sessionIdKey);
    if (sessionId == null || sessionId.isEmpty) {
      sessionId = const Uuid().v4();
      await prefs.setString(_sessionIdKey, sessionId);
    }
    return sessionId;
  }

  /// Save session ID to SharedPreferences
  Future<void> saveSessionId(String sessionId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionIdKey, sessionId);
  }

  /// Send message to chatbot
  Future<ChatbotSendResponse> sendMessageToChatbot({
    required int conversationId,
    required String message,
  }) async {
    try {
      // Get current session ID
      String sessionId = await getSessionId();

      final response = await _dio.post(
        ApiConfig.chatbotSendEndpoint,
        data: {
          'conversationId': conversationId,
          'message': message,
          'sessionId': sessionId,
        },
      );

      final responseData = response.data as Map<String, dynamic>;

      // Parse response
      if (responseData['success'] != true) {
        final errorMessage = responseData['message'] ?? 'Failed to send message to chatbot';
        throw Exception(errorMessage);
      }

      final data = responseData['data'] as Map<String, dynamic>;
      final chatbotResponse = ChatbotSendResponse.fromJson(data);

      // If new session was created, save it
      if (chatbotResponse.newSessionCreated) {
        await saveSessionId(chatbotResponse.sessionId);
      }

      return chatbotResponse;
    } on DioException catch (e) {
      if (e.response != null) {
        final statusCode = e.response!.statusCode;
        final data = e.response!.data;

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
            throw Exception('Yêu cầu không hợp lệ: $message');
          case 401:
            throw Exception('Không có quyền truy cập. Vui lòng đăng nhập lại');
          case 403:
            throw Exception('Bạn không có quyền thực hiện hành động này');
          case 500:
          case 502:
          case 503:
            throw Exception('Lỗi máy chủ. Vui lòng thử lại sau');
          default:
            throw Exception('Lỗi $statusCode: $message');
        }
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw Exception('Kết nối quá thời gian. Vui lòng kiểm tra kết nối mạng');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('Không thể kết nối đến máy chủ. Vui lòng kiểm tra kết nối mạng');
      } else {
        throw Exception('Đã xảy ra lỗi: ${e.message}');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Gửi message đến chatbot thất bại: ${e.toString()}');
    }
  }
}

