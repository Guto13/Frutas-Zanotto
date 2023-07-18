class EntradaLista {
  final FrutaEntrada fruta;
  final EmbalagemEntrada embalagem;
  final ProdutorEntrada produtor;
  final double quantidade;
  final DateTime data;

  EntradaLista(
      {required this.fruta,
      required this.embalagem,
      required this.quantidade,
      required this.produtor,
      required this.data});

  factory EntradaLista.fromJson(Map<String, dynamic> json) {
    return EntradaLista(
      quantidade: json['Quantidade'],
      data: DateTime.parse(json['Data']),
      fruta: FrutaEntrada.fromJson(json['Fruta']),
      embalagem: EmbalagemEntrada.fromJson(json['Embalagem']),
      produtor: ProdutorEntrada.fromJson(json['Produtor']),
    );
  }
}

class FrutaEntrada {
  String nome;
  String variedade;

  FrutaEntrada({
    required this.nome,
    required this.variedade,
  });

  factory FrutaEntrada.fromJson(Map<String, dynamic> json) {
    return FrutaEntrada(
      nome: json['Nome'],
      variedade: json['Variedade'],
    );
  }
}

class EmbalagemEntrada {
  String nome;

  EmbalagemEntrada({
    required this.nome,
  });

  factory EmbalagemEntrada.fromJson(Map<String, dynamic> json) {
    return EmbalagemEntrada(
      nome: json['Nome'],
    );
  }
}

class ProdutorEntrada {
  String nome;
  String sobrenome;

  ProdutorEntrada({
    required this.nome,
    required this.sobrenome,
  });

  factory ProdutorEntrada.fromJson(Map<String, dynamic> json) {
    return ProdutorEntrada(
      nome: json['Nome'],
      sobrenome: json['Sobrenome'],
    );
  }
}
