import 'package:maca_ipe/datas/palete_m_lista.dart';

class PaleteCpLista {
  final int id;
  final FrutaPalete fruta;
  final EmbalagemPalete embalagem;
  final int paleteId;
  final int gg;
  final int g;
  final int m;
  final int p;
  final int pp;
  final int cat2;

  PaleteCpLista({
    required this.id,
    required this.fruta,
    required this.embalagem,
    required this.paleteId,
    required this.gg,
    required this.g,
    required this.m,
    required this.p,
    required this.pp,
    required this.cat2,
  });

  factory PaleteCpLista.fromJson(Map<String, dynamic> json) {
    return PaleteCpLista(
      id: json['id'],
      fruta: FrutaPalete.fromJson(json['Fruta']),
      embalagem: EmbalagemPalete.fromJson(json['Embalagem']),
      paleteId: json['PaleteId'],
      gg: json['GG'],
      g: json['G'],
      m: json['M'],
      p: json['P'],
      pp: json['PP'],
      cat2: json['Cat2'],
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
