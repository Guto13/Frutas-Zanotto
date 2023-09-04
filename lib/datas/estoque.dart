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

class EstoqueC {
  final int id;
  final int frutaId;
  final int quantidade;
  final String calibre;
  final String categoria;

  EstoqueC({
    required this.id,
    required this.frutaId,
    required this.quantidade,
    required this.calibre,
    required this.categoria,
  });

  factory EstoqueC.fromJson(Map<String, dynamic> json) {
    return EstoqueC(
      id: json['id'],
      frutaId: json['FrutaId'],
      quantidade: json['Quantidade'],
      calibre: json['Calibre'],
      categoria: json['Categoria'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'FrutaId': frutaId,
      'Quantidade': quantidade,
      'Calibre': calibre,
      'Categoria': categoria,
    };
  }
}
