class QuestaoModel {
  final int id;
  final String tipo;
  final String pergunta;
  final int peso;
  final List<dynamic>? alternativas;
  final bool? correta;
  final List<dynamic>? pares;

  QuestaoModel({
    required this.id,
    required this.tipo,
    required this.pergunta,
    required this.peso,
    this.alternativas,
    this.correta,
    this.pares,
  });

  factory QuestaoModel.fromMap(
    Map<String, dynamic> map
  ) {
    return QuestaoModel(
      id: map['id'], 
      tipo: map['tipo'], 
      pergunta: map['pergunta'], 
      peso: map['peso'],
      alternativas: map['alternativas'],
      correta: map['correta'],
      pares: map['pares'],
    );
  }
}