import 'package:flutter/material.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                'Tin nhắn',
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
              child: Center(
                child: Text(
                  'Tin nhắn',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

