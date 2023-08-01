class RomaneioPa {
  final int id;
  final int romaneioId;
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

  RomaneioPa({
    required this.id,
    required this.romaneioId,
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

  factory RomaneioPa.fromJson(Map<String, dynamic> json) {
    return RomaneioPa(
      id: json['id'],
      romaneioId: json['RomaneioId'],
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

  Map<String, dynamic> toMap() {
    return {
      'RomaneioId': romaneioId,
      '45': c45,
      '40': c40,
      '32': c32,
      '36': c36,
      '30': c30,
      '28': c28,
      '24': c24,
      '22': c22,
      '20': c20,
      '18': c18,
      '14': c14,
      '12': c12,
      'Cat2': cat2,
    };
  }
}
