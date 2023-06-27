class Embalagem {
  final int id;
  final String nome;
  final String pesoAprox;

  Embalagem({required this.id, required this.nome, required this.pesoAprox});

  factory Embalagem.fromJson(Map<String, dynamic> json) {
    return Embalagem(
      id: json['id'],
      nome: json['Nome'],
      pesoAprox: json['Peso Aprox'],
    );
  }

  String get nomePeso {
    return '$nome $pesoAprox';
  }

  Map<String, dynamic> toMap() {
    return {
      'Nome': nome,
      'Peso Aprox': pesoAprox,
    };
  }
}
