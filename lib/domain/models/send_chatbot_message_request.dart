class SendChatbotMessageRequest {
  final String message; // User message (required)
  final String? sessionId; // Optional: 8-digit sessionId

  SendChatbotMessageRequest({
    required this.message,
    this.sessionId,
  });

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      if (sessionId != null) 'sessionId': sessionId,
    };
  }
}

