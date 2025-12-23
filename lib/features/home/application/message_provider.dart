import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/models/conversation.dart';
import '../../../domain/models/message.dart';
import '../../../domain/models/chat_api_models.dart';
import '../../../data/services/message_service.dart';
import '../../../data/repositories/repository_providers.dart';
import '../../../data/repositories/api_message_repository.dart';
import '../../../data/services/chatbot_service.dart';
import '../../../data/services/websocket_service.dart';

// Legacy mock service provider (for fallback)
final messageServiceProvider = Provider<MessageService>((ref) {
  return MessageService();
});

// API-based providers
final apiConversationsProvider = FutureProvider<List<ConversationDTO>>((ref) async {
  final repository = ref.read(conversationRepositoryProvider);
  try {
    return await repository.getConversations();
  } catch (e) {
    // Return empty list if API fails - UI will show empty state
    return [];
  }
});

final conversationProvider = StateProvider<ConversationDTO?>((ref) => null);

// Message provider for a conversation
class MessageNotifier extends StateNotifier<AsyncValue<List<MessageDTO>>> {
  final ApiMessageRepository _repository;
  final ChatbotService? _chatbotService;
  final WebSocketService? _wsService;
  final int _conversationId;
  final bool _isChatbot;

  MessageNotifier(
    this._repository,
    this._conversationId,
    this._isChatbot, {
    ChatbotService? chatbotService,
    WebSocketService? wsService,
  })  : _chatbotService = chatbotService,
        _wsService = wsService,
        super(const AsyncValue.loading()) {
    _loadMessages();
    _setupWebSocket();
  }

  void _setupWebSocket() {
    if (_wsService != null) {
      _wsService!.setOnMessageReceived((message) {
        if (message.conversationId == _conversationId) {
          final currentMessages = state.value ?? [];
          // Check if message already exists
          if (!currentMessages.any((m) => m.id == message.id)) {
            state = AsyncValue.data([...currentMessages, message]);
          }
        }
      });
    }
  }

  Future<void> _loadMessages({bool loadMore = false}) async {
    if (loadMore) {
      // For infinite scroll, use getMessagesBefore
      final currentMessages = state.value ?? [];
      if (currentMessages.isEmpty) return;

      final oldestMessage = currentMessages.first;
      try {
        final page = await _repository.getMessagesBefore(
          conversationId: _conversationId,
          beforeDate: oldestMessage.sentAt,
        );
        state = AsyncValue.data([...page.content, ...currentMessages]);
      } catch (e, stack) {
        state = AsyncValue.error(e, stack);
      }
    } else {
      state = const AsyncValue.loading();
      try {
        final page = await _repository.getMessages(
          conversationId: _conversationId,
        );
        // Reverse to show oldest first (for ListView.reverse: true)
        state = AsyncValue.data(page.content.reversed.toList());
        
        // Mark messages as read
        await _repository.markMessagesAsRead(conversationId: _conversationId);
      } catch (e, stack) {
        state = AsyncValue.error(e, stack);
      }
    }
  }

  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    try {
      if (_isChatbot && _chatbotService != null) {
        // Send to chatbot
        await _chatbotService!.sendMessageToChatbot(
          conversationId: _conversationId,
          message: content,
        );
        // Reload messages to get response
        await _loadMessages();
      } else if (_wsService != null && _wsService!.isConnected) {
        // Send via WebSocket
        _wsService!.sendMessage(
          conversationId: _conversationId,
          content: content,
        );
        // Message will be added via WebSocket callback
      } else {
        // Fallback: reload messages (assuming backend creates message)
        await _loadMessages();
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> refresh() async {
    await _loadMessages();
  }

  Future<void> loadMore() async {
    await _loadMessages(loadMore: true);
  }
}

final messageNotifierProvider = StateNotifierProvider.family<
    MessageNotifier, AsyncValue<List<MessageDTO>>, int>((ref, conversationId) {
  final messageRepo = ref.read(messageRepositoryProvider);
  
  // Check if it's a chatbot conversation
  final conversationsAsync = ref.watch(apiConversationsProvider);
  final isChatbot = conversationsAsync.when(
    data: (convs) => convs.any((c) => c.id == conversationId && c.conversationType == 'CHATBOT'),
    loading: () => false,
    error: (_, __) => false,
  );

  final chatbotService = ref.read(chatbotServiceProvider);
  final wsService = ref.read(websocketServiceProvider);

  return MessageNotifier(
    messageRepo,
    conversationId,
    isChatbot,
    chatbotService: chatbotService,
    wsService: wsService,
  );
});

// Legacy providers for backward compatibility
final conversationsProvider = FutureProvider<List<Conversation>>((ref) async {
  final service = ref.read(messageServiceProvider);
  return await service.getConversations();
});

final messagesProvider = FutureProvider.family<List<Message>, String>((ref, conversationId) async {
  final service = ref.read(messageServiceProvider);
  return await service.getMessages(conversationId);
});






