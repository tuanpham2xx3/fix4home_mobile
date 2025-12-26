import '../../domain/models/notification_item.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../domain/models/notification_dto.dart';

class NotificationService {
  final NotificationRepository _repository;

  NotificationService(this._repository);

  // Helper method to convert NotificationDTO to NotificationItem
  NotificationItem _notificationDtoToItem(NotificationDTO dto) {
    // Map notification type to action URL if needed
    String? actionUrl;
    // Check if it's a booking-related notification (by title or message)
    final titleLower = dto.title.toLowerCase();
    final messageLower = dto.message.toLowerCase();
    if (dto.type == 'SUCCESS' && 
        (titleLower.contains('đặt lịch') || messageLower.contains('đặt lịch'))) {
      actionUrl = '/bookings';
    }

    return NotificationItem(
      id: dto.id.toString(),
      title: dto.title,
      message: dto.message,
      createdAt: dto.createdAt,
      isRead: dto.isRead,
      imageUrl: null, // API doesn't provide imageUrl currently
      actionUrl: actionUrl,
    );
  }

  Future<List<NotificationItem>> getAllNotifications() async {
    try {
      final page = await _repository.getMyNotifications(
        page: 0,
        size: 100, // Get up to 100 notifications
        sortBy: 'createdAt',
        sortDir: 'desc',
      );
      return page.content.map(_notificationDtoToItem).toList();
    } catch (e) {
      // Return empty list on error (UI will handle error states)
      return [];
    }
  }

  Future<List<NotificationItem>> getUnreadNotifications() async {
    try {
      final page = await _repository.getMyNotifications(
        page: 0,
        size: 100,
        sortBy: 'createdAt',
        sortDir: 'desc',
        isRead: false,
      );
      return page.content.map(_notificationDtoToItem).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      final notificationId = int.parse(id);
      await _repository.markAsRead(notificationId);
    } catch (e) {
      // Error handling - UI will handle if needed
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await _repository.markAllAsRead();
    } catch (e) {
      // Error handling
    }
  }

  Future<void> deleteNotification(String id) async {
    try {
      final notificationId = int.parse(id);
      await _repository.deleteNotification(notificationId);
    } catch (e) {
      // Error handling
    }
  }

  Future<int> getUnreadCount() async {
    try {
      return await _repository.getUnreadCount();
    } catch (e) {
      return 0;
    }
  }

  // Expose repository for direct access if needed
  NotificationRepository get repository => _repository;
}
