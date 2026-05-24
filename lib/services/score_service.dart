import 'package:shared_preferences/shared_preferences.dart';

class ScoreService {
  static const memoKey = 'memo_score';
  static const geniusKey = 'genius_score';
  static const quizKey = 'quiz_score';

  static Future<void> salvarMemo(int valor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(memoKey, valor);
  }

  static Future<void> salvarGenius(int valor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(geniusKey, valor);
  }

  static Future<void> salvarQuiz(int valor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(quizKey, valor);
  }

  static Future<int> getMemo() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(memoKey) ?? 0;
  }

  static Future<int> getGenius() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(geniusKey) ?? 0;
  }

  static Future<int> getQuiz() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(quizKey) ?? 0;
  }
}