class TemaModel {
  final String nome;
  final List<String> imagens;

  TemaModel({
    required this.nome, 
    required this.imagens
  });

  factory TemaModel.fromMap(
    Map<String, dynamic> map
  ) {
    return TemaModel(
      nome: map['nome'] ?? '', 
      imagens: (map['imagens'] as List)
                .map((e) => e.toString()).toList()
    );
  }
}