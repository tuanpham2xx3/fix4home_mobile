import 'package:flutter/material.dart';

class MembershipScreen extends StatelessWidget {
  const MembershipScreen({super.key});

  String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  @override
  Widget build(BuildContext context) {
    // Mock data - in real app, this would come from API/state
    const int currentPoints = 0;
    const String currentLevel = 'Thành viên';
    const int nextLevelPoints = 1000;
    const String nextLevel = 'Bạc';

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
                    'Chương trình thành viên',
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
                    // Upgrade Progress Section
                    _buildUpgradeProgressSection(
                      currentLevel: currentLevel,
                      currentPoints: currentPoints,
                      nextLevel: nextLevel,
                      nextLevelPoints: nextLevelPoints,
                    ),
                    const SizedBox(height: 24),
                    // Member Benefits Section
                    _buildMemberBenefitsSection(),
                    const SizedBox(height: 24),
                    // Member Ranks Section
                    _buildMemberRanksSection(
                      currentLevel: currentLevel,
                      currentPoints: currentPoints,
                    ),
                    const SizedBox(height: 24),
                    // About Program Section
                    _buildAboutProgramSection(),
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

  Widget _buildUpgradeProgressSection({
    required String currentLevel,
    required int currentPoints,
    required String nextLevel,
    required int nextLevelPoints,
  }) {
    final progress = currentPoints / nextLevelPoints;
    final remainingPoints = nextLevelPoints - currentPoints;
    final remainingAmount = remainingPoints * 10000; // 10,000₫ = 1 điểm

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Color(0xFFFFC107),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.trending_up,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Tiến độ nâng cấp',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Tiến tới $nextLevel',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        // Current level card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF9C4),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFC107),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cấp độ hiện tại: $currentLevel',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Điểm tích lũy: $currentPoints',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Progress bar
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Thành viên',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  '$nextLevel',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                minHeight: 8,
                backgroundColor: Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFFFFC107),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$currentPoints/$nextLevelPoints điểm',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Remaining points card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF9C4),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFC107),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.info,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cần thêm $remainingPoints điểm',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tương đương ${_formatCurrency(remainingAmount)}₫ chi tiêu',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMemberBenefitsSection() {
    final benefits = [
      {
        'icon': Icons.percent,
        'title': 'Giảm giá dịch vụ',
        'description': 'Nhận ưu đãi đặc biệt cho tất cả dịch vụ sửa chữa',
      },
      {
        'icon': Icons.access_time,
        'title': 'Ưu tiên lịch hẹn',
        'description': 'Được ưu tiên sắp xếp lịch sửa chữa nhanh chóng',
      },
      {
        'icon': Icons.headset_mic,
        'title': 'Hỗ trợ nhanh chóng',
        'description': 'Đội ngũ chăm sóc khách hàng hỗ trợ mọi lúc',
      },
      {
        'icon': Icons.card_giftcard,
        'title': 'Quà tặng định kỳ',
        'description': 'Nhận quà tặng vào các dịp đặc biệt trong năm',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Phúc Lợi Thành Viên',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        ...benefits.map((benefit) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFC107),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      benefit['icon'] as IconData,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          benefit['title'] as String,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          benefit['description'] as String,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildMemberRanksSection({
    required String currentLevel,
    required int currentPoints,
  }) {
    final ranks = [
      {
        'name': 'Thành viên',
        'points': 0,
        'icon': Icons.person,
        'benefits': null,
        'isActive': currentLevel == 'Thành viên',
      },
      {
        'name': 'Bạc',
        'points': 1000,
        'icon': Icons.hexagon_outlined,
        'benefits': 'Giảm 12% nhân công sửa chữa + ưu tiên lịch hẹn',
        'isActive': currentLevel == 'Bạc',
      },
      {
        'name': 'Vàng',
        'points': 2000,
        'icon': Icons.workspace_premium,
        'benefits': 'Giảm 15% nhân công sửa chữa + ưu tiên lịch hẹn + voucher hấp dẫn',
        'isActive': currentLevel == 'Vàng',
      },
      {
        'name': 'Kim Cương',
        'points': 5000,
        'icon': Icons.diamond,
        'benefits': 'Giảm 20% nhân công sửa chữa + ưu tiên lịch hẹn + voucher hấp dẫn',
        'isActive': currentLevel == 'Kim Cương',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Cấp Bậc Thành Viên',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Công thức tích điểm: 10.000₫ = 1 điểm',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 16),
        ...ranks.map((rank) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: rank['isActive'] as bool
                      ? const Color(0xFFFFF9C4)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: rank['isActive'] as bool
                      ? Border.all(
                          color: const Color(0xFFFFC107),
                          width: 2,
                        )
                      : null,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: rank['isActive'] as bool
                            ? const Color(0xFFFFC107)
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        rank['icon'] as IconData,
                        color: rank['isActive'] as bool
                            ? Colors.white
                            : Colors.grey.shade600,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                rank['name'] as String,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: rank['isActive'] as bool
                                      ? const Color(0xFFFFC107)
                                      : Colors.black87,
                                ),
                              ),
                              if (rank['isActive'] as bool) ...[
                                const SizedBox(width: 8),
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFFC107),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Yêu cầu: ${rank['points']} điểm',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          if (rank['benefits'] != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              rank['benefits'] as String,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildAboutProgramSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Về Chương Trình',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        // How to earn points
        _buildInfoItem(
          icon: Icons.attach_money,
          title: 'Cách tích điểm',
          description: 'Mỗi 10.000₫ chi tiêu = 1 điểm tích lũy',
        ),
        const SizedBox(height: 16),
        // Membership levels
        _buildInfoItem(
          icon: Icons.workspace_premium,
          title: 'Cấp độ thành viên',
          description: 'Bạc (1.000 điểm) → Vàng (2.000 điểm) → Kim Cương (5.000 điểm)',
        ),
        const SizedBox(height: 16),
        // Benefits
        _buildInfoItem(
          icon: Icons.card_giftcard,
          title: 'Quyền lợi',
          description: 'Giảm giá dịch vụ, ưu tiên lịch hẹn và nhiều ưu đãi khác',
        ),
      ],
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: Color(0xFFFFC107),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

