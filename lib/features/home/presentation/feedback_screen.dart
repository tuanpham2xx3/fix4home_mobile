import 'package:flutter/material.dart';
import '../../../core/widgets/gradient_header.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _feedbackController = TextEditingController();
  final Set<int> _selectedOptions = {};

  final List<String> _feedbackOptions = [
    'Chất lượng công việc chưa đạt yêu cầu.',
    'Giá dịch vụ chưa minh bạch hoặc chưa hợp lý.',
    'Thợ có thái độ chưa chuyên nghiệp, thiếu tôn trọng Khách hàng.',
    'Trang phục, tác phong của thợ chưa chỉnh chu.',
    'Thợ đến trễ hoặc thay đổi lịch hẹn không báo trước.',
    'Không vệ sinh sau khi hoàn thành công việc.',
    'Không giải thích rõ nguyên nhân sự cố, tư vấn không đầy đủ.',
    'Không tuân thủ quy trình an toàn lao động.',
    'Bộ phận chăm sóc Khách hàng hỗ trợ chưa tốt.',
  ];

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _toggleOption(int index) {
    setState(() {
      if (_selectedOptions.contains(index)) {
        _selectedOptions.remove(index);
      } else {
        _selectedOptions.add(index);
      }
    });
  }

  void _submitFeedback() {
    if (_selectedOptions.isEmpty && _feedbackController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn hoặc nhập nội dung phản hồi.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Handle feedback submission
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cảm ơn bạn đã gửi phản hồi!'),
        backgroundColor: Color(0xFFFFC107),
      ),
    );

    // Clear form
    setState(() {
      _selectedOptions.clear();
      _feedbackController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Yellow gradient header
            GradientHeader(
              title: 'Góp ý dịch vụ',
              showBackButton: true,
            ),
            // Content area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Icon circle
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.2),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFC107),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.menu,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Title
                    const Text(
                      'Chia sẻ ý kiến',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Description
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Thông tin góp ý, khiếu nại của Quý Khách sẽ được gửi tới Ban Quản lý nhằm cải thiện chất lượng dịch vụ tốt hơn, Công ty xin chân thành cảm ơn!',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Feedback options list
                    ...List.generate(_feedbackOptions.length, (index) {
                      final isSelected = _selectedOptions.contains(index);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: () => _toggleOption(index),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                margin: const EdgeInsets.only(top: 2, right: 12),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFFFFC107)
                                      : const Color(0xFFFFC107),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isSelected ? Icons.check : Icons.add,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  _feedbackOptions[index],
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    fontWeight: isSelected
                                        ? FontWeight.w500
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 20),
                    // Instructional text
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Quý Khách vui lòng chọn nội dung gợi ý phía trên hoặc nhập nội dung phản hồi.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Feedback input section
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.edit,
                                color: Color(0xFFFFC107),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Nội dung phản hồi',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _feedbackController,
                            maxLines: 6,
                            decoration: InputDecoration(
                              hintText:
                                  'Vui lòng chia sẻ ý kiến của Quý Khách về chất lượng dịch vụ, giá cả, quy trình làm việc, thái độ của thợ hoặc bất kỳ góp ý nào để chúng tôi cải thiện...',
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                                height: 1.5,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xFFFFC107),
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.all(12),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitFeedback,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade300,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Gửi phản hồi',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
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
}
