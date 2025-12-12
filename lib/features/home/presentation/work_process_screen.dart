import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/gradient_header.dart';

class WorkProcessScreen extends StatelessWidget {
  const WorkProcessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Yellow gradient header with back button
            GradientHeader(
              title: 'Quy trình làm việc',
              showBackButton: true,
            ),
            // Content area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Steps 1-7
                    _buildStep(
                      stepNumber: 1,
                      icon: Icons.calendar_today,
                      title: 'Chọn dịch vụ & đặt lịch',
                      description:
                          'Chọn dịch vụ, ngày giờ theo theo thời gian của Khách hàng và tạo lịch hẹn.',
                      isFirst: true,
                    ),
                    _buildStep(
                      stepNumber: 2,
                      icon: Icons.phone,
                      title: 'Trao đổi & tư vấn',
                      description:
                          'Thợ sẽ liên hệ trao đổi, tư vấn chi tiết về dịch vụ, khoảng giá, thời gian thi công.',
                    ),
                    _buildStep(
                      stepNumber: 3,
                      icon: Icons.home,
                      title: 'Khảo sát & báo giá',
                      description:
                          'Thợ đến tận nhà để khảo sát thực tế, báo giá chính xác chi phí không phát sinh, quy trình này hoàn toàn miễn phí.',
                    ),
                    _buildStep(
                      stepNumber: 4,
                      icon: Icons.check_circle,
                      title: 'Đồng ý & thi công',
                      description:
                          'Khách hàng đồng ý, thợ sẽ tiến hành thi công dịch vụ theo đúng yêu cầu và thời gian đã trao đổi.',
                    ),
                    _buildStep(
                      stepNumber: 5,
                      icon: Icons.visibility,
                      title: 'Kiểm tra & nghiệm thu',
                      description:
                          'Khách hàng nghiệm thu những hạng mục đã thi công và kiểm tra chất lượng dịch vụ.',
                    ),
                    _buildStep(
                      stepNumber: 6,
                      icon: Icons.star,
                      title: 'Xác nhận & đánh giá',
                      description:
                          'Khách hàng xác nhận hoàn thành, đánh giá chất lượng dịch vụ, mức độ hài lòng, FIX4HOME luôn lắng nghe và cải thiện dịch vụ.',
                    ),
                    _buildStep(
                      stepNumber: 7,
                      icon: Icons.check_circle,
                      title: 'Bảo hành & hậu mãi',
                      description:
                          'Thông tin bảo hành điện tử sẽ được cập nhật trong ứng dụng FIX4HOME, luôn có chế độ hậu mãi và hỗ trợ Khách hàng khi hết bảo hành.',
                      isLast: true,
                    ),
                    const SizedBox(height: 30),
                    // Quality Commitment Section
                    _buildQualityCommitment(),
                    const SizedBox(height: 30),
                    // Book Now Button
                    _buildBookNowButton(context),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep({
    required int stepNumber,
    required IconData icon,
    required String title,
    required String description,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline column
          Column(
            children: [
              if (!isFirst)
                Container(
                  width: 2,
                  height: 20,
                  color: const Color(0xFFFFC107),
                ),
              // Step number circle
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFC107),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$stepNumber',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: const Color(0xFFFFC107),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Content card
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFC107).withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          icon,
                          color: const Color(0xFFFFC107),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQualityCommitment() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFC107),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    'i',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Cam kết chất lượng',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'FIX4HOME cam kết mang đến dịch vụ chất lượng tốt nhất với quy trình làm việc chuẩn hóa, đội ngũ thợ chuyên nghiệp và chính sách bảo hành rõ ràng, trường hợp nếu không xử lý dứt điểm, FIX4HOME sẵn sàng hoàn trả tiền cho Quý Khách hàng. Công ty chân thành cảm ơn Quý Khách hàng!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookNowButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          context.push('/quick-booking');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFC107),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Đặt lịch ngay',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}

