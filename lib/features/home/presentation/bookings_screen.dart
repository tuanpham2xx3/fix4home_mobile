import 'package:flutter/material.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  int _selectedTab = 0; // 0: Đã đặt, 1: Đã làm

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
                'Lịch sử công việc',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            // Tab navigation
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTab = 0;
                        });
                      },
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              'Đã đặt',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: _selectedTab == 0
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          if (_selectedTab == 0)
                            Container(
                              height: 3,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFFC107),
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(2),
                                ),
                              ),
                            )
                          else
                            const SizedBox(height: 3),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTab = 1;
                        });
                      },
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              'Đã làm',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: _selectedTab == 1
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          if (_selectedTab == 1)
                            Container(
                              height: 3,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFFC107),
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(2),
                                ),
                              ),
                            )
                          else
                            const SizedBox(height: 3),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Content area
            Expanded(
              child: Center(
                child: Text(
                  'Quý Khách chưa có lịch hẹn nào',
                  style: TextStyle(
                    fontSize: 16,
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
