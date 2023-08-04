class Carga {
  final int id;
  final DateTime data;
  final String motorista;

  Carga({required this.id, required this.data, required this.motorista});

  factory Carga.fromJson(Map<String, dynamic> json) {
    return Carga(
      id: json['id'],
      data: DateTime.parse(json['Data']),
      motorista: json['Motorista'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Data': data.toIso8601String(),
      'Motorista': motorista,
    };
  }
}
