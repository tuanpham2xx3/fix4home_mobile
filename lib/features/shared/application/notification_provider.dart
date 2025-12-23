import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/models/notification_message.dart';

class NotificationNotifier extends StateNotifier<NotificationMessage?> {
  NotificationNotifier() : super(null);

  void showNotification(NotificationMessage notification) {
    state = notification;
  }

  void clearNotification() {
    state = null;
  }
}

final notificationProvider = StateNotifierProvider<NotificationNotifier, NotificationMessage?>((ref) {
  return NotificationNotifier();
});






