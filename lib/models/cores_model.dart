class CoresModel {
  final String nome;
  final String audio;

  CoresModel({
    required this.nome,
    required this.audio
  });

  factory CoresModel.fromMap(
    Map<String, dynamic> map
  ) {
    return CoresModel(
      nome: map['nome'],
      audio: map['audio']
    );
  }
}