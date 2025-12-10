import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/application/auth_controller.dart';
import 'feedback_screen.dart';
import 'account_info_screen.dart';
import 'membership_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Yellow gradient header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFFFD54F),
                    Color(0xFFFFC107),
                    Color(0xCCFFC107),
                    Color(0x99FFC107),
                    Color(0x66FFC107),
                    Color(0x33FFC107),
                    Color(0x10FFC107),
                    Colors.transparent,
                  ],
                  stops: [0.0, 0.2, 0.4, 0.55, 0.7, 0.85, 0.95, 1.0],
                ),
              ),
              child: const Text(
                'Thông tin tài khoản',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // Content area
            Expanded(
              child: authState.when(
        data: (state) {
          return state.when(
            initial: () => const Center(child: Text('Đang khởi tạo...')),
            loading: () => const Center(child: CircularProgressIndicator()),
            authenticated: (user) => _buildProfileContent(context, ref),
            unauthenticated: () => const Center(child: Text('Chưa đăng nhập')),
            error: (message) => Center(child: Text('Lỗi: $message')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text(error.toString())),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Profile Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Avatar with yellow border
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFFFC107),
                      width: 3,
                    ),
                  ),
                  child: const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                // Greeting and Member button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Quý Khách hàng',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFC107),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Text(
                        'Thành viên',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Menu Items
          _buildMenuItem(
            icon: Icons.edit,
            title: 'Thông tin tài khoản',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AccountInfoScreen(),
                ),
              );
            },
          ),
          _buildMenuItem(
            icon: Icons.workspace_premium,
            title: 'Chương trình thành viên',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MembershipScreen(),
                ),
              );
            },
          ),
          _buildMenuItem(
            icon: Icons.list_alt,
            title: 'Quy trình làm việc',
            onTap: () {},
          ),
          _buildMenuItem(
            icon: Icons.help_outline,
            title: 'Câu hỏi thường gặp',
            onTap: () {},
          ),
          _buildMenuItem(
            icon: Icons.person_add,
            title: 'Tuyển dụng',
            onTap: () {},
          ),
          _buildMenuItem(
            icon: Icons.contact_support,
            title: 'Thông tin liên hệ',
            onTap: () {},
          ),
          _buildMenuItem(
            icon: Icons.feedback_outlined,
            title: 'Góp ý dịch vụ',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FeedbackScreen(),
                ),
              );
            },
          ),
          _buildMenuItem(
            icon: Icons.logout,
            title: 'Đăng xuất',
            onTap: () {
              ref.read(authControllerProvider.notifier).logout();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.grey[800],
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[800],
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }
}