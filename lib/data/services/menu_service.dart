import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/models/menu_item.dart';

class MenuService {
  static const String _menuJsonPath = 'assets/data/menu.json';

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

      return menuItems;
    } catch (e) {
      throw Exception('Failed to load menu data from $_menuJsonPath: $e');
    }
  }

  Future<MenuItem?> getMenuItemByKey(String key) async {
    final menuData = await loadMenuData();
    return menuData[key];
  }

  static String getServiceTitle(String key) {
    return _serviceTitles[key] ?? key;
  }
}
