import '../../domain/models/notification_item.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // Mock notifications data
  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      title: 'Đặt lịch thành công',
      message: 'Bạn đã đặt lịch dịch vụ "Sửa chữa điện nước" thành công. Thợ sẽ liên hệ với bạn trong vòng 30 phút.',
      createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
      isRead: false,
      actionUrl: '/bookings',
    ),
    NotificationItem(
      id: '2',
      title: 'Thợ đã nhận đơn',
      message: 'Thợ Nguyễn Văn A đã nhận đơn dịch vụ của bạn. Vui lòng chuẩn bị sẵn sàng.',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
      actionUrl: '/bookings',
    ),
    NotificationItem(
      id: '3',
      title: 'Thợ đang trên đường',
      message: 'Thợ đã xuất phát và sẽ đến địa chỉ của bạn trong khoảng 20 phút nữa.',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: true,
      actionUrl: '/bookings',
    ),
    NotificationItem(
      id: '4',
      title: 'Hoàn thành dịch vụ',
      message: 'Dịch vụ "Sửa chữa điện nước" đã được hoàn thành. Vui lòng đánh giá dịch vụ.',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      actionUrl: '/bookings',
    ),
    NotificationItem(
      id: '5',
      title: 'Tin nhắn mới',
      message: 'Bạn có tin nhắn mới từ Thợ Việt. Vui lòng kiểm tra hộp thư.',
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
      isRead: true,
      actionUrl: '/home',
    ),
    NotificationItem(
      id: '6',
      title: 'Khuyến mãi đặc biệt',
      message: 'Giảm 20% cho dịch vụ chống thấm trong tháng này. Đặt ngay để nhận ưu đãi!',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      isRead: false,
      actionUrl: '/home',
    ),
    NotificationItem(
      id: '7',
      title: 'Nhắc nhở thanh toán',
      message: 'Bạn có một hóa đơn chưa thanh toán. Vui lòng thanh toán để tiếp tục sử dụng dịch vụ.',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      isRead: true,
      actionUrl: '/bookings',
    ),
    NotificationItem(
      id: '8',
      title: 'Cập nhật ứng dụng',
      message: 'Phiên bản mới của ứng dụng đã có sẵn. Cập nhật ngay để trải nghiệm các tính năng mới.',
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
      isRead: false,
      actionUrl: null,
    ),
  ];

  Future<List<NotificationItem>> getAllNotifications() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_notifications);
  }

  Future<List<NotificationItem>> getUnreadNotifications() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _notifications.where((n) => !n.isRead).toList();
  }

  Future<void> markAsRead(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = NotificationItem(
        id: _notifications[index].id,
        title: _notifications[index].title,
        message: _notifications[index].message,
        createdAt: _notifications[index].createdAt,
        isRead: true,
        imageUrl: _notifications[index].imageUrl,
        actionUrl: _notifications[index].actionUrl,
      );
    }
  }

  Future<void> markAllAsRead() async {
    await Future.delayed(const Duration(milliseconds: 200));
    for (int i = 0; i < _notifications.length; i++) {
      if (!_notifications[i].isRead) {
        _notifications[i] = NotificationItem(
          id: _notifications[i].id,
          title: _notifications[i].title,
          message: _notifications[i].message,
          createdAt: _notifications[i].createdAt,
          isRead: true,
          imageUrl: _notifications[i].imageUrl,
          actionUrl: _notifications[i].actionUrl,
        );
      }
    }
  }

  Future<void> deleteNotification(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _notifications.removeWhere((n) => n.id == id);
  }

  int get unreadCount => _notifications.where((n) => !n.isRead).length;
}

