import '../models/notification_dto.dart';
import '../models/page.dart';

abstract class NotificationRepository {
  /// Lấy danh sách thông báo của user với phân trang và filter
  Future<Page<NotificationDTO>> getMyNotifications({
    int page = 0,
    int size = 20,
    String? sortBy,
    String? sortDir,
    bool? isRead,
  });

  /// Lấy số lượng thông báo chưa đọc
  Future<int> getUnreadCount();

  /// Lấy chi tiết một thông báo
  Future<NotificationDTO> getNotificationById(int notificationId);

  /// Đánh dấu thông báo đã đọc
  Future<NotificationDTO> markAsRead(int notificationId);

  /// Đánh dấu tất cả thông báo đã đọc
  Future<int> markAllAsRead();

  /// Đánh dấu nhiều thông báo (bulk)
  Future<int> markNotifications({
    required bool isRead,
    int? notificationId,
    List<int>? notificationIds,
    bool? markAll,
  });

  /// Xóa một thông báo
  Future<void> deleteNotification(int notificationId);

  /// Xóa tất cả thông báo đã đọc
  Future<int> deleteReadNotifications();

  /// Tìm kiếm thông báo
  Future<Page<NotificationDTO>> searchNotifications({
    required String keyword,
    int page = 0,
    int size = 20,
  });

  /// Lấy thông báo gần đây
  Future<List<NotificationDTO>> getRecentNotifications({int days = 7});
}

