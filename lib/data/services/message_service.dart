import '../../domain/models/conversation.dart';
import '../../domain/models/message.dart';
import '../../domain/models/seller.dart';

class MessageService {
  static final MessageService _instance = MessageService._internal();
  factory MessageService() => _instance;
  MessageService._internal();

  // Default chatbot conversation
  final List<Conversation> _conversations = [
    Conversation(
      id: 'chatbot',
      seller: Seller(
        id: 'chatbot',
        name: 'CHATBOT',
        username: 'CHATBOT',
        avatar: null,
        isFavorite: false,
        badge: null,
      ),
      lastMessage: '',
      lastMessageTime: DateTime.now(),
      unreadCount: 0,
    ),
  ];

  // Messages storage (empty by default)
  final Map<String, List<Message>> _messages = {};

  Future<List<Conversation>> getConversations() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_conversations);
  }

  Future<List<Message>> getMessages(String conversationId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(_messages[conversationId] ?? []);
  }

  Future<Message> sendMessage(String conversationId, String content) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final newMessage = Message(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      conversationId: conversationId,
      senderId: 'user',
      senderName: 'Bạn',
      content: content,
      timestamp: DateTime.now(),
      messageType: MessageType.user,
      isDelivered: true,
    );

    // Add message to the list
    if (_messages[conversationId] != null) {
      _messages[conversationId]!.add(newMessage);
    } else {
      _messages[conversationId] = [newMessage];
    }

    // Update conversation's last message
    final index = _conversations.indexWhere((c) => c.id == conversationId);
    if (index != -1) {
      _conversations[index] = Conversation(
        id: _conversations[index].id,
        seller: _conversations[index].seller,
        lastMessage: content,
        lastMessageTime: DateTime.now(),
        unreadCount: _conversations[index].unreadCount,
      );
    }

    return newMessage;
  }

  Future<void> toggleFavorite(String conversationId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _conversations.indexWhere((c) => c.id == conversationId);
    if (index != -1) {
      final seller = _conversations[index].seller;
      _conversations[index] = Conversation(
        id: _conversations[index].id,
        seller: Seller(
          id: seller.id,
          name: seller.name,
          username: seller.username,
          avatar: seller.avatar,
          isFavorite: !seller.isFavorite,
          badge: seller.badge,
        ),
        lastMessage: _conversations[index].lastMessage,
        lastMessageTime: _conversations[index].lastMessageTime,
        unreadCount: _conversations[index].unreadCount,
      );
    }
  }
}


