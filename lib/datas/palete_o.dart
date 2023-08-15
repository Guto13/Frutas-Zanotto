class PaleteO {
  final int id;
  final String table;
  final String embalagem;
  final int paleteId;
  final String nome;
  final int quant;


  PaleteO({
    required this.id,
    this.table = 'PaleteO',
    required this.embalagem,
    required this.paleteId,
    required this.nome,
    required this.quant,
  });

  factory PaleteO.fromJson(Map<String, dynamic> json) {
    return PaleteO(
      id: json['id'],
      table: json['Table'],
      embalagem: json['Embalagem'],
      paleteId: json['PaleteId'],
      nome: json['Nome'],
      quant: json['Quant'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Embalagem':embalagem,
      'PaleteId': paleteId,
      'Nome': nome,
      'Quant': quant,
    };
  }
}
