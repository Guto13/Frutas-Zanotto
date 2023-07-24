class EntradaLista {
  final int id;
  final FrutaEntrada fruta;
  final EmbalagemEntrada embalagem;
  final ProdutorEntrada produtor;
  final double quantidade;
  final DateTime data;

  EntradaLista(
      {required this.id,
        required this.fruta,
      required this.embalagem,
      required this.quantidade,
      required this.produtor,
      required this.data});

  factory EntradaLista.fromJson(Map<String, dynamic> json) {
    return EntradaLista(
      id: json['id'],
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
  int id;

  FrutaEntrada({
    required this.nome,
    required this.variedade,
    required this.id,
  });

  factory FrutaEntrada.fromJson(Map<String, dynamic> json) {
    return FrutaEntrada(
      id: json['id'],
      nome: json['Nome'],
      variedade: json['Variedade'],
    );
  }
}

class EmbalagemEntrada {
  String nome;
  int id;

  EmbalagemEntrada({
    required this.nome,
    required this.id,
  });

  factory EmbalagemEntrada.fromJson(Map<String, dynamic> json) {
    return EmbalagemEntrada(
      id: json['id'],
      nome: json['Nome'],
    );
  }
}

class ProdutorEntrada {
  String nome;
  String sobrenome;
  int id;

  ProdutorEntrada({
    required this.nome,
    required this.sobrenome,
    required this.id,
  });

  factory ProdutorEntrada.fromJson(Map<String, dynamic> json) {
    return ProdutorEntrada(
      id: json['id'],
      nome: json['Nome'],
      sobrenome: json['Sobrenome'],
    );
  }
}
