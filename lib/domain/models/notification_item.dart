class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime createdAt;
  final bool isRead;
  final String? imageUrl;
  final String? actionUrl; // URL để điều hướng khi tap vào notification

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    this.isRead = false,
    this.imageUrl,
    this.actionUrl,
  });
}

