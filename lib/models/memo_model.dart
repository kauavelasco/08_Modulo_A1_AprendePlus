import 'package:aprender_plus/models/tema_model.dart';

class MemoModel {
  final List<TemaModel> temas;

  MemoModel({
    required this.temas
  });

  factory MemoModel.fromMap(
    Map<String, dynamic> map
  ) {
    return MemoModel(
      temas: (map['temas'] as List)
        .map((e) => TemaModel.fromMap(e)).toList(),
    );
  }
}