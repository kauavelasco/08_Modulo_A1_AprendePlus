import 'package:home_widget/home_widget.dart';

class WidgetService {
  static Future<void> atualizarWidget({
    required int memo,
    required int genius,
    required int quiz,
  }) async {
    await HomeWidget.saveWidgetData<int>(
      'memo_score',
      memo,
    );

    await HomeWidget.saveWidgetData<int>(
      'genius_score',
      genius,
    );

    await HomeWidget.saveWidgetData<int>(
      'quiz_score',
      quiz,
    );

    await HomeWidget.updateWidget(
      androidName: 'Aprender+Widget',
    );
  }
}