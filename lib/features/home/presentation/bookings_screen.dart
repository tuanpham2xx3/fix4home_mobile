import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../domain/models/booking.dart';
import '../../../domain/models/notification_message.dart';
import '../application/booking_provider.dart';
import '../../shared/application/notification_provider.dart';
import '../../../core/widgets/gradient_header.dart';
import 'main_navigation.dart';

class BookingsScreen extends ConsumerStatefulWidget {
  const BookingsScreen({super.key});

  @override
  ConsumerState<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends ConsumerState<BookingsScreen> {
  int _selectedTab = 0; // 0: Đã đặt, 1: Đã làm

  void _cancelBooking(String bookingId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận hủy lịch'),
        content: const Text('Quý Khách có chắc chắn muốn hủy lịch hẹn này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(bookingProvider.notifier).cancelBooking(bookingId);
              
              // Navigate to home and switch to home tab
              if (context.mounted) {
                ref.read(selectedIndexProvider.notifier).state = 0;
                context.go('/home');
                
                // Show success notification after navigation
                Future.delayed(const Duration(milliseconds: 300), () {
                  ref.read(notificationProvider.notifier).showNotification(
                    NotificationMessage(
                      title: 'Thành công',
                      message: 'Huỷ lịch hẹn thành công!',
                      type: NotificationType.success,
                    ),
                  );
                });
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFC107),
              foregroundColor: Colors.white,
            ),
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookings = ref.watch(bookingProvider);
    final pendingBookings = bookings.where((b) => b.status == BookingStatus.pending).toList();
    final completedBookings = bookings.where((b) => b.status == BookingStatus.completed).toList();
    
    final displayedBookings = _selectedTab == 0 ? pendingBookings : completedBookings;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Yellow gradient header
            const GradientHeader(
              title: 'Lịch sử công việc',
            ),
            
            // Tab navigation
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTab = 0;
                        });
                      },
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              'Đã đặt',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: _selectedTab == 0
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          if (_selectedTab == 0)
                            Container(
                              height: 3,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFFC107),
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(2),
                                ),
                              ),
                            )
                          else
                            const SizedBox(height: 3),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTab = 1;
                        });
                      },
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              'Đã làm',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: _selectedTab == 1
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          if (_selectedTab == 1)
                            Container(
                              height: 3,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFFC107),
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(2),
                                ),
                              ),
                            )
                          else
                            const SizedBox(height: 3),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Content area
            Expanded(
              child: displayedBookings.isEmpty
                  ? Center(
                      child: Text(
                        'Quý Khách chưa có lịch hẹn nào',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: displayedBookings.length,
                      itemBuilder: (context, index) {
                        final booking = displayedBookings[index];
                        return _buildBookingCard(booking);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBookingDetails(Booking booking) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _BookingDetailsBottomSheet(booking: booking),
    );
  }

  Widget _buildBookingCard(Booking booking) {
    return GestureDetector(
      onTap: () => _showBookingDetails(booking),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Job ID
                    Text(
                      '#${booking.id}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFFFFC107),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Job Title
                    Text(
                      booking.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Address
                    Text(
                      'Địa chỉ: ${booking.address}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Time
                    Text(
                      'Thời gian: ${booking.formattedDate}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              // Status and Cancel Button
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Status
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: booking.status == BookingStatus.pending
                              ? const Color(0xFFFFC107)
                              : booking.status == BookingStatus.completed
                                  ? Colors.green
                                  : Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        booking.statusText,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  // Cancel Button (only for pending bookings)
                  if (booking.status == BookingStatus.pending) ...[
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => _cancelBooking(booking.id),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 18,
                            height: 18,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 12,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'Hủy lịch',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }
}

class _BookingDetailsBottomSheet extends StatelessWidget {
  final Booking booking;

  const _BookingDetailsBottomSheet({required this.booking});

  String _extractJobContent(String title) {
    // Extract job content before parentheses
    final match = RegExp(r'^([^(]+)').firstMatch(title);
    return match != null ? match.group(1)!.trim() : title;
  }

  String? _extractDiscount(String title) {
    // Extract discount info from parentheses
    final match = RegExp(r'\(([^)]+)\)').firstMatch(title);
    if (match != null) {
      final content = match.group(1)!;
      if (content.toLowerCase().contains('giảm giá') || 
          content.toLowerCase().contains('discount')) {
        return content;
      }
    }
    return null;
  }

  String _formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final jobContent = _extractJobContent(booking.title);
    final discount = _extractDiscount(booking.title);
    final timeStr = _formatTime(booking.date);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFC107),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.description,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Chi tiết lịch hẹn',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Thông tin chi tiết về lịch đặt hẹn',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Job Content
                  _buildDetailItem(
                    icon: Icons.description,
                    label: 'Nội dung công việc',
                    value: jobContent,
                  ),
                  const SizedBox(height: 20),
                  // Address
                  _buildDetailItem(
                    icon: Icons.location_on,
                    label: 'Địa chỉ',
                    value: booking.address,
                  ),
                  const SizedBox(height: 20),
                  // Time (with hour and date)
                  _buildDetailItem(
                    icon: Icons.calendar_today,
                    label: 'Thời gian',
                    value: '$timeStr ${booking.formattedDate}',
                  ),
                  // Discount (if exists)
                  if (discount != null) ...[
                    const SizedBox(height: 20),
                    _buildDetailItem(
                      icon: Icons.percent,
                      label: 'Giảm giá',
                      value: discount,
                    ),
                  ],
                  // Notes (if exists)
                  if (booking.notes != null && booking.notes!.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    _buildDetailItem(
                      icon: Icons.note,
                      label: 'Ghi chú',
                      value: booking.notes!,
                    ),
                  ],
                  const SizedBox(height: 40),
                  // Remind technician button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Implement remind technician functionality
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Đã gửi yêu cầu nhắc thợ gọi'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFC107),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.phone, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Nhắc thợ gọi',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).padding.bottom),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFFFC107).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: const Color(0xFFFFC107),
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
