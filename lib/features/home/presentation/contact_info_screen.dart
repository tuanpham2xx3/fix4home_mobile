import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactInfoScreen extends StatelessWidget {
  const ContactInfoScreen({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri uri = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _sendEmail(String email) async {
    final Uri uri = Uri.parse('mailto:$email');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Yellow banner header with back button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: const BoxDecoration(
                color: Color(0xFFFFC107),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    left: 16,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black87,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const Text(
                    'Thông tin liên hệ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            // Content area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Company Information Section
                    _buildSectionTitle('Thông tin công ty'),
                    const SizedBox(height: 16),
                    _buildInfoCard(
                      icon: Icons.business,
                      label: 'Tên công ty',
                      value: 'CÔNG TY TNHH DỊCH VỤ KỸ THUẬT FIX4HOME',
                      iconShape: BoxShape.rectangle,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      icon: Icons.location_on,
                      label: 'Địa chỉ',
                      value: '25/6 Phùng Văn Cung, Phường Cầu Kiệu, TP Hồ Chí Minh, Việt Nam',
                      iconShape: BoxShape.circle,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      icon: Icons.location_on,
                      label: 'Văn phòng giao dịch',
                      value: '88 Đường 18, Phường Hiệp Bình, TP Hồ Chí Minh, Việt Nam',
                      iconShape: BoxShape.circle,
                    ),
                    const SizedBox(height: 12),
                    _buildBankAccountCard(),
                    const SizedBox(height: 24),
                    // Contact Information Section
                    _buildSectionTitle('Thông tin liên hệ'),
                    const SizedBox(height: 16),
                    _buildContactCard(
                      icon: Icons.email,
                      label: 'Email',
                      value: 'info@fix4home.com.vn',
                      iconShape: BoxShape.rectangle,
                      onTap: () => _sendEmail('info@fix4home.com.vn'),
                    ),
                    const SizedBox(height: 12),
                    _buildContactCard(
                      icon: Icons.phone,
                      label: 'Hotline',
                      value: '1800 8122',
                      iconShape: BoxShape.circle,
                      onTap: () => _makePhoneCall('18008122'),
                    ),
                    const SizedBox(height: 12),
                    _buildContactCard(
                      icon: Icons.headset_mic,
                      label: 'CSKH & Hỗ trợ',
                      value: '0915 269 839',
                      iconShape: BoxShape.circle,
                      onTap: () => _makePhoneCall('0915269839'),
                    ),
                    const SizedBox(height: 24),
                    // Social Media Section
                    _buildSectionTitle('Kết nối mạng xã hội'),
                    const SizedBox(height: 16),
                    _buildSocialMediaGrid(),
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required BoxShape iconShape,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF9C4),
              shape: iconShape,
              borderRadius: iconShape == BoxShape.rectangle
                  ? BorderRadius.circular(8)
                  : null,
            ),
            child: Icon(
              icon,
              color: const Color(0xFFFFC107),
              size: 24,
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
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankAccountCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF9C4),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.account_balance,
              color: Color(0xFFFFC107),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Số tài khoản',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '1190 0008 0546',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Ngân Hàng Công Thương Việt Nam',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  '– Chi nhánh 2 TP Hồ Chí Minh',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String label,
    required String value,
    required BoxShape iconShape,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF9C4),
                shape: iconShape,
                borderRadius: iconShape == BoxShape.rectangle
                    ? BorderRadius.circular(8)
                    : null,
              ),
              child: Icon(
                icon,
                color: const Color(0xFFFFC107),
                size: 24,
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
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialMediaGrid() {
    final socialMediaItems = [
      {
        'name': 'Website',
        'icon': Icons.language,
        'color': Colors.blue,
        'url': 'https://fix4home.com.vn',
      },
      {
        'name': 'Zalo',
        'icon': Icons.chat_bubble,
        'color': Colors.blue,
        'url': 'https://zalo.me/fix4home',
      },
      {
        'name': 'Facebook',
        'icon': Icons.facebook,
        'color': Colors.blue,
        'url': 'https://facebook.com/fix4home',
      },
      {
        'name': 'TikTok',
        'icon': Icons.music_note,
        'color': Colors.black,
        'url': 'https://tiktok.com/@fix4home',
      },
      {
        'name': 'YouTube',
        'icon': Icons.play_circle_filled,
        'color': Colors.red,
        'url': 'https://youtube.com/@fix4home',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: socialMediaItems.length,
      itemBuilder: (context, index) {
        final item = socialMediaItems[index];
        return InkWell(
          onTap: () => _launchURL(item['url'] as String),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: (item['color'] as Color).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item['icon'] as IconData,
                    color: item['color'] as Color,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item['name'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

