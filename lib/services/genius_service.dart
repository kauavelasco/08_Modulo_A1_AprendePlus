import 'dart:convert';

import 'package:aprender_plus/models/genius_model.dart';
import 'package:flutter/services.dart';

class GeniusService {
  Future<GeniusModel> carregarDados() async {
    final jsonString = await rootBundle.loadString('assets/json/genius_config.json');
    Map<String, dynamic> jsonData = jsonDecode(jsonString);
    return GeniusModel.fromMap(jsonData);
  }
}