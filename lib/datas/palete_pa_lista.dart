import 'package:maca_ipe/datas/palete_m_lista.dart';

class PaletePALista {
  final int id;
  final FrutaPalete fruta;
  final EmbalagemPalete embalagem;
  final int paleteId;
  final int c45;
  final int c40;
  final int c36;
  final int c32;
  final int c30;
  final int c28;
  final int c24;
  final int c22;
  final int c20;
  final int c18;
  final int c14;
  final int c12;
  final int cat2;

  PaletePALista({
    required this.id,
    required this.fruta,
    required this.embalagem,
    required this.paleteId,
    required this.c45,
    required this.c40,
    required this.c36,
    required this.c32,
    required this.c30,
    required this.c28,
    required this.c24,
    required this.c22,
    required this.c20,
    required this.c18,
    required this.c14,
    required this.c12,
    required this.cat2,
  });

  factory PaletePALista.fromJson(Map<String, dynamic> json) {
    return PaletePALista(
      id: json['id'],
      fruta: FrutaPalete.fromJson(json['Fruta']),
      embalagem: EmbalagemPalete.fromJson(json['Embalagem']),
      paleteId: json['PaleteId'],
      c45: json['45'],
      c40: json['40'],
      c32: json['32'],
      c36: json['36'],
      c30: json['30'],
      c28: json['28'],
      c24: json['24'],
      c22: json['22'],
      c20: json['20'],
      c18: json['18'],
      c14: json['14'],
      c12: json['12'],
      cat2: json['Cat2'],
    );
  }
}
