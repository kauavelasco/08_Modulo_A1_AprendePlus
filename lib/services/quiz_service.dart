import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:aprender_plus/models/questao_model.dart';

class QuizService {
  Future<List<QuestaoModel>> carregarQuestoes() async {
    try {
      final jsonString = await rootBundle.loadString('assets/json/banco_questoes.json');
      List<dynamic> jsonData = jsonDecode(jsonString);
      return jsonData.map((e) => QuestaoModel.fromMap(e as Map<String, dynamic>)).toList();
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return [];
    }
  }
}