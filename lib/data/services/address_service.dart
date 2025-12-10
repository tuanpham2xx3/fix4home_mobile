import 'dart:convert';
import 'package:flutter/services.dart';

class Ward {
  final String name;
  final String type;
  final String slug;
  final String nameWithType;
  final String path;
  final String pathWithType;
  final String code;
  final String parentCode;

  Ward({
    required this.name,
    required this.type,
    required this.slug,
    required this.nameWithType,
    required this.path,
    required this.pathWithType,
    required this.code,
    required this.parentCode,
  });

  factory Ward.fromJson(Map<String, dynamic> json) {
    return Ward(
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      slug: json['slug'] ?? '',
      nameWithType: json['name_with_type'] ?? '',
      path: json['path'] ?? '',
      pathWithType: json['path_with_type'] ?? '',
      code: json['code'] ?? '',
      parentCode: json['parent_code'] ?? '',
    );
  }
}

class AddressService {
  static const String _wardJsonPath = 'assets/data/ward.json';
  static const String _provinceJsonPath = 'assets/data/province.json';

  List<Ward>? _allWards;
  Map<String, dynamic>? _provinces;

  Future<List<Ward>> loadAllWards() async {
    if (_allWards != null) {
      return _allWards!;
    }

    try {
      print('Loading ward data from: $_wardJsonPath');
      final String jsonString = await rootBundle.loadString(_wardJsonPath);
      print('Loaded JSON string, length: ${jsonString.length}');
      
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      print('Decoded JSON, entries: ${jsonData.length}');

      _allWards = jsonData.entries.map((entry) {
        try {
          final value = entry.value as Map<String, dynamic>;
          return Ward.fromJson(value);
        } catch (e) {
          print('Error parsing ward entry ${entry.key}: $e');
          return null;
        }
      }).whereType<Ward>().toList();

      print('Successfully loaded ${_allWards!.length} wards');
      return _allWards!;
    } catch (e, stackTrace) {
      print('Failed to load ward data: $e');
      print('Path: $_wardJsonPath');
      print('Stack trace: $stackTrace');
      // Check if it's an asset loading error
      if (e.toString().contains('Unable to load asset')) {
        throw Exception(
          'Không thể tải file dữ liệu địa chỉ. Vui lòng đảm bảo:\n'
          '1. File ward.json tồn tại trong assets/data/\n'
          '2. Đã chạy "flutter pub get"\n'
          '3. Đã rebuild app (stop và start lại app)'
        );
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> loadProvinces() async {
    if (_provinces != null) {
      return _provinces!;
    }

    try {
      final String jsonString = await rootBundle.loadString(_provinceJsonPath);
      _provinces = json.decode(jsonString) as Map<String, dynamic>;
      return _provinces!;
    } catch (e) {
      throw Exception('Failed to load province data: $e');
    }
  }

  Future<List<Ward>> searchWards(String query) async {
    if (query.isEmpty || query.trim().isEmpty) {
      return [];
    }

    try {
      final wards = await loadAllWards();
      final lowerQuery = query.toLowerCase().trim();
      
      if (wards.isEmpty) {
        print('No wards loaded!');
        return [];
      }

      final results = wards.where((ward) {
        final nameMatch = ward.name.toLowerCase().contains(lowerQuery);
        final nameWithTypeMatch = ward.nameWithType.toLowerCase().contains(lowerQuery);
        final pathMatch = ward.path.toLowerCase().contains(lowerQuery);
        final pathWithTypeMatch = ward.pathWithType.toLowerCase().contains(lowerQuery);
        
        return nameMatch || nameWithTypeMatch || pathMatch || pathWithTypeMatch;
      }).toList();

      // Sort by relevance: exact matches first, then starts with, then contains
      results.sort((a, b) {
        final aName = a.name.toLowerCase();
        final bName = b.name.toLowerCase();
        final aNameWithType = a.nameWithType.toLowerCase();
        final bNameWithType = b.nameWithType.toLowerCase();
        
        // Exact match
        if (aName == lowerQuery && bName != lowerQuery) return -1;
        if (aName != lowerQuery && bName == lowerQuery) return 1;
        
        // Starts with
        if (aName.startsWith(lowerQuery) && !bName.startsWith(lowerQuery)) return -1;
        if (!aName.startsWith(lowerQuery) && bName.startsWith(lowerQuery)) return 1;
        if (aNameWithType.startsWith(lowerQuery) && !bNameWithType.startsWith(lowerQuery)) return -1;
        if (!aNameWithType.startsWith(lowerQuery) && bNameWithType.startsWith(lowerQuery)) return 1;
        
        return 0;
      });

      print('Search for "$query" found ${results.length} results');
      return results;
    } catch (e, stackTrace) {
      print('Error searching wards: $e');
      print('Stack trace: $stackTrace');
      return [];
    }
  }

  String getProvinceName(String provinceCode) {
    if (_provinces == null) {
      return '';
    }
    final province = _provinces![provinceCode] as Map<String, dynamic>?;
    return province?['name_with_type'] ?? province?['name'] ?? '';
  }
}

