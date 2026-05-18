import 'package:aprender_plus/models/idioma_model.dart';

class GeniusModel {
  final List<IdiomaModel> idiomas;

  GeniusModel({
    required this.idiomas,
  });

  factory GeniusModel.fromMap(
    Map<String, dynamic> map
  ) {
    return GeniusModel(
      idiomas: List<IdiomaModel>.from(
        map['idiomas'].map(
          (e) => IdiomaModel.fromMap(e),
        )
      ),
    );
  }
}