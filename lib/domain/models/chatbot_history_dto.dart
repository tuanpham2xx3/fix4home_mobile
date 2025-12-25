class ChatbotHistoryDTO {
  final int id;
  final String sessionId; // Session ID (8 digits)
  final String message; // Message content
  final String messageType; // "USER" or "BOT"
  final int pairSequence; // Sequence number of message pair
  final DateTime createdAt; // When message was created

  ChatbotHistoryDTO({
    required this.id,
    required this.sessionId,
    required this.message,
    required this.messageType,
    required this.pairSequence,
    required this.createdAt,
  });

  factory ChatbotHistoryDTO.fromJson(Map<String, dynamic> json) {
    return ChatbotHistoryDTO(
      id: json['id'],
      sessionId: json['sessionId'] ?? '',
      message: json['message'] ?? '',
      messageType: json['messageType'] ?? 'USER',
      pairSequence: json['pairSequence'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sessionId': sessionId,
      'message': message,
      'messageType': messageType,
      'pairSequence': pairSequence,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  bool get isUserMessage => messageType == 'USER';
  bool get isBotMessage => messageType == 'BOT';
}

