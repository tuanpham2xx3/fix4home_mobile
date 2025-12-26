class NotificationDTO {
  final int id;
  final int userId;
  final String title;
  final String message;
  final String type; // INFO, SUCCESS, WARNING, ERROR
  final bool isRead;
  final DateTime createdAt;
  final String? timeAgo;
  final String? userFullName;
  final String? userEmail;
  final String? category;
  final String? priority;

  NotificationDTO({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
    this.timeAgo,
    this.userFullName,
    this.userEmail,
    this.category,
    this.priority,
  });

  factory NotificationDTO.fromJson(Map<String, dynamic> json) {
    return NotificationDTO(
      id: json['id'] as int,
      userId: json['userId'] as int,
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? 'INFO',
      isRead: json['isRead'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      timeAgo: json['timeAgo'],
      userFullName: json['userFullName'],
      userEmail: json['userEmail'],
      category: json['category'],
      priority: json['priority'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'message': message,
      'type': type,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
      if (timeAgo != null) 'timeAgo': timeAgo,
      if (userFullName != null) 'userFullName': userFullName,
      if (userEmail != null) 'userEmail': userEmail,
      if (category != null) 'category': category,
      if (priority != null) 'priority': priority,
    };
  }
}

