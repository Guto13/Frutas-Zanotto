class Palete {
  final int id;
  final int carga;
  final DateTime data;
  final bool carregado;

  Palete(
      {required this.id,
      required this.carga,
      required this.data,
      required this.carregado});

  factory Palete.fromJson(Map<String, dynamic> json) {
    return Palete(
      id: json['id'],
      carga: json['Carga'],
      data: DateTime.parse(json['Data']),
      carregado: json['Carregado'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Carga': carga,
      'Data': data.toIso8601String(),
      'Carregado': carregado,
    };
  }
}
