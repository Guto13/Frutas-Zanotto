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

class EstoqueListaC {
  final int id;
  final FrutaEstoque fruta;
  double quantidade;
  final String calibre;
  final String categoria;

  EstoqueListaC({
    required this.id,
    required this.fruta,
    required this.quantidade,
    required this.calibre,
    required this.categoria,
  });

  factory EstoqueListaC.fromJson(Map<String, dynamic> json) {
    return EstoqueListaC(
      quantidade: json['Quantidade'],
      id: json['id'],
      fruta: FrutaEstoque.fromJson(json['Fruta']),
      calibre: json['Calibre'],
      categoria: json['Categoria'],
    );
  }
}

class FrutaEstoque {
  int id;
  String nome;
  String variedade;

  FrutaEstoque({
    required this.nome,
    required this.variedade,
    required this.id,
  });

  factory FrutaEstoque.fromJson(Map<String, dynamic> json) {
    return FrutaEstoque(
      id: json['id'],
      nome: json['Nome'],
      variedade: json['Variedade'],
    );
  }
}

class EmbalagemEstoque {
  int id;
  String nome;

  EmbalagemEstoque({
    required this.nome,
    required this.id,
  });

  factory EmbalagemEstoque.fromJson(Map<String, dynamic> json) {
    return EmbalagemEstoque(
      id: json['id'],
      nome: json['Nome'],
    );
  }
}

class ProdutorEstoque {
  int id;
  String nome;
  String sobrenome;

  ProdutorEstoque({
    required this.nome,
    required this.sobrenome,
    required this.id,
  });

  factory ProdutorEstoque.fromJson(Map<String, dynamic> json) {
    return ProdutorEstoque(
      id: json['id'],
      nome: json['Nome'],
      sobrenome: json['Sobrenome'],
    );
  }
}
