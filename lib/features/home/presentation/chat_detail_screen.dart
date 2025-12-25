import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../application/message_provider.dart';
import '../application/chatbot_state.dart';
import '../../../domain/models/message.dart';
import '../../../domain/models/conversation.dart';
import '../../../data/services/message_service.dart';
import '../../../core/widgets/typing_indicator.dart';

class ChatDetailScreen extends ConsumerStatefulWidget {
  final String conversationId;

  const ChatDetailScreen({
    super.key,
    required this.conversationId,
  });

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Conversation? _conversation;
  bool _hasScrolledToBottom = false;

  @override
  void initState() {
    super.initState();
    _loadConversation();
  }

  Future<void> _loadConversation() async {
    final conversations = await MessageService().getConversations();
    _conversation = conversations.firstWhere(
      (c) => c.id == widget.conversationId,
      orElse: () => conversations.first,
    );
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final content = _messageController.text.trim();
    if (content.isEmpty) return;

    _messageController.clear();
    
    if (widget.conversationId == 'chatbot') {
      // Use chatbot notifier
      final notifier = ref.read(chatbotNotifierProvider.notifier);
      await notifier.sendMessage(content);
    } else {
      // Use regular message notifier
      final notifier = ref.read(messageNotifierProvider(widget.conversationId).notifier);
      await notifier.sendMessage(content);
    }
    
    // Reset flag so we scroll after sending
    _hasScrolledToBottom = false;
    _scrollToBottom();
  }

  Future<void> _retryLastMessage() async {
    if (widget.conversationId == 'chatbot') {
      final notifier = ref.read(chatbotNotifierProvider.notifier);
      await notifier.retryLastMessage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isChatbot = widget.conversationId == 'chatbot';
    
    // Watch appropriate provider based on conversation type
    final chatbotState = isChatbot ? ref.watch(chatbotNotifierProvider) : null;
    final messagesAsync = isChatbot 
        ? chatbotState!.messages 
        : ref.watch(messageNotifierProvider(widget.conversationId));

    // Scroll to bottom when messages are first loaded or typing indicator appears
    if (isChatbot) {
      ref.listen<ChatbotState>(
        chatbotNotifierProvider,
        (previous, next) {
          final shouldScroll = (next.messages.hasValue && 
              (next.messages.value?.isNotEmpty ?? false)) || 
              next.isTyping;
          if (!_hasScrolledToBottom && shouldScroll) {
            _hasScrolledToBottom = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollToBottom();
            });
          }
          // Also scroll when typing starts
          if (next.isTyping && !(previous?.isTyping ?? false)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollToBottom();
            });
          }
        },
      );
    } else {
      ref.listen<AsyncValue<List<Message>>>(
        messageNotifierProvider(widget.conversationId),
        (previous, next) {
          if (!_hasScrolledToBottom && next.hasValue && next.value!.isNotEmpty) {
            _hasScrolledToBottom = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollToBottom();
            });
          }
        },
      );
    }

    if (_conversation == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final seller = _conversation!.seller;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: [
            // Avatar
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getAvatarColor(seller.name),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  _getInitials(seller.name),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    seller.username,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          // More options
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages area
          Expanded(
            child: messagesAsync.when(
              data: (messages) {
                if (messages.isEmpty && !(isChatbot && (chatbotState?.isTyping ?? false))) {
                  // Show error with retry if chatbot and there's an error
                  if (isChatbot && chatbotState != null && chatbotState!.lastError != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Có lỗi xảy ra',
                            style: TextStyle(color: Colors.grey[600], fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _retryLastMessage,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Thử lại'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4CAF50),
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Center(
                    child: Text(
                      'Chưa có tin nhắn',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  );
                }
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length + (isChatbot && (chatbotState?.isTyping ?? false) ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Show typing indicator as last item if typing
                    if (isChatbot && (chatbotState?.isTyping ?? false) && index == messages.length) {
                      return const TypingIndicator();
                    }
                    return _buildMessageBubble(messages[index]);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) {
                // For chatbot, show error with retry button
                if (isChatbot && chatbotState != null && chatbotState!.lastFailedMessage != null) {
                  final messages = chatbotState!.messages.value ?? [];
                  return Column(
                    children: [
                      Expanded(
                        child: messages.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Có lỗi xảy ra: ${error.toString().replaceFirst('Exception: ', '')}',
                                      style: TextStyle(color: Colors.grey[600], fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton.icon(
                                      onPressed: _retryLastMessage,
                                      icon: const Icon(Icons.refresh),
                                      label: const Text('Thử lại'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF4CAF50),
                                        foregroundColor: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                controller: _scrollController,
                                padding: const EdgeInsets.all(16),
                                itemCount: messages.length + ((chatbotState?.isTyping ?? false) ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if ((chatbotState?.isTyping ?? false) && index == messages.length) {
                                    return const TypingIndicator();
                                  }
                                  return _buildMessageBubble(messages[index]);
                                },
                              ),
                      ),
                      // Show error banner at bottom if there are messages
                      if (messages.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(12),
                          color: Colors.red[50],
                          child: Row(
                            children: [
                              Icon(Icons.error_outline, color: Colors.red[700], size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Gửi tin nhắn thất bại',
                                  style: TextStyle(color: Colors.red[700], fontSize: 14),
                                ),
                              ),
                              TextButton(
                                onPressed: _retryLastMessage,
                                child: const Text('Thử lại', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        ),
                    ],
                  );
                }
                // For non-chatbot, show simple error
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Có lỗi xảy ra',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Input area
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // Text input
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Soạn tin...',
                          hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                        ),
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Send button with arrow icon
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_upward, color: Colors.white, size: 20),
                      onPressed: (isChatbot && (chatbotState?.isTyping ?? false)) ? null : _sendMessage,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message) {
    final isUser = message.messageType == MessageType.user;
    final timeFormat = DateFormat('HH:mm');
    final timeText = timeFormat.format(message.timestamp);

    if (message.messageType == MessageType.system) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              message.content,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
              ),
            ),
          ),
        ),
      );
    }

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isUser ? const Color(0xFF4CAF50) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Text(
                message.content,
                style: TextStyle(
                  fontSize: 14,
                  color: isUser ? Colors.white : Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  timeText,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[500],
                  ),
                ),
                if (isUser && message.isDelivered) ...[
                  const SizedBox(width: 4),
                  Icon(
                    Icons.check,
                    size: 14,
                    color: Colors.grey[500],
                  ),
                  Icon(
                    Icons.check,
                    size: 14,
                    color: Colors.grey[500],
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final words = name.split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[words.length - 1][0]}'.toUpperCase();
    }
    return name.length >= 2 ? name.substring(0, 2).toUpperCase() : name.toUpperCase();
  }

  Color _getAvatarColor(String name) {
    final colors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
      Colors.amber,
    ];
    final index = name.hashCode % colors.length;
    return colors[index.abs()];
  }
}

