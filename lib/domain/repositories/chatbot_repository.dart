import '../../domain/models/chatbot_message_response.dart';
import '../../domain/models/chatbot_history_dto.dart';
import '../../domain/models/page.dart';

abstract class ChatbotRepository {
  /// Send a message to the chatbot and receive a response
  Future<ChatbotMessageResponse> sendMessage({
    required String message,
    String? sessionId,
  });

  /// Get chat history with pagination
  Future<Page<ChatbotHistoryDTO>> getChatHistory({
    int page = 0,
    int size = 20,
  });

  /// Get chat history for a specific session
  Future<List<ChatbotHistoryDTO>> getSessionHistory(String sessionId);
}

