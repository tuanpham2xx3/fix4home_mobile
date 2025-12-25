import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/models/message.dart';
import '../../../domain/repositories/chatbot_repository.dart';
import 'chatbot_state.dart';

class ChatbotNotifier extends StateNotifier<ChatbotState> {
  final ChatbotRepository _repository;

  ChatbotNotifier(this._repository)
      : super(ChatbotState(
          messages: const AsyncValue.loading(),
        )) {
    loadHistory();
  }

  /// Load full chat history from API
  Future<void> loadHistory() async {
    state = state.copyWith(
      messages: const AsyncValue.loading(),
      isTyping: false,
    );

    try {
      // Load history with max size (100 is the API limit)
      final page = await _repository.getChatHistory(page: 0, size: 100);
      
      // Convert ChatbotHistoryDTO to Message
      final messages = page.content.map((dto) {
        return Message(
          id: dto.id.toString(),
          conversationId: 'chatbot',
          senderId: dto.messageType == 'USER' ? 'user' : 'chatbot',
          senderName: dto.messageType == 'USER' ? 'Bạn' : 'CHATBOT',
          content: dto.message,
          timestamp: dto.createdAt,
          messageType: dto.messageType == 'USER' ? MessageType.user : MessageType.ai,
          isDelivered: true,
        );
      }).toList();

      // Sort by timestamp (oldest first) to display in correct order
      messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

      // Get sessionId from the latest message in history
      String? latestSessionId;
      if (page.content.isNotEmpty) {
        // Get sessionId from the most recent message in history
        latestSessionId = page.content.last.sessionId;
      }

      state = state.copyWith(
        messages: AsyncValue.data(messages),
        sessionId: latestSessionId ?? state.sessionId,
        isTyping: false,
      );
    } catch (e, stack) {
      // If loading history fails, allow user to still send messages
      // Set messages to empty list instead of error state
      state = state.copyWith(
        messages: const AsyncValue.data([]),
        isTyping: false,
      );
      // Store error separately for UI to show if needed
      // But don't block message sending
    }
  }

  /// Send a message to the chatbot
  Future<void> sendMessage(String content) async {
    // Get current messages - handle both data and error states
    List<Message> currentMessages = [];
    if (state.messages.hasValue) {
      currentMessages = state.messages.value ?? [];
    }
    
    // Add user message to UI immediately (optimistic update)
    final userMessage = Message(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      conversationId: 'chatbot',
      senderId: 'user',
      senderName: 'Bạn',
      content: content,
      timestamp: DateTime.now(),
      messageType: MessageType.user,
      isDelivered: true,
    );

    state = state.copyWith(
      messages: AsyncValue.data([...currentMessages, userMessage]),
      isTyping: true,
      lastFailedMessage: null, // Clear previous failure
      lastFailedSessionId: null,
      clearError: true, // Clear previous error
    );

    try {
      // Send message to API
      final response = await _repository.sendMessage(
        message: content,
        sessionId: state.sessionId,
      );

      // Update sessionId if new session was created
      final updatedSessionId = response.newSession ? response.sessionId : (response.sessionId.isNotEmpty ? response.sessionId : state.sessionId);

      // Add bot response message
      final botMessage = Message(
        id: 'bot_${DateTime.now().millisecondsSinceEpoch}',
        conversationId: 'chatbot',
        senderId: 'chatbot',
        senderName: 'CHATBOT',
        content: response.output,
        timestamp: response.timestamp,
        messageType: MessageType.ai,
        isDelivered: true,
      );

      final currentMessagesList = state.messages.value ?? [];
      final updatedMessages = <Message>[...currentMessagesList, botMessage];

      state = state.copyWith(
        messages: AsyncValue.data(updatedMessages),
        sessionId: updatedSessionId,
        isTyping: false,
        lastFailedMessage: null,
        lastFailedSessionId: null,
        clearError: true,
      );
    } catch (e, stack) {
      // On error, keep the user message but mark as failed for retry
      // Keep messages as data (with user message) so UI can show it
      final currentMessagesWithUser = state.messages.value ?? [];
      state = state.copyWith(
        messages: AsyncValue.data(currentMessagesWithUser), // Keep messages
        isTyping: false,
        lastFailedMessage: content,
        lastFailedSessionId: state.sessionId,
        lastError: e,
        lastStackTrace: stack,
      );
    }
  }

  /// Retry sending the last failed message
  Future<void> retryLastMessage() async {
    if (state.lastFailedMessage != null) {
      // Remove the last user message (the failed one) from messages
      final currentMessages = state.messages.value ?? [];
      if (currentMessages.isNotEmpty && 
          currentMessages.last.messageType == MessageType.user &&
          currentMessages.last.content == state.lastFailedMessage) {
        final messagesWithoutLast = currentMessages.sublist(0, currentMessages.length - 1);
        state = state.copyWith(
          messages: AsyncValue.data(messagesWithoutLast),
        );
      }
      
      // Retry sending
      await sendMessage(state.lastFailedMessage!);
    }
  }

  /// Refresh chat history
  Future<void> refresh() async {
    await loadHistory();
  }
}

