class RomaneioCp {
  final int id;
  final int romaneioId;
  final int gg;
  final int g;
  final int m;
  final int p;
  final int pp;
  final int cat2;

  RomaneioCp({
    required this.id,
    required this.romaneioId,
    required this.gg,
    required this.g,
    required this.m,
    required this.p,
    required this.pp,
    required this.cat2,
  });

  factory RomaneioCp.fromJson(Map<String, dynamic> json) {
    return RomaneioCp(
      id: json['id'],
      romaneioId: json['RomaneioId'],
      gg: json['GG'],
      g: json['G'],
      m: json['M'],
      p: json['P'],
      pp: json['PP'],
      cat2: json['Cat2'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'RomaneioId': romaneioId,
      'GG': gg,
      'G': g,
      'M': m,
      'P': p,
      'PP': pp,
      'Cat2': cat2,
    };
  }
}

class CalibreCp {
  final String calibre;
  final int quant;

  CalibreCp({
    required this.calibre,
    required this.quant,
  });
}
