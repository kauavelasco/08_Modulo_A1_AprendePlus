import 'dart:convert';
import 'package:aprender_plus/models/memo_model.dart';
import 'package:flutter/services.dart';

class MemoService {
  Future<MemoModel> carregarDados() async {
    final jsonString = await rootBundle.loadString('assets/json/memocheck_themes.json');
    Map<String, dynamic> jsonData = jsonDecode(jsonString);
    return MemoModel.fromMap(jsonData);
  }
}