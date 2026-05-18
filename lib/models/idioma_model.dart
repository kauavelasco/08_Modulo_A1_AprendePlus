import 'package:aprender_plus/models/cores_model.dart';

class IdiomaModel {
  final String nome;
  final List<CoresModel> cores;

  IdiomaModel({
    required this.nome,
    required this.cores,
  });

  factory IdiomaModel.fromMap(
    Map<String, dynamic> map
  ) {
    return IdiomaModel(
      nome: map['nome'],
      cores: List<CoresModel>.from(
        map['cores'].map(
          (e) => CoresModel.fromMap(e),
        ),
      ),
    );
  }
}