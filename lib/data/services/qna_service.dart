import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/models/qna_item.dart';

class QnAService {
  static const String _qnaJsonPath = 'assets/data/qna.json';

  List<QnAItem>? _allQnAs;

  Future<List<QnAItem>> loadQnAData() async {
    if (_allQnAs != null) {
      return _allQnAs!;
    }

    try {
      final String jsonString = await rootBundle.loadString(_qnaJsonPath);
      final List<dynamic> jsonData = json.decode(jsonString);

      _allQnAs = jsonData
          .map((item) => QnAItem.fromJson(item as Map<String, dynamic>))
          .toList();

      return _allQnAs!;
    } catch (e) {
      throw Exception('Failed to load QnA data from $_qnaJsonPath: $e');
    }
  }
}

