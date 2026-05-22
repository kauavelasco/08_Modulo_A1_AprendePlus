class CoresModel {
  final String id;
  final String nome;
  final String audio;

  CoresModel({
    required this.id,
    required this.nome,
    required this.audio
  });

  factory CoresModel.fromMap(
    Map<String, dynamic> map
  ) {
    return CoresModel(
      id: map['id'] ?? '',
      nome: map['nome'] ?? '',
      audio: map['audio'] ?? ''
    );
  }
}