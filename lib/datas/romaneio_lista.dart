class RomaneioLista {
  final int id;
  final FrutaRomaneio fruta;
  final EmbalagemRomaneio embalagem;
  final ProdutorRomaneio produtor;
  final String tfruta;
  final DateTime data;

  RomaneioLista(
      {required this.id,
      required this.fruta,
      required this.embalagem,
      required this.tfruta,
      required this.produtor,
      required this.data});

  factory RomaneioLista.fromJson(Map<String, dynamic> json) {
    return RomaneioLista(
      id: json['id'],
      tfruta: json['TFruta'],
      data: DateTime.parse(json['Data']),
      fruta: FrutaRomaneio.fromJson(json['Fruta']),
      embalagem: EmbalagemRomaneio.fromJson(json['Embalagem']),
      produtor: ProdutorRomaneio.fromJson(json['Produtor']),
    );
  }
}

class FrutaRomaneio {
  String nome;
  String variedade;
  int id;

  FrutaRomaneio({
    required this.nome,
    required this.variedade,
    required this.id,
  });

  factory FrutaRomaneio.fromJson(Map<String, dynamic> json) {
    return FrutaRomaneio(
      id: json['id'],
      nome: json['Nome'],
      variedade: json['Variedade'],
    );
  }
}

class EmbalagemRomaneio {
  String nome;
  int id;

  EmbalagemRomaneio({
    required this.nome,
    required this.id,
  });

  factory EmbalagemRomaneio.fromJson(Map<String, dynamic> json) {
    return EmbalagemRomaneio(
      id: json['id'],
      nome: json['Nome'],
    );
  }
}

class ProdutorRomaneio {
  String nome;
  String sobrenome;
  int id;

  ProdutorRomaneio({
    required this.nome,
    required this.sobrenome,
    required this.id,
  });

  factory ProdutorRomaneio.fromJson(Map<String, dynamic> json) {
    return ProdutorRomaneio(
      id: json['id'],
      nome: json['Nome'],
      sobrenome: json['Sobrenome'],
    );
  }
}
