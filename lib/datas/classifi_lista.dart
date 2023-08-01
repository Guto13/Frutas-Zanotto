class ClassifiLista {
  final int id;
  final FrutaEstoque fruta;
  final EmbalagemEstoque embalagem;
  final ProdutorEstoque produtor;
  final double quantidade;
  final DateTime data;
  final double refugo;
  final int romaneioId;

  ClassifiLista(
      {required this.id,
      required this.fruta,
      required this.embalagem,
      required this.produtor,
      required this.quantidade,
      required this.data,
      required this.refugo,
      required this.romaneioId});

  factory ClassifiLista.fromJson(Map<String, dynamic> json) {
    return ClassifiLista(
      quantidade: json['Quantidade'],
      id: json['id'],
      fruta: FrutaEstoque.fromJson(json['Fruta']),
      embalagem: EmbalagemEstoque.fromJson(json['Embalagem']),
      produtor: ProdutorEstoque.fromJson(json['Produtor']),
      data: DateTime.parse(json['Data']),
      refugo: json['Refugo'],
      romaneioId: json['RomaneioId'],
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
    required this.id,
    required this.nome,
    required this.sobrenome,
  });

  factory ProdutorEstoque.fromJson(Map<String, dynamic> json) {
    return ProdutorEstoque(
      id: json['id'],
      nome: json['Nome'],
      sobrenome: json['Sobrenome'],
    );
  }
}
