import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../application/auth_controller.dart';
import '../../../../core/widgets/loading_button.dart';

class EmailVerificationModal extends ConsumerStatefulWidget {
  final String email;
  final String? activationToken; // Token từ response đăng ký hoặc null

  const EmailVerificationModal({
    super.key,
    required this.email,
    this.activationToken,
  });

  @override
  ConsumerState<EmailVerificationModal> createState() =>
      _EmailVerificationModalState();

  static void show(BuildContext context, String email, {String? activationToken}) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => EmailVerificationModal(
        email: email,
        activationToken: activationToken,
      ),
    );
  }
}

class _EmailVerificationModalState
    extends ConsumerState<EmailVerificationModal> {
  bool _isVerifying = false;
  bool _isResending = false;

  Future<void> _verifyActivation() async {
    // Nếu có token từ response đăng ký, sử dụng nó
    // Nếu không, thông báo user cần click link trong email
    if (widget.activationToken == null || widget.activationToken!.isEmpty) {
      // Không có token, thông báo user cần click link trong email
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Vui lòng kiểm tra email và ấn vào liên kết để kích hoạt tài khoản. Nếu bạn đã ấn vào liên kết, tài khoản sẽ được kích hoạt tự động.'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 5),
          ),
        );
      }
      return;
    }

    setState(() {
      _isVerifying = true;
    });

    try {
      final response = await ref
          .read(authControllerProvider.notifier)
          .verifyActivationToken(widget.activationToken!);

      if (mounted) {
        // Kiểm tra userStatus để xem đã kích hoạt chưa
        // Các trạng thái có thể: PENDING, ACTIVE, VERIFIED, INACTIVE, etc.
        if (response.userStatus.toUpperCase() == 'ACTIVE' ||
            response.userStatus.toUpperCase() == 'VERIFIED') {
          // Đóng modal và chuyển đến màn hình chúc mừng
          Navigator.of(context).pop();
          context.go('/congratulations');
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    'Tài khoản chưa được kích hoạt. Vui lòng kiểm tra email và ấn vào liên kết.'),
                backgroundColor: Colors.orange,
                duration: Duration(seconds: 4),
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'Đã xảy ra lỗi';
        if (e is Exception) {
          errorMessage = e.toString().replaceFirst('Exception: ', '');
        } else {
          errorMessage = e.toString();
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isVerifying = false;
        });
      }
    }
  }

  Future<void> _resendActivationLink() async {
    setState(() {
      _isResending = true;
    });

    try {
      await ref
          .read(authControllerProvider.notifier)
          .resendActivationLink(widget.email);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã gửi lại email kích hoạt. Vui lòng kiểm tra hộp thư.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'Đã xảy ra lỗi';
        if (e is Exception) {
          errorMessage = e.toString().replaceFirst('Exception: ', '');
        } else {
          errorMessage = e.toString();
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isResending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title
            const Text(
              'Bạn đăng ký sắp xong rồi',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // Body text
            const Text(
              'Vui lòng ấn vào liên kết chúng tôi đã gửi đến hòm thư email của bạn để xác thực đăng ký tài khoản.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            // Button "Đã ấn liên kết"
            LoadingButton(
              text: 'Đã ấn liên kết',
              onPressed: _verifyActivation,
              isLoading: _isVerifying,
            ),

            const SizedBox(height: 16),

            // Link "Gửi lại liên kết"
            Center(
              child: GestureDetector(
                onTap: _isResending ? null : _resendActivationLink,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Chưa nhận được liên kết? ',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      if (_isResending)
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      else
                        const Text(
                          'Gửi lại liên kết.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFFFF9800),
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // Add bottom padding for safe area
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}

