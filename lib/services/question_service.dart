// services/question_service.dart
import 'dart:convert';
import 'package:flutter/services.dart';
import '../model/soru.dart';

class QuestionService {
  static Future<List<Question>> loadQuestions(
      String category, String difficulty) async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/sorular/${category}_$difficulty.json',
      );

      final List<dynamic> jsonList = json.decode(jsonString);
      return Question.fromData(
        jsonList.cast<Map<String, dynamic>>(),
        category,
      );
    } catch (e) {
      print('Sorular yüklenirken hata oluştu: $e');
      return [];
    }
  }
}
