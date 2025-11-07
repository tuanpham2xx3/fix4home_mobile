import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/application/auth_controller.dart';
import '../../auth/domain/auth_state.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authControllerProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: Center(
        child: authState.when(
          data: (state) {
            if (state is Authenticated) {
              return Text('Welcome, ${state.user.name}!');
            }
            return const Text('Not authenticated');
          },
          loading: () => const CircularProgressIndicator(),
          error: (error, stackTrace) => Text(error.toString()),
        ),
      ),
    );
  }
}
