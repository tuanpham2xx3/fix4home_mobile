import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/gradient_header.dart';
import '../../../domain/models/price_models.dart';
import 'price_list_screen.dart';

class PriceItemRequest {
  final String groupName;
  final String itemName;

  const PriceItemRequest(this.groupName, this.itemName);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PriceItemRequest &&
        other.groupName == groupName &&
        other.itemName == itemName;
  }

  @override
  int get hashCode => Object.hash(groupName, itemName);
}

final priceItemProvider = FutureProvider.family<PriceItem?, PriceItemRequest>((ref, req) async {
  final service = ref.watch(priceServiceProvider);
  return service.getItemByName(req.groupName, req.itemName);
});

class PriceDetailScreen extends ConsumerWidget {
  final String groupName;
  final String itemName;

  const PriceDetailScreen({
    super.key,
    required this.groupName,
    required this.itemName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemAsync = ref.watch(priceItemProvider(PriceItemRequest(groupName, itemName)));

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            GradientHeader(
              title: itemName,
              showBackButton: true,
            ),
            Expanded(
              child: itemAsync.when(
                data: (item) {
                  if (item == null) {
                    return const Center(child: Text('Không tìm thấy hạng mục'));
                  }
                  if (item.bangGia.isEmpty) {
                    return const Center(child: Text('Chưa có dữ liệu giá'));
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      final entry = item.bangGia[index];
                      return _PriceEntryCard(entry: entry);
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemCount: item.bangGia.length,
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(
                  child: Text(
                    'Lỗi tải dữ liệu',
                    style: TextStyle(color: Colors.red[700]),
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

class _PriceEntryCard extends StatelessWidget {
  final PriceEntry entry;

  const _PriceEntryCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.amber[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.attach_money_rounded,
                    color: Color(0xFFFFA000),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    entry.ten,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _infoRow('Đơn vị', entry.donVi),
            const SizedBox(height: 4),
            _infoRow(
              'Giá',
              entry.gia,
              valueColor: const Color(0xFF2E9E50),
              isBold: true,
            ),
            if (entry.ghiChu != null && entry.ghiChu!.trim().isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Ghi chú: ${entry.ghiChu}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, {Color? valueColor, bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$label:',
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black54,
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13.5,
              color: valueColor ?? Colors.black87,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}

