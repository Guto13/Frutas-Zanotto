class Estoque {
  final int id;
  final int frutaId;
  final int embalagemId;
  final int produtorId;
  final double quantidade;

  Estoque({
    required this.id,
    required this.frutaId,
    required this.embalagemId,
    required this.quantidade,
    required this.produtorId,
  });

  factory Estoque.fromJson(Map<String, dynamic> json) {
    return Estoque(
      id: json['id'],
      frutaId: json['FrutaId'],
      embalagemId: json['EmbalagemId'],
      produtorId: json['ProdutorId'],
      quantidade: json['Quantidade'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'FrutaId': frutaId,
      'EmbalagemId': embalagemId,
      'Quantidade': quantidade,
      'ProdutorId': produtorId,
    };
  }
}
