import 'dart:convert';

import 'package:flutter/services.dart';

import '../../domain/models/price_models.dart';

class PriceService {
  static const String _priceJsonPath = 'assets/data/price.json';

  List<PriceGroup>? _cachedGroups;

  Future<List<PriceGroup>> loadPriceData() async {
    if (_cachedGroups != null) {
      return _cachedGroups!;
    }

    try {
      final jsonString = await rootBundle.loadString(_priceJsonPath);
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> groups = jsonData['bang_gia_tong_hop'] as List<dynamic>? ?? [];
      _cachedGroups = groups
          .map((e) => PriceGroup.fromJson(e as Map<String, dynamic>))
          .toList();
      return _cachedGroups!;
    } catch (e) {
      throw Exception('Failed to load price data from $_priceJsonPath: $e');
    }
  }

  Future<PriceGroup?> getGroupByName(String groupName) async {
    final data = await loadPriceData();
    for (final g in data) {
      if (g.nhomDichVuChinh == groupName) return g;
    }
    return null;
  }

  Future<PriceItem?> getItemByName(String groupName, String itemName) async {
    final group = await getGroupByName(groupName);
    if (group == null) return null;
    for (final i in group.danhSachHangMuc) {
      if (i.tenHangMuc == itemName) return i;
    }
    return null;
  }
}

