import 'package:maca_ipe/datas/palete_m_lista.dart';

class CargaLista {
  final FrutaPalete fruta;
  final EmbalagemPalete embalagem;
  final String calibre;
  final int quant;
  final int cat2;

  CargaLista(
      {required this.fruta,
      required this.calibre,
      required this.embalagem,
      required this.quant,
      this.cat2 = 0});

  static int customSort(CargaLista a, CargaLista b) {
    if (a.calibre == "Total" && b.calibre != "Total") {
      return 1; // Coloca "Total" no final
    } else if (a.calibre != "Total" && b.calibre == "Total") {
      return -1; // Mantém "Total" no final
    } else {
      return a.calibre
          .compareTo(b.calibre); // Ordena os outros elementos normalmente
    }
  }
}
