import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/services/menu_service.dart';
import '../../../domain/models/menu_item.dart';

final menuServiceProvider = Provider<MenuService>((ref) => MenuService());

final menuDataProvider = FutureProvider<Map<String, MenuItem>>((ref) async {
  final menuService = ref.watch(menuServiceProvider);
  return await menuService.loadMenuData();
});

final menuItemProvider = FutureProvider.family<MenuItem?, String>((ref, key) async {
  final menuService = ref.watch(menuServiceProvider);
  return await menuService.getMenuItemByKey(key);
});

class ServiceMenuScreen extends ConsumerWidget {
  final String serviceKey;
  final String serviceTitle;

  const ServiceMenuScreen({
    super.key,
    required this.serviceKey,
    required this.serviceTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuItemAsync = ref.watch(menuItemProvider(serviceKey));

    return Scaffold(
      appBar: AppBar(
        title: Text(serviceTitle),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: menuItemAsync.when(
        data: (menuItem) {
          if (menuItem == null) {
            return const Center(
              child: Text('Không tìm thấy dịch vụ'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (menuItem.hasCategories) ...[
                  // Display categorized services
                  ...menuItem.categorizedServices!.entries.map((entry) {
                    return _buildCategorySection(
                      context,
                      _getCategoryTitle(entry.key),
                      entry.value,
                    );
                  }),
                ] else ...[
                  // Display simple list
                  _buildServiceList(context, menuItem.getAllServices()),
                ],
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Lỗi tải dữ liệu',
                style: TextStyle(fontSize: 18, color: Colors.grey[800]),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection(
    BuildContext context,
    String categoryTitle,
    List<String> services,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12, top: 8),
          child: Text(
            categoryTitle,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        _buildServiceList(context, services),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildServiceList(BuildContext context, List<String> services) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return _buildServiceCard(context, service);
      },
    );
  }

  Widget _buildServiceCard(BuildContext context, String serviceName) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to service detail or booking
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Chọn dịch vụ: $serviceName')),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Text(
              serviceName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }

  String _getCategoryTitle(String categoryKey) {
    switch (categoryKey) {
      case 'DanDung':
        return 'Dân dụng';
      case 'CongNghiep':
        return 'Công nghiệp';
      default:
        return categoryKey;
    }
  }
}

class ServiceMenuBottomSheet extends ConsumerWidget {
  final String serviceKey;
  final String serviceTitle;

  const ServiceMenuBottomSheet({
    super.key,
    required this.serviceKey,
    required this.serviceTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuItemAsync = ref.watch(menuItemProvider(serviceKey));

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 48,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    serviceTitle,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Chọn dịch vụ Quý Khách cần',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: menuItemAsync.when(
                data: (menuItem) {
                  if (menuItem == null) {
                    return const Center(child: Text('Không tìm thấy dịch vụ'));
                  }

                  if (menuItem.hasCategories) {
                    final categories = menuItem.categorizedServices!;
                    final tabs = categories.keys.toList();
                    return DefaultTabController(
                      length: tabs.length,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TabBar(
                              indicatorColor: Colors.amber[700],
                              labelColor: Colors.amber[800],
                              unselectedLabelColor: Colors.grey[600],
                              labelStyle: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                              tabAlignment: TabAlignment.center,
                              tabs: tabs
                                  .map((t) => Tab(text: _getCategoryTitle(t)))
                                  .toList(),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildSearchBox(context),
                          _buildSuggestionText(),
                          const SizedBox(height: 8),
                          Expanded(
                            child: TabBarView(
                              children: tabs.map((t) {
                                final services = categories[t] ?? [];
                                return _buildServiceList(context, services);
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    final services = menuItem.getAllServices();
                    return Column(
                      children: [
                        _buildSearchBox(context),
                        _buildSuggestionText(),
                        const SizedBox(height: 8),
                        Expanded(child: _buildServiceList(context, services)),
                      ],
                    );
                  }
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 12),
                      Text(
                        'Lỗi tải dữ liệu',
                        style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        error.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBox(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Tìm kiếm dịch vụ...',
          prefixIcon: const Icon(Icons.search),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFFFC107)),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        onChanged: (value) {
          // TODO: implement search filter
        },
      ),
    );
  }

  Widget _buildSuggestionText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        'Gợi ý tìm kiếm: máy lạnh, máy giặt, tủ lạnh, đèn, điện, ống nước, lavabo, bồn cầu, mái tôn, máy bơm, panel...',
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey[600],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildServiceList(BuildContext context, List<String> services) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: services.length,
      separatorBuilder: (_, __) => const SizedBox(height: 6),
      itemBuilder: (context, index) {
        final service = services[index];
        return _buildServiceCard(context, service);
      },
    );
  }

  Widget _buildServiceCard(BuildContext context, String serviceName) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Close bottom sheet and navigate to quick booking
          Navigator.of(context).pop();
          // Use Future.microtask to ensure navigation happens after bottom sheet closes
          Future.microtask(() {
            final uri = Uri(
              path: '/quick-booking',
              queryParameters: {'serviceName': serviceName},
            );
            context.push(uri.toString());
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.amber[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.build, color: Colors.orange),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  serviceName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  String _getCategoryTitle(String categoryKey) {
    switch (categoryKey) {
      case 'DanDung':
        return 'Dân dụng';
      case 'CongNghiep':
        return 'Công nghiệp';
      default:
        return categoryKey;
    }
  }
}

