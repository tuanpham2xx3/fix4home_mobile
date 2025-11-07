import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_providers.g.dart'; // <--- Dòng này đã được thêm

// 1. A simple provider for the counter's state
@Riverpod(keepAlive: true)
class Counter extends _$Counter {
  // Initial state
  @override
  int build() => 0;

  // Method to update the state
  void increment() {
    state++;
  }
}

// 2. A provider to manage the TextEditingController
final textEditingControllerProvider = Provider.autoDispose<TextEditingController>((ref) {
  final controller = TextEditingController();
  // Dispose the controller when the provider is no longer used
  ref.onDispose(() => controller.dispose());
  return controller;
});
