class PaleteM {
  final int id;
  final int frutaId;
  final int embalagemId;
  final int paleteId;
  final int c2201;
  final int c1981;
  final int c1801;
  final int c1651;
  final int c1501;
  final int c1351;
  final int c1201;
  final int c1101;
  final int c1001;
  final int c901;
  final int c801;
  final int c701;
  final int c1802;
  final int c1652;
  final int c1502;
  final int c1352;
  final int c1202;
  final int c1102;
  final int c1002;
  final int c902;
  final int c802;
  final int c702;
  final int comercial;

  PaleteM({
    required this.id,
    required this.frutaId,
    required this.embalagemId,
    required this.paleteId,
    required this.c2201,
    required this.c1981,
    required this.c1801,
    required this.c1651,
    required this.c1501,
    required this.c1351,
    required this.c1201,
    required this.c1101,
    required this.c1001,
    required this.c901,
    required this.c801,
    required this.c701,
    required this.c1802,
    required this.c1652,
    required this.c1502,
    required this.c1352,
    required this.c1202,
    required this.c1102,
    required this.c1002,
    required this.c902,
    required this.c802,
    required this.c702,
    required this.comercial,
  });

  factory PaleteM.fromJson(Map<String, dynamic> json) {
    return PaleteM(
      id: json['id'],
      frutaId: json['FrutaId'],
      embalagemId: json['EmbalagemId'],
      paleteId: json['PaleteId'],
      c2201: json['2201'],
      c1981: json['1981'],
      c1801: json['1801'],
      c1651: json['1651'],
      c1501: json['1501'],
      c1351: json['1351'],
      c1201: json['1201'],
      c1101: json['1101'],
      c1001: json['1001'],
      c901: json['901'],
      c801: json['801'],
      c701: json['701'],
      c1802: json['1802'],
      c1652: json['1652'],
      c1502: json['1502'],
      c1352: json['1352'],
      c1202: json['1202'],
      c1102: json['1102'],
      c1002: json['1002'],
      c902: json['902'],
      c802: json['802'],
      c702: json['702'],
      comercial: json['Comercial'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'FrutaId': frutaId,
      'EmbalagemId':embalagemId,
      'PaleteId': paleteId,
      '2201': c2201,
      '1981': c1981,
      '1801': c1801,
      '1651': c1651,
      '1501': c1501,
      '1351': c1351,
      '1201': c1201,
      '1101': c1101,
      '1001': c1001,
      '901': c901,
      '801': c801,
      '701': c701,
      '1802': c1802,
      '1652': c1652,
      '1502': c1502,
      '1352': c1352,
      '1202': c1202,
      '1102': c1102,
      '1002': c1002,
      '902': c902,
      '802': c802,
      '702': c702,
      'Comercial': comercial,
    };
  }
}

