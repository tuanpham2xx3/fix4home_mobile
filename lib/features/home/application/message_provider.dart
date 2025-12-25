import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/models/conversation.dart';
import '../../../domain/models/message.dart';
import '../../../data/services/message_service.dart';
import '../../../domain/repositories/chatbot_repository.dart';
import '../../../data/repositories/api_chatbot_repository.dart';
import '../../../core/services/api_client.dart';
import 'chatbot_notifier.dart';
import 'chatbot_state.dart';

final messageServiceProvider = Provider<MessageService>((ref) {
  return MessageService();
});

final conversationsProvider = FutureProvider<List<Conversation>>((ref) async {
  final service = ref.read(messageServiceProvider);
  return await service.getConversations();
});

final conversationProvider = StateProvider<Conversation?>((ref) => null);

final messagesProvider = FutureProvider.family<List<Message>, String>((ref, conversationId) async {
  final service = ref.read(messageServiceProvider);
  return await service.getMessages(conversationId);
});

class MessageNotifier extends StateNotifier<AsyncValue<List<Message>>> {
  final MessageService _service;
  final String _conversationId;

  MessageNotifier(this._service, this._conversationId) : super(const AsyncValue.loading()) {
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    state = const AsyncValue.loading();
    try {
      final messages = await _service.getMessages(_conversationId);
      state = AsyncValue.data(messages);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> sendMessage(String content) async {
    try {
      final newMessage = await _service.sendMessage(_conversationId, content);
      final currentMessages = state.value ?? [];
      state = AsyncValue.data([...currentMessages, newMessage]);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> refresh() async {
    await _loadMessages();
  }
}

final messageNotifierProvider = StateNotifierProvider.family<MessageNotifier, AsyncValue<List<Message>>, String>((ref, conversationId) {
  final service = ref.read(messageServiceProvider);
  return MessageNotifier(service, conversationId);
});

// Chatbot repository provider
final chatbotRepositoryProvider = Provider<ChatbotRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiChatbotRepository(dio);
});

// Chatbot notifier provider (only for chatbot conversation)
final chatbotNotifierProvider = StateNotifierProvider<ChatbotNotifier, ChatbotState>((ref) {
  final repository = ref.watch(chatbotRepositoryProvider);
  return ChatbotNotifier(repository);
});



