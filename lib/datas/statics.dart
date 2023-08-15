class StaticsPaletes {
  double maca;
  double ameixa;
  double pessego;
  double pera;
  double caqui;
  double outro;

  StaticsPaletes(
      {this.maca = 0,
      this.ameixa = 0,
      this.pessego = 0,
      this.pera = 0,
      this.caqui = 0,
      this.outro = 0});

  Map<String, double> toMap() {
    return {
      'Maçã': maca,
      'Ameixa': ameixa,
      'Pêssego': pessego,
      'Pêra': pera,
      'Caqui': caqui,
      'Outro': outro,
    };
  }
}

class StaticsEstoque {
  String fruta;
  String produtor;
  double quantFruta;
  double quantProdut;

  StaticsEstoque({
    this.fruta = "",
    this.produtor = "",
    this.quantFruta = 0.0,
    this.quantProdut = 0.0,
  });

}
