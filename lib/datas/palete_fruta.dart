import 'package:maca_ipe/datas/classifi_lista.dart';

class PaleteFruta {
  final int id;
  final int frutaId;
  final int paleteId;
  final int quantidade;
  final String calibre;
  final String categoria;

  PaleteFruta({
    required this.id,
    required this.frutaId,
    required this.paleteId,
    required this.quantidade,
    required this.calibre,
    required this.categoria,
  });

  factory PaleteFruta.fromJson(Map<String, dynamic> json) {
    return PaleteFruta(
      id: json['id'],
      frutaId: json['FrutaId'],
      paleteId: json['PaleteId'],
      quantidade: json['Quantidade'],
      calibre: json['Calibre'],
      categoria: json['Categoria'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'FrutaId': frutaId,
      'PaleteId': paleteId,
      'Quantidade': quantidade,
      'Calibre': calibre,
      'Categoria': categoria,
    };
  }
}

class PaleteFrutaLista {
  final int id;
  final FrutaEstoque fruta;
  final int paleteId;
  int quantidade;
  final String calibre;
  final String categoria;

  PaleteFrutaLista({
    required this.id,
    required this.fruta,
    required this.paleteId,
    required this.quantidade,
    required this.calibre,
    required this.categoria,
  });

  factory PaleteFrutaLista.fromJson(Map<String, dynamic> json) {
    return PaleteFrutaLista(
      id: json['id'],
      fruta: FrutaEstoque.fromJson(json['Fruta']),
      paleteId: json['PaleteId'],
      quantidade: json['Quantidade'],
      calibre: json['Calibre'],
      categoria: json['Categoria'],
    );
  }
}
