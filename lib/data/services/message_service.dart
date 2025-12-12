import '../../domain/models/conversation.dart';
import '../../domain/models/message.dart';
import '../../domain/models/seller.dart';

class MessageService {
  static final MessageService _instance = MessageService._internal();
  factory MessageService() => _instance;
  MessageService._internal();

  // Mock conversations data matching screenshot
  final List<Conversation> _conversations = [
    Conversation(
      id: 'conv1',
      seller: Seller(
        id: 'seller1',
        name: 'Thái Vạn',
        username: 'cokhithaivan',
        avatar: null,
        isFavorite: true,
        badge: null,
      ),
      lastMessage: 'cokhithaivan đã gửi cho bạn một sticker',
      lastMessageTime: DateTime(2024, 10, 25),
      unreadCount: 0,
    ),
    Conversation(
      id: 'conv2',
      seller: Seller(
        id: 'seller2',
        name: 'Robot Vietnam',
        username: 'robot_vietnam',
        avatar: null,
        isFavorite: false,
        badge: null,
      ),
      lastMessage: 'Bạn ơi, đơn hàng đã được ký nhận, bạn hãy khui...',
      lastMessageTime: DateTime(2024, 10, 16),
      unreadCount: 0,
    ),
    Conversation(
      id: 'conv3',
      seller: Seller(
        id: 'seller3',
        name: 'Orange Closet',
        username: 'orangecloset96',
        avatar: null,
        isFavorite: false,
        badge: null,
      ),
      lastMessage: 'dạ vâng cảm ơn b nhiều ạ chúc bạn 1 ngày vui v...',
      lastMessageTime: DateTime(2024, 5, 12),
      unreadCount: 0,
    ),
    Conversation(
      id: 'conv4',
      seller: Seller(
        id: 'seller4',
        name: 'ibarrel',
        username: 'ibarrel',
        avatar: null,
        isFavorite: true,
        badge: null,
      ),
      lastMessage: 'Xin chào, đơn hàng của bạn đã bị vô hiệu bởi vì g...',
      lastMessageTime: DateTime(2024, 4, 14),
      unreadCount: 0,
    ),
    Conversation(
      id: 'conv5',
      seller: Seller(
        id: 'seller5',
        name: 'MINSU Official Store',
        username: 'minsu_official',
        avatar: null,
        isFavorite: false,
        badge: null,
      ),
      lastMessage: 'MIN thấy mình đã nhận hàng! Nếu bạn gặp vấn...',
      lastMessageTime: DateTime(2024, 3, 11),
      unreadCount: 0,
    ),
    Conversation(
      id: 'conv6',
      seller: Seller(
        id: 'seller6',
        name: 'AROMA MATE',
        username: 'aroma_mate',
        avatar: null,
        isFavorite: true,
        badge: null,
      ),
      lastMessage: 'Bạn ơi bạn nhận được đơn hàng rồi dành ra ít th...',
      lastMessageTime: DateTime(2023, 12, 1),
      unreadCount: 0,
    ),
    Conversation(
      id: 'conv7',
      seller: Seller(
        id: 'seller7',
        name: 'KIOXIA Store',
        username: 'kioxia_flagship_store',
        avatar: null,
        isFavorite: false,
        badge: null,
      ),
      lastMessage: 'A đặt được ạ.',
      lastMessageTime: DateTime(2023, 10, 9),
      unreadCount: 0,
    ),
    Conversation(
      id: 'conv8',
      seller: Seller(
        id: 'seller8',
        name: 'SEVICH Official Store',
        username: 'sevich_official',
        avatar: null,
        isFavorite: false,
        badge: null,
      ),
      lastMessage: 'Bạn thân mến, hậu cần cho thấy rằng bạn đã nh...',
      lastMessageTime: DateTime(2023, 7, 16),
      unreadCount: 0,
    ),
    Conversation(
      id: 'conv9',
      seller: Seller(
        id: 'seller9',
        name: 'HAPPY PHONE MALL',
        username: 'happy_phone_mall',
        avatar: null,
        isFavorite: false,
        badge: null,
      ),
      lastMessage: 'VC3TR - 12% Chào bạn, Shop gửi tặng bạn Mã g...',
      lastMessageTime: DateTime(2023, 7, 15),
      unreadCount: 0,
    ),
  ];

  // Mock messages for conversations
  final Map<String, List<Message>> _messages = {
    'conv1': [
      Message(
        id: 'msg1',
        conversationId: 'conv1',
        senderId: 'seller1',
        senderName: 'Thái Vạn',
        content: 'Thái Vạn xin chào!',
        timestamp: DateTime(2024, 10, 25, 7, 40),
        messageType: MessageType.seller,
      ),
      Message(
        id: 'msg2',
        conversationId: 'conv1',
        senderId: 'ai',
        senderName: 'AI Assistant',
        content: 'Thời gian giao nhận hàng',
        timestamp: DateTime(2024, 10, 25, 7, 42),
        messageType: MessageType.ai,
      ),
      Message(
        id: 'msg3',
        conversationId: 'conv1',
        senderId: 'user',
        senderName: 'Bạn',
        content: 'Bạn đang yêu cầu thông tin về đơn hàng này',
        timestamp: DateTime(2024, 10, 25, 7, 42),
        messageType: MessageType.user,
        isDelivered: true,
      ),
      Message(
        id: 'msg4',
        conversationId: 'conv1',
        senderId: 'user',
        senderName: 'Bạn',
        content: 'E vừa đặt đơn khung',
        timestamp: DateTime(2024, 10, 25, 7, 43),
        messageType: MessageType.user,
        isDelivered: true,
      ),
      Message(
        id: 'msg5',
        conversationId: 'conv1',
        senderId: 'ai',
        senderName: 'AI Assistant',
        content: 'Vui lòng chọn một câu hỏi thường gặp, hoặc nhấn chọn "Chat với Người bán".',
        timestamp: DateTime(2024, 10, 25, 7, 43),
        messageType: MessageType.ai,
      ),
      Message(
        id: 'msg6',
        conversationId: 'conv1',
        senderId: 'user',
        senderName: 'Bạn',
        content: 'Xe em AB 125 2025',
        timestamp: DateTime(2024, 10, 25, 7, 43),
        messageType: MessageType.user,
        isDelivered: true,
      ),
      Message(
        id: 'msg7',
        conversationId: 'conv1',
        senderId: 'user',
        senderName: 'Bạn',
        content: 'Chat với Người bán',
        timestamp: DateTime(2024, 10, 25, 7, 43),
        messageType: MessageType.user,
        isDelivered: true,
      ),
      Message(
        id: 'msg8',
        conversationId: 'conv1',
        senderId: 'system',
        senderName: 'Hệ thống',
        content: 'Bạn đang chat với Người bán về đơn hàng sau:',
        timestamp: DateTime(2024, 10, 25, 7, 44),
        messageType: MessageType.system,
      ),
    ],
  };

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
    
    final conversation = _conversations.firstWhere(
      (c) => c.id == conversationId,
      orElse: () => _conversations.first,
    );

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


