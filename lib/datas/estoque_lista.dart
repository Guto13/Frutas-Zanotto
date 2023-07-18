class EstoqueLista {
  final int id;
  final FrutaEstoque fruta;
  final EmbalagemEstoque embalagem;
  final ProdutorEstoque produtor;
  final double quantidade;

  EstoqueLista({
    required this.id,
    required this.fruta,
    required this.embalagem,
    required this.produtor,
    required this.quantidade,
  });

  factory EstoqueLista.fromJson(Map<String, dynamic> json) {
    return EstoqueLista(
      quantidade: json['Quantidade'],
      id: json['id'],
      fruta: FrutaEstoque.fromJson(json['Fruta']),
      embalagem: EmbalagemEstoque.fromJson(json['Embalagem']),
      produtor: ProdutorEstoque.fromJson(json['Produtor']),
    );
  }
}

class FrutaEstoque {
  String nome;
  String variedade;

  FrutaEstoque({
    required this.nome,
    required this.variedade,
  });

  factory FrutaEstoque.fromJson(Map<String, dynamic> json) {
    return FrutaEstoque(
      nome: json['Nome'],
      variedade: json['Variedade'],
    );
  }
}

class EmbalagemEstoque {
  String nome;

  EmbalagemEstoque({
    required this.nome,
  });

  factory EmbalagemEstoque.fromJson(Map<String, dynamic> json) {
    return EmbalagemEstoque(
      nome: json['Nome'],
    );
  }
}

class ProdutorEstoque {
  String nome;
  String sobrenome;

  ProdutorEstoque({
    required this.nome,
    required this.sobrenome,
  });

  factory ProdutorEstoque.fromJson(Map<String, dynamic> json) {
    return ProdutorEstoque(
      nome: json['Nome'],
      sobrenome: json['Sobrenome'],
    );
  }
}
