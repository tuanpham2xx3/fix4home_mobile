import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/gradient_header.dart';
import '../../../data/services/notification_service.dart';
import '../../../domain/models/notification_item.dart';
import '../../../domain/repositories/notification_repository.dart';
import '../../../data/repositories/api_notification_repository.dart';
import '../../../core/services/api_client.dart';
import 'main_navigation.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiNotificationRepository(dio);
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return NotificationService(repository);
});

final unreadCountProvider = FutureProvider<int>((ref) async {
  final service = ref.watch(notificationServiceProvider);
  return service.getUnreadCount();
});

final notificationsProvider = FutureProvider<List<NotificationItem>>((ref) async {
  final service = ref.watch(notificationServiceProvider);
  return service.getAllNotifications();
});

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    // Auto-refresh unread count every 30 seconds
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (mounted) {
        ref.refresh(unreadCountProvider);
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notificationsAsync = ref.watch(notificationsProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            GradientHeader(
              title: 'Thông báo',
              showBackButton: true,
              actions: [
                Consumer(
                  builder: (context, ref, _) {
                    final unreadCountAsync = ref.watch(unreadCountProvider);
                    return unreadCountAsync.when(
                      data: (unreadCount) {
                        if (unreadCount == 0) {
                          return const SizedBox.shrink();
                        }
                        return TextButton(
                          onPressed: () async {
                            final service = ref.read(notificationServiceProvider);
                            await service.markAllAsRead();
                            ref.invalidate(notificationsProvider);
                            ref.invalidate(unreadCountProvider);
                          },
                          child: const Text(
                            'Đọc tất cả',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      },
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    );
                  },
                ),
              ],
            ),
            Expanded(
              child: notificationsAsync.when(
                data: (notifications) {
                  if (notifications.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications_none,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Chưa có thông báo',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      ref.invalidate(notificationsProvider);
                      ref.invalidate(unreadCountProvider);
                      // Wait for refresh to complete
                      try {
                        await ref.read(notificationsProvider.future);
                        await ref.read(unreadCountProvider.future);
                      } catch (_) {
                        // Ignore errors during refresh
                      }
                    },
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      itemBuilder: (context, index) {
                        final notification = notifications[index];
                        return _NotificationCard(
                          notification: notification,
                          onTap: () async {
                            // Handle navigation based on actionUrl
                            if (notification.actionUrl != null) {
                              if (notification.actionUrl == '/bookings') {
                                // Navigate to bookings screen (index 1 in MainNavigation)
                                ref.read(selectedIndexProvider.notifier).state = 1;
                                // Go back to home if we're not already there
                                if (context.canPop()) {
                                  context.pop();
                                } else {
                                  context.go('/home');
                                }
                              } else {
                                // For other actionUrls, use push navigation
                                context.push(notification.actionUrl!);
                              }
                            }
                            if (!notification.isRead) {
                              await ref
                                  .read(notificationServiceProvider)
                                  .markAsRead(notification.id);
                              ref.invalidate(notificationsProvider);
                              ref.invalidate(unreadCountProvider);
                            }
                          },
                          onDelete: () async {
                            await ref
                                .read(notificationServiceProvider)
                                .deleteNotification(notification.id);
                            ref.invalidate(notificationsProvider);
                            ref.invalidate(unreadCountProvider);
                          },
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemCount: notifications.length,
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Lỗi tải thông báo',
                        style: TextStyle(color: Colors.red[700]),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          ref.invalidate(notificationsProvider);
                        },
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _NotificationCard({
    required this.notification,
    required this.onTap,
    required this.onDelete,
  });

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Vừa xong';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} phút trước';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ngày trước';
    } else {
      return DateFormat('dd/MM/yyyy').format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: notification.isRead ? Colors.white : Colors.blue[50],
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: notification.isRead
                      ? Colors.grey[200]
                      : const Color(0xFFFFC107).withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getNotificationIcon(notification.title),
                  color: notification.isRead
                      ? Colors.grey[600]
                      : const Color(0xFFFFC107),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  notification.isRead
                                      ? FontWeight.w500
                                      : FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFC107),
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatDateTime(notification.createdAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                color: Colors.grey[600],
                onPressed: onDelete,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getNotificationIcon(String title) {
    if (title.toLowerCase().contains('đặt lịch') ||
        title.toLowerCase().contains('thành công')) {
      return Icons.check_circle_outline;
    } else if (title.toLowerCase().contains('thợ')) {
      return Icons.person_outline;
    } else if (title.toLowerCase().contains('tin nhắn')) {
      return Icons.message_outlined;
    } else if (title.toLowerCase().contains('khuyến mãi') ||
        title.toLowerCase().contains('ưu đãi')) {
      return Icons.local_offer_outlined;
    } else if (title.toLowerCase().contains('thanh toán')) {
      return Icons.payment_outlined;
    } else if (title.toLowerCase().contains('cập nhật')) {
      return Icons.system_update_outlined;
    }
    return Icons.notifications_outlined;
  }
}

