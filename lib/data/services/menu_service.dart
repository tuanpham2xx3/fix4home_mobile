import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/models/menu_item.dart';

class MenuService {
  static const String _menuJsonPath = 'assets/data/menu.json';

  // Cache for menu data
  Map<String, MenuItem>? _cachedMenuData;
  List<String>? _allServicesFlat;

  // Mapping service keys to display names
  static const Map<String, String> _serviceTitles = {
    'XayDungSuaNha': 'Xây dựng sửa nhà',
    'CoKhiNhomKinh': 'Cơ khí nhôm kính',
    'DienNuoc': 'Điện nước',
    'DienLanh': 'Điện lạnh',
    'DienMay': 'Điện máy',
    'DoGoNoiThat': 'Đồ gỗ nội thất',
    'VeSinh': 'Vệ sinh',
    'ThongNghetHutHam': 'Thông nghẹt hút hầm',
    'ChuyenNha': 'Vận chuyển',
    'DichVuKhac': 'Dịch vụ khác',
    'BangGia': 'Bảng giá',
    'TinTuc': 'Tin tức',
  };

  Future<Map<String, MenuItem>> loadMenuData() async {
    // Return cached data if available
    if (_cachedMenuData != null) {
      return _cachedMenuData!;
    }
    try {
      final String jsonString = await rootBundle.loadString(_menuJsonPath);
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      final Map<String, MenuItem> menuItems = {};

      jsonData.forEach((key, value) {
        MenuItem? menuItem;

        if (value is Map<String, dynamic>) {
          // Has categories (DanDung, CongNghiep)
          final categorizedServices = <String, List<String>>{};
          value.forEach((categoryKey, categoryValue) {
            if (categoryValue is List) {
              categorizedServices[categoryKey] = List<String>.from(
                categoryValue.map((item) => item.toString()),
              );
            }
          });
          menuItem = MenuItem(
            key: key,
            title: _serviceTitles[key] ?? key,
            categorizedServices: categorizedServices,
          );
        } else if (value is List) {
          // Simple list of services
          menuItem = MenuItem(
            key: key,
            title: _serviceTitles[key] ?? key,
            services: List<String>.from(
              value.map((item) => item.toString()),
            ),
          );
        }

        if (menuItem != null) {
          menuItems[key] = menuItem;
        }
      });

      // Cache the menu data
      _cachedMenuData = menuItems;
      return menuItems;
    } catch (e) {
      throw Exception('Failed to load menu data from $_menuJsonPath: $e');
    }
  }

  Future<MenuItem?> getMenuItemByKey(String key) async {
    final menuData = await loadMenuData();
    return menuData[key];
  }

  /// Get all services as a flat list (flattened from all categories)
  Future<List<String>> getAllServicesFlat() async {
    // Return cached flat list if available
    if (_allServicesFlat != null) {
      return _allServicesFlat!;
    }

    final menuData = await loadMenuData();
    final allServices = <String>[];

    menuData.values.forEach((menuItem) {
      if (menuItem.services != null) {
        // Simple list of services
        allServices.addAll(menuItem.services!);
      } else if (menuItem.categorizedServices != null) {
        // Has categories (DanDung, CongNghiep)
        menuItem.categorizedServices!.values.forEach((serviceList) {
          allServices.addAll(serviceList);
        });
      }
    });

    // Cache the flat list
    _allServicesFlat = allServices;
    return allServices;
  }

  /// Search services by query (case-insensitive, supports Vietnamese)
  Future<List<String>> searchServices(String query) async {
    if (query.isEmpty || query.trim().isEmpty) {
      return await getAllServicesFlat();
    }

    final allServices = await getAllServicesFlat();
    final lowerQuery = query.toLowerCase().trim();

    final results = allServices.where((service) {
      return service.toLowerCase().contains(lowerQuery);
    }).toList();

    // Sort by relevance: exact matches first, then starts with, then contains
    results.sort((a, b) {
      final aLower = a.toLowerCase();
      final bLower = b.toLowerCase();

      // Exact match
      if (aLower == lowerQuery && bLower != lowerQuery) return -1;
      if (aLower != lowerQuery && bLower == lowerQuery) return 1;

      // Starts with
      if (aLower.startsWith(lowerQuery) && !bLower.startsWith(lowerQuery)) return -1;
      if (!aLower.startsWith(lowerQuery) && bLower.startsWith(lowerQuery)) return 1;

      return 0;
    });

    return results;
  }

  static String getServiceTitle(String key) {
    return _serviceTitles[key] ?? key;
  }
}
