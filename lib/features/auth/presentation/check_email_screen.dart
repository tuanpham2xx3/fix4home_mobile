import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckEmailScreen extends ConsumerWidget {
  const CheckEmailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Check Your Email')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'We have sent an activation link to your email. Please check your inbox and click the link to activate your account.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // In a real app, this would open the default mail app.
                // For this mock, we'll just show a snackbar.
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening mail app...')),
                );
              },
              child: const Text('Open Mail App'),
            ),
            TextButton(
              onPressed: () {
                // This would call a method in AuthController to resend the activation link
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Resending activation link...')),
                );
              },
              child: const Text('Resend Activation Link'),
            ),
          ],
        ),
      ),
    );
  }
}
