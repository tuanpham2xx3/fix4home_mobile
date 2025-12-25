import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/models/message.dart';

class ChatbotState {
  final AsyncValue<List<Message>> messages;
  final String? sessionId; // Current session ID from backend
  final bool isTyping; // Whether bot is typing
  final String? lastFailedMessage; // Last message that failed (for retry)
  final String? lastFailedSessionId; // Session ID when last message failed
  final Object? lastError; // Last error that occurred
  final StackTrace? lastStackTrace; // Stack trace for last error

  ChatbotState({
    required this.messages,
    this.sessionId,
    this.isTyping = false,
    this.lastFailedMessage,
    this.lastFailedSessionId,
    this.lastError,
    this.lastStackTrace,
  });

  ChatbotState copyWith({
    AsyncValue<List<Message>>? messages,
    String? sessionId,
    bool? isTyping,
    String? lastFailedMessage,
    String? lastFailedSessionId,
    Object? lastError,
    StackTrace? lastStackTrace,
    bool clearError = false,
  }) {
    return ChatbotState(
      messages: messages ?? this.messages,
      sessionId: sessionId ?? this.sessionId,
      isTyping: isTyping ?? this.isTyping,
      lastFailedMessage: lastFailedMessage ?? this.lastFailedMessage,
      lastFailedSessionId: lastFailedSessionId ?? this.lastFailedSessionId,
      lastError: clearError ? null : (lastError ?? this.lastError),
      lastStackTrace: clearError ? null : (lastStackTrace ?? this.lastStackTrace),
    );
  }
}

