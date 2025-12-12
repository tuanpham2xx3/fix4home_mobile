import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/gradient_header.dart';
import '../../../domain/models/price_models.dart';
import 'price_list_screen.dart';

final priceGroupProvider = FutureProvider.family<PriceGroup?, String>((ref, groupName) async {
  final service = ref.watch(priceServiceProvider);
  return service.getGroupByName(groupName);
});

class PriceGroupScreen extends ConsumerWidget {
  final String groupName;

  const PriceGroupScreen({
    super.key,
    required this.groupName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupAsync = ref.watch(priceGroupProvider(groupName));

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            GradientHeader(
              title: 'Bảng giá - $groupName',
              showBackButton: true,
            ),
            Expanded(
              child: groupAsync.when(
                data: (group) {
                  if (group == null) {
                    return const Center(child: Text('Không tìm thấy nhóm dịch vụ'));
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      final item = group.danhSachHangMuc[index];
                      return _PriceItemCard(
                        groupName: group.nhomDichVuChinh,
                        item: item,
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemCount: group.danhSachHangMuc.length,
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

class _PriceItemCard extends StatelessWidget {
  final String groupName;
  final PriceItem item;

  const _PriceItemCard({
    required this.groupName,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          final g = Uri.encodeComponent(groupName);
          final i = Uri.encodeComponent(item.tenHangMuc);
          context.push('/price/$g/$i');
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
                child: const Icon(Icons.folder_open, color: Color(0xFFFFA000)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.tenHangMuc,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Nhấn để xem chi tiết bảng giá',
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

