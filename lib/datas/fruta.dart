class Fruta {
  final int id;
  final String nome;
  final String variedade;

  Fruta({required this.id, required this.nome, required this.variedade});

  factory Fruta.fromJson(Map<String, dynamic> json) {
    return Fruta(
      id: json['id'],
      nome: json['Nome'],
      variedade: json['Variedade'],
    );
  }

  String get nomeVariedade {
    return '$nome $variedade';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'Nome': nome,
      'Variedade': variedade,
    };
  }
}
