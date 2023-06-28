class Entradas {
  final int id;
  final int frutaId;
  final int embalagemId;
  final int produtorId;
  final double quantidade;
  final DateTime data;

  Entradas(
      {required this.id,
      required this.frutaId,
      required this.embalagemId,
      required this.quantidade,
      required this.produtorId,
      required this.data});

  factory Entradas.fromJson(Map<String, dynamic> json) {
    return Entradas(
      id: json['id'],
      frutaId: json['FrutaId'],
      embalagemId: json['EmbalagemId'],
      produtorId: json['ProdutorId'],
      quantidade: json['Quantidade'],
      data: DateTime.parse(json['Data']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'FrutaId': frutaId,
      'EmbalagemId': embalagemId,
      'Quantidade': quantidade,
      'ProdutorId': produtorId,
      'Data': data.toIso8601String(),
    };
  }
}
