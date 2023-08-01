class Palete {
  final int id;
  final int carga;
  final DateTime data;

  Palete({required this.id, required this.carga, required this.data});

  factory Palete.fromJson(Map<String, dynamic> json) {
    return Palete(
      id: json['id'],
      carga: json['Carga'],
      data: DateTime.parse(json['Data']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'Carga': carga,
      'Data': data.toIso8601String(),
    };
  }
}
