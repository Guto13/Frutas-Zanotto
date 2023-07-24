class Romaneio {
  final int id;
  final String tFruta;
  final DateTime data;
  final int frutaId;
  final int embalagemId;
  final int produtorId;

  Romaneio({
    required this.id,
    required this.frutaId,
    required this.embalagemId,
    required this.tFruta,
    required this.data,
    required this.produtorId,
  });

  factory Romaneio.fromJson(Map<String, dynamic> json) {
    return Romaneio(
      id: json['id'],
      frutaId: json['FrutaId'],
      embalagemId: json['EmbalagemId'],
      produtorId: json['ProdutorId'],
      tFruta: json['TFruta'],
      data: DateTime.parse(json['Data']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Data': data.toIso8601String(),
      'FrutaId': frutaId,
      'EmbalagemId': embalagemId,
      'TFruta': tFruta,
      'ProdutorId': produtorId,
    };
  }
}
