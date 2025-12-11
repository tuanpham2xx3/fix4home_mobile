import 'package:flutter/material.dart';

enum NotificationType {
  success,
  error,
  warning,
  info,
}

class NotificationMessage {
  final String title;
  final String message;
  final NotificationType type;
  final Duration? duration;

  NotificationMessage({
    required this.title,
    required this.message,
    required this.type,
    this.duration,
  });

  Color get backgroundColor {
    switch (type) {
      case NotificationType.success:
        return Colors.green;
      case NotificationType.error:
        return Colors.red;
      case NotificationType.warning:
        return Colors.orange;
      case NotificationType.info:
        return Colors.blue;
    }
  }

  Color get iconBackgroundColor {
    switch (type) {
      case NotificationType.success:
        return Colors.green.shade100;
      case NotificationType.error:
        return Colors.red.shade100;
      case NotificationType.warning:
        return Colors.orange.shade100;
      case NotificationType.info:
        return Colors.blue.shade100;
    }
  }

  IconData get icon {
    switch (type) {
      case NotificationType.success:
        return Icons.check;
      case NotificationType.error:
        return Icons.error;
      case NotificationType.warning:
        return Icons.warning;
      case NotificationType.info:
        return Icons.info;
    }
  }
}

