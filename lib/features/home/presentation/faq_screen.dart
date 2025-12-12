import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/services/qna_service.dart';
import '../../../domain/models/qna_item.dart';
import '../../../core/widgets/gradient_header.dart';

final qnaServiceProvider = Provider<QnAService>((ref) => QnAService());

final qnaDataProvider = FutureProvider<List<QnAItem>>((ref) async {
  final qnaService = ref.watch(qnaServiceProvider);
  return await qnaService.loadQnAData();
});

class FAQScreen extends ConsumerStatefulWidget {
  const FAQScreen({super.key});

  @override
  ConsumerState<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends ConsumerState<FAQScreen> {
  final Set<int> _expandedItems = {};

  void _toggleExpansion(int id) {
    setState(() {
      if (_expandedItems.contains(id)) {
        _expandedItems.remove(id);
      } else {
        _expandedItems.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final qnaAsync = ref.watch(qnaDataProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Yellow gradient header with back button
            GradientHeader(
              title: 'Câu hỏi thường gặp',
              showBackButton: true,
            ),
            // Content area
            Expanded(
              child: qnaAsync.when(
                data: (qnaList) {
                  if (qnaList.isEmpty) {
                    return const Center(
                      child: Text('Không có câu hỏi nào'),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: qnaList.length,
                    itemBuilder: (context, index) {
                      final qna = qnaList[index];
                      final isExpanded = _expandedItems.contains(qna.id);
                      return _buildQnAItem(qna, isExpanded);
                    },
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stackTrace) => Center(
                  child: Text('Lỗi: $error'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQnAItem(QnAItem qna, bool isExpanded) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          // Question header
          InkWell(
            onTap: () => _toggleExpansion(qna.id),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Number circle
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFC107),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${qna.id}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Question text
                  Expanded(
                    child: Text(
                      qna.question,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Chevron icon
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.grey[700],
                  ),
                ],
              ),
            ),
          ),
          // Answer section (expandable)
          if (isExpanded)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(12),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question mark icon
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFC107),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        '?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Answer text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Trả lời:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          qna.answer,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

