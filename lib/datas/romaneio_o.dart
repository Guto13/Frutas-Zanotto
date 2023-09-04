class RomaneioO {
  final int id;
  final int romaneioId;
  final String nome;
  final int quant;

  RomaneioO({
    required this.id,
    required this.romaneioId,
    required this.nome,
    required this.quant,
  });

  factory RomaneioO.fromJson(Map<String, dynamic> json) {
    return RomaneioO(
      id: json['id'],
      romaneioId: json['RomaneioId'],
      nome: json['Nome'],
      quant: json['Quant'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'RomaneioId': romaneioId,
      'Nome': nome,
      'Quant': quant,
    };
  }
}