class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final DateTime timestamp;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    required this.timestamp,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json, {
    T Function(Object? json)? fromJsonT,
  }) {
    return ApiResponse<T>(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: fromJsonT != null ? fromJsonT(json['data']) : json['data'] as T?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}

class PageResponse<T> {
  final List<T> content;
  final int totalElements;
  final int totalPages;
  final int size;
  final int number;
  final bool first;
  final bool last;

  PageResponse({
    required this.content,
    required this.totalElements,
    required this.totalPages,
    required this.size,
    required this.number,
    required this.first,
    required this.last,
  });

  factory PageResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic> json) fromJsonT,
  ) {
    return PageResponse<T>(
      content: (json['content'] as List<dynamic>)
          .map((e) => fromJsonT(e as Map<String, dynamic>))
          .toList(),
      totalElements: json['totalElements'] as int,
      totalPages: json['totalPages'] as int,
      size: json['size'] as int,
      number: json['number'] as int,
      first: json['first'] as bool? ?? false,
      last: json['last'] as bool? ?? false,
    );
  }
}

class ParticipantDTO {
  final int userId;
  final String username;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final bool isOnline;

  ParticipantDTO({
    required this.userId,
    required this.username,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    required this.isOnline,
  });

  factory ParticipantDTO.fromJson(Map<String, dynamic> json) {
    return ParticipantDTO(
      userId: json['userId'] as int,
      username: json['username'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      isOnline: json['isOnline'] as bool? ?? false,
    );
  }
}

class MessagePreviewDTO {
  final int id;
  final String content;
  final String messageType;
  final String senderName;
  final DateTime sentAt;
  final bool isRead;

  MessagePreviewDTO({
    required this.id,
    required this.content,
    required this.messageType,
    required this.senderName,
    required this.sentAt,
    required this.isRead,
  });

  factory MessagePreviewDTO.fromJson(Map<String, dynamic> json) {
    return MessagePreviewDTO(
      id: json['id'] as int,
      content: json['content'] as String,
      messageType: json['messageType'] as String,
      senderName: json['senderName'] as String,
      sentAt: DateTime.parse(json['sentAt'] as String),
      isRead: json['isRead'] as bool? ?? false,
    );
  }
}

class ConversationDTO {
  final int id;
  final String status;
  final String conversationType;
  final DateTime? lastMessageAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? serviceRequestId;
  final int? servicePostId;
  final int? consultationId;
  final ParticipantDTO customer;
  final ParticipantDTO technician;
  final MessagePreviewDTO? lastMessage;
  final int unreadCount;

  ConversationDTO({
    required this.id,
    required this.status,
    required this.conversationType,
    this.lastMessageAt,
    required this.createdAt,
    required this.updatedAt,
    this.serviceRequestId,
    this.servicePostId,
    this.consultationId,
    required this.customer,
    required this.technician,
    this.lastMessage,
    required this.unreadCount,
  });

  factory ConversationDTO.fromJson(Map<String, dynamic> json) {
    return ConversationDTO(
      id: json['id'] as int,
      status: json['status'] as String,
      conversationType: json['conversationType'] as String,
      lastMessageAt: json['lastMessageAt'] != null
          ? DateTime.parse(json['lastMessageAt'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      serviceRequestId: json['serviceRequestId'] as int?,
      servicePostId: json['servicePostId'] as int?,
      consultationId: json['consultationId'] as int?,
      customer: ParticipantDTO.fromJson(
        json['customer'] as Map<String, dynamic>,
      ),
      technician: ParticipantDTO.fromJson(
        json['technician'] as Map<String, dynamic>,
      ),
      lastMessage: json['lastMessage'] != null
          ? MessagePreviewDTO.fromJson(
              json['lastMessage'] as Map<String, dynamic>,
            )
          : null,
      unreadCount: json['unreadCount'] as int? ?? 0,
    );
  }
}

class SenderDTO {
  final int userId;
  final String username;
  final String fullName;
  final String role;

  SenderDTO({
    required this.userId,
    required this.username,
    required this.fullName,
    required this.role,
  });

  factory SenderDTO.fromJson(Map<String, dynamic> json) {
    return SenderDTO(
      userId: json['userId'] as int,
      username: json['username'] as String,
      fullName: json['fullName'] as String,
      role: json['role'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'fullName': fullName,
      'role': role,
    };
  }
}

class MessageDTO {
  final int id;
  final int conversationId;
  final String content;
  final String messageType;
  final String? attachmentUrl;
  final String? metadata;
  final bool isRead;
  final DateTime sentAt;
  final SenderDTO? sender;

  MessageDTO({
    required this.id,
    required this.conversationId,
    required this.content,
    required this.messageType,
    this.attachmentUrl,
    this.metadata,
    required this.isRead,
    required this.sentAt,
    this.sender,
  });

  factory MessageDTO.fromJson(Map<String, dynamic> json) {
    return MessageDTO(
      id: json['id'] as int,
      conversationId: json['conversationId'] as int,
      content: json['content'] as String,
      messageType: json['messageType'] as String,
      attachmentUrl: json['attachmentUrl'] as String?,
      metadata: json['metadata'] as String?,
      isRead: json['isRead'] as bool? ?? false,
      sentAt: DateTime.parse(json['sentAt'] as String),
      sender: json['sender'] != null
          ? SenderDTO.fromJson(json['sender'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversationId': conversationId,
      'content': content,
      'messageType': messageType,
      'attachmentUrl': attachmentUrl,
      'metadata': metadata,
      'isRead': isRead,
      'sentAt': sentAt.toIso8601String(),
      'sender': sender?.toJson(),
    };
  }
}

class ChatbotSendResponse {
  final String sessionId;
  final int messageId;
  final bool messageSent;
  final bool newSessionCreated;

  ChatbotSendResponse({
    required this.sessionId,
    required this.messageId,
    required this.messageSent,
    required this.newSessionCreated,
  });

  factory ChatbotSendResponse.fromJson(Map<String, dynamic> json) {
    return ChatbotSendResponse(
      sessionId: json['sessionId'] as String,
      messageId: json['messageId'] as int,
      messageSent: json['messageSent'] as bool? ?? false,
      newSessionCreated: json['newSessionCreated'] as bool? ?? false,
    );
  }
}


