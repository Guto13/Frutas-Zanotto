class PaleteCP {
  final int id;
  final int frutaId;
  final int embalagemId;
  final int paleteId;
  final int gg;
  final int g;
  final int m;
  final int p;
  final int pp;
  final int cat2;

  PaleteCP({
    required this.id,
    required this.frutaId,
    required this.embalagemId,
    required this.paleteId,
    required this.gg,
    required this.g,
    required this.m,
    required this.p,
    required this.pp,
    required this.cat2,
  });

  factory PaleteCP.fromJson(Map<String, dynamic> json) {
    return PaleteCP(
      id: json['id'],
      frutaId: json['FrutaId'],
      embalagemId: json['EmbalagemId'],
      paleteId: json['PaleteId'],
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
      'FrutaId': frutaId,
      'EmbalagemId':embalagemId,
      'PaleteId': paleteId,
      'GG': gg,
      'G': g,
      'M': m,
      'P': p,
      'PP': pp,
      'Cat2': cat2,
    };
  }
}
