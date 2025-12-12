import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/gradient_header.dart';
import '../../../data/services/price_service.dart';
import '../../../domain/models/price_models.dart';

final priceServiceProvider = Provider<PriceService>((ref) => PriceService());

final priceDataProvider = FutureProvider<List<PriceGroup>>((ref) async {
  final service = ref.watch(priceServiceProvider);
  return service.loadPriceData();
});

class PriceListScreen extends ConsumerWidget {
  const PriceListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final priceAsync = ref.watch(priceDataProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            const GradientHeader(
              title: 'Bảng giá dịch vụ',
              showBackButton: true,
            ),
            Expanded(
              child: priceAsync.when(
                data: (groups) {
                  if (groups.isEmpty) {
                    return const Center(child: Text('Chưa có dữ liệu bảng giá'));
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      final group = groups[index];
                      return _PriceGroupCard(group: group);
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemCount: groups.length,
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

class _PriceGroupCard extends StatelessWidget {
  final PriceGroup group;

  const _PriceGroupCard({required this.group});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          final encoded = Uri.encodeComponent(group.nhomDichVuChinh);
          context.push('/price/$encoded');
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.amber[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.grid_view_rounded, color: Color(0xFFFFA000)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      group.nhomDichVuChinh,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Xem chi tiết bảng giá',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

