import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/router.dart'; // Import the router

void main() {
  // Wrap the entire app with ProviderScope for Riverpod
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget { // Use ConsumerWidget for Riverpod
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the GoRouter instance from the provider
    final goRouter = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Fix4Home',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: goRouter, // Use routerConfig for GoRouter
      debugShowCheckedModeBanner: false, // Typically disable for production builds
    );
  }
}
