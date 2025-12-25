class ChatbotMessageResponse {
  final String output; // Bot response message
  final String sessionId; // Current session ID (8 digits)
  final int messageCount; // Number of message pairs in session
  final bool newSession; // Whether new session was created
  final DateTime timestamp; // Response timestamp

  ChatbotMessageResponse({
    required this.output,
    required this.sessionId,
    required this.messageCount,
    required this.newSession,
    required this.timestamp,
  });

  factory ChatbotMessageResponse.fromJson(Map<String, dynamic> json) {
    return ChatbotMessageResponse(
      output: json['output'] ?? '',
      sessionId: json['sessionId'] ?? '',
      messageCount: json['messageCount'] ?? 0,
      newSession: json['newSession'] ?? false,
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'output': output,
      'sessionId': sessionId,
      'messageCount': messageCount,
      'newSession': newSession,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

