import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/widgets/loading_button.dart';

class CongratulationsScreen extends StatelessWidget {
  const CongratulationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),

                // Logo
                Center(
                  child: SvgPicture.asset(
                    'assets/images/logo.svg',
                    width: 120,
                    height: 120,
                  ),
                ),

                const SizedBox(height: 16),

                // Brand name
                const Text(
                  'FIXHOME',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0C2C6C),
                    letterSpacing: 1.2,
                  ),
                ),

                const SizedBox(height: 8),

                // Slogan
                const Text(
                  'CHĂM SÓC NGÔI NHÀ CỦA BẠN',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF8AB2F2),
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 60),

                // Title
                const Text(
                  'Bạn đã đăng ký thành công',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 16),

                // Body text
                const Text(
                  'Vui lòng quay trở lại để tiến hành đăng nhập.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 48),

                // Login button
                LoadingButton(
                  text: 'Đăng nhập',
                  onPressed: () {
                    context.go('/login');
                  },
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

