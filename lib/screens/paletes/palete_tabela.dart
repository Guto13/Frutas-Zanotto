import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/app_bar.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/componetes_gerais/text_bold_normal.dart';
import 'package:maca_ipe/datas/palete.dart';
import 'package:maca_ipe/datas/palete_cp_lista.dart';
import 'package:maca_ipe/datas/palete_m_lista.dart';
import 'package:maca_ipe/datas/palete_o.dart';
import 'package:maca_ipe/datas/palete_pa_lista.dart';
import 'package:maca_ipe/datas/romaneio_cp.dart';
import 'package:maca_ipe/datas/romaneio_m.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PaleteTabela extends StatefulWidget {
  const PaleteTabela({Key? key, required this.palete}) : super(key: key);

  final Palete palete;

  @override
  State<PaleteTabela> createState() => _PaleteTabelaState();
}

class _PaleteTabelaState extends State<PaleteTabela> {
  final client = Supabase.instance.client;
  List<PaleteMLista> paleteM = [];
  List<CalibreM> calibresM = [];
  List<PaleteCpLista> paleteCP = [];
  List<CalibreCp> calibresCP = [];
  List<PaletePALista> paletePA = [];
  List<CalibreCp> calibresPA = [];
  List<PaleteO> paleteO = [];

  //recebendo dados para palete m
  Future<List<PaleteMLista>> buscarPaleteM(SupabaseClient client) async {
    final paleteMJson = await client
        .from('PaleteM')
        .select('*, Fruta(id, Nome, Variedade), Embalagem(id, Nome)')
        .eq('PaleteId', widget.palete.id);

    return parsePaleteMJson(paleteMJson);
  }

  List<PaleteMLista> parsePaleteMJson(List<dynamic> responseBody) {
    List<PaleteMLista> paleteM =
        responseBody.map((e) => PaleteMLista.fromJson(e)).toList();
    return paleteM;
  }

  List<CalibreM> parseCalibreM(PaleteMLista r) {
    List<CalibreM> calibrem = [
      CalibreM(calibre: '220', cat1: r.c2201, cat2: 0),
      CalibreM(calibre: '198', cat1: r.c1981, cat2: 0),
      CalibreM(calibre: '180', cat1: r.c1801, cat2: r.c1802),
      CalibreM(calibre: '165', cat1: r.c1651, cat2: r.c1652),
      CalibreM(calibre: '150', cat1: r.c1501, cat2: r.c1502),
      CalibreM(calibre: '135', cat1: r.c1351, cat2: r.c1352),
      CalibreM(calibre: '120', cat1: r.c1201, cat2: r.c1202),
      CalibreM(calibre: '110', cat1: r.c1101, cat2: r.c1102),
      CalibreM(calibre: '100', cat1: r.c1001, cat2: r.c1002),
      CalibreM(calibre: '90', cat1: r.c901, cat2: r.c902),
      CalibreM(calibre: '80', cat1: r.c801, cat2: r.c802),
      CalibreM(calibre: '70', cat1: r.c701, cat2: r.c702),
      CalibreM(calibre: 'Comercial', cat1: 0, cat2: r.comercial),
      CalibreM(
          calibre: 'Total',
          cat1: r.c2201 +
              r.c1981 +
              r.c1801 +
              r.c1651 +
              r.c1501 +
              r.c1351 +
              r.c1201 +
              r.c1101 +
              r.c1001 +
              r.c901 +
              r.c801 +
              r.c701,
          cat2: r.c1802 +
              r.c1652 +
              r.c1502 +
              r.c1352 +
              r.c1202 +
              r.c1102 +
              r.c1002 +
              r.c902 +
              r.c802 +
              r.c702 +
              r.comercial),
    ];
    return calibrem;
  }

  //recebendo dados para palete CP

  Future<List<PaleteCpLista>> buscarPaleteCP(SupabaseClient client) async {
    final paleteCPJson = await client
        .from('PaleteCP')
        .select('*, Fruta(id, Nome, Variedade), Embalagem(id, Nome)')
        .eq('PaleteId', widget.palete.id);

    return parsePaleteCPJson(paleteCPJson);
  }

  List<PaleteCpLista> parsePaleteCPJson(List<dynamic> responseBody) {
    List<PaleteCpLista> paleteCP =
        responseBody.map((e) => PaleteCpLista.fromJson(e)).toList();
    return paleteCP;
  }

  List<CalibreCp> parseCalibreCp(PaleteCpLista rcp) {
    List<CalibreCp> calibrecp = [
      CalibreCp(calibre: 'GG', quant: rcp.gg),
      CalibreCp(calibre: 'G', quant: rcp.g),
      CalibreCp(calibre: 'M', quant: rcp.m),
      CalibreCp(calibre: 'P', quant: rcp.p),
      CalibreCp(calibre: 'PP', quant: rcp.pp),
      CalibreCp(calibre: 'Cat 2', quant: rcp.cat2),
      CalibreCp(
          calibre: 'Total',
          quant: rcp.gg + rcp.g + rcp.m + rcp.p + rcp.pp + rcp.cat2),
    ];
    return calibrecp;
  }

  //recebendo dados para palete PA
  Future<List<PaletePALista>> buscarPaletePA(SupabaseClient client) async {
    final paletePAJson = await client
        .from('PaletePA')
        .select('*, Fruta(id, Nome, Variedade), Embalagem(id, Nome)')
        .eq('PaleteId', widget.palete.id);

    return parsePaletePAJson(paletePAJson);
  }

  List<PaletePALista> parsePaletePAJson(List<dynamic> responseBody) {
    List<PaletePALista> paletePA =
        responseBody.map((e) => PaletePALista.fromJson(e)).toList();
    return paletePA;
  }

  List<CalibreCp> parseCalibrePa(PaletePALista rpa) {
    List<CalibreCp> calibrecp = [
      CalibreCp(calibre: '45', quant: rpa.c45),
      CalibreCp(calibre: '40', quant: rpa.c40),
      CalibreCp(calibre: '36', quant: rpa.c36),
      CalibreCp(calibre: '32', quant: rpa.c32),
      CalibreCp(calibre: '30', quant: rpa.c30),
      CalibreCp(calibre: '28', quant: rpa.c28),
      CalibreCp(calibre: '24', quant: rpa.c24),
      CalibreCp(calibre: '22', quant: rpa.c22),
      CalibreCp(calibre: '20', quant: rpa.c20),
      CalibreCp(calibre: '18', quant: rpa.c18),
      CalibreCp(calibre: '14', quant: rpa.c14),
      CalibreCp(calibre: '12', quant: rpa.c12),
      CalibreCp(calibre: 'Cat 2', quant: rpa.cat2),
      CalibreCp(
          calibre: 'Total',
          quant: rpa.c45 +
              rpa.c40 +
              rpa.c36 +
              rpa.c32 +
              rpa.c30 +
              rpa.c28 +
              rpa.c24 +
              rpa.c22 +
              rpa.c20 +
              rpa.c18 +
              rpa.c14 +
              rpa.c12 +
              rpa.cat2),
    ];
    return calibrecp;
  }

  //recebendo dados para palete O
  Future<List<PaleteO>> buscarPaleteO(SupabaseClient client) async {
    final paleteOJson =
        await client.from('PaleteO').select().eq('PaleteId', widget.palete.id);

    return parsePaleteOJson(paleteOJson);
  }

  List<PaleteO> parsePaleteOJson(List<dynamic> responseBody) {
    List<PaleteO> paleteO =
        responseBody.map((e) => PaleteO.fromJson(e)).toList();
    return paleteO;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Palete completo'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextBoldNormal(
                    bold: 'Palete: ',
                    normal: widget.palete.id.toString(),
                  )),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextBoldNormal(
                    bold: "Data: ",
                    normal: formatDate(
                      widget.palete.data,
                      [dd, '-', mm, '-', yyyy],
                    ),
                  )),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextBoldNormal(
                    bold: "Carga: ",
                    normal: widget.palete.carga.toString(),
                  )),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextBoldNormal(
                    bold: "Carregado: ",
                    normal: widget.palete.carregado ? 'Sim' : 'Não',
                  )),
              const SizedBox(
                height: defaultPadding * 3,
              ),
              FutureBuilder<List<PaleteMLista>>(
                future: buscarPaleteM(client),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData) {
                    if (snapshot.data!.isNotEmpty) {
                      paleteM = snapshot.data!;
                      calibresM = parseCalibreM(paleteM[0]);
                      return SizedBox(
                        width: romaneioArea,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextBoldNormal(
                                bold: 'Fruta: ',
                                normal:
                                    '${paleteM[0].fruta.nome} ${paleteM[0].fruta.variedade}'),
                            TextBoldNormal(
                                bold: 'Embalagem: ',
                                normal: paleteM[0].embalagem.nome),
                            const SizedBox(height: defaultPadding),
                            Table(
                              defaultColumnWidth: const FlexColumnWidth(1.0),
                              border: TableBorder.all(
                                  color: Colors.black, width: 1),
                              children: [
                                const TableRow(
                                  children: [
                                    CampoTabelaCabecalho(value: 'Calibre'),
                                    CampoTabelaCabecalho(value: 'Cat1'),
                                    CampoTabelaCabecalho(value: 'Cat2'),
                                  ],
                                ),
                                ...calibresM
                                    .where(
                                        (ele) => ele.cat1 > 0 || ele.cat2 > 0)
                                    .map(
                                      (e) => TableRow(children: [
                                        CampoTabelaCabecalho(value: e.calibre),
                                        CampoTabela(value: e.cat1.toString()),
                                        CampoTabela(value: e.cat2.toString()),
                                      ]),
                                    )
                                    .toList(),
                              ],
                            ),
                            const SizedBox(
                              height: defaultPadding,
                            ),
                            const Divider(),
                            const SizedBox(
                              height: defaultPadding,
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const Center();
                    }
                  } else {
                    return const Center(
                      child: Text('Erro ao carregar dados'),
                    );
                  }
                },
              ),
              FutureBuilder<List<PaleteCpLista>>(
                future: buscarPaleteCP(client),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData) {
                    if (snapshot.data!.isNotEmpty) {
                      paleteCP = snapshot.data!;
                      calibresCP = parseCalibreCp(paleteCP[0]);
                      return SizedBox(
                        width: romaneioArea,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextBoldNormal(
                                bold: 'Fruta: ',
                                normal:
                                    '${paleteCP[0].fruta.nome} ${paleteCP[0].fruta.variedade}'),
                            TextBoldNormal(
                                bold: 'Embalagem: ',
                                normal: paleteCP[0].embalagem.nome),
                            const SizedBox(height: defaultPadding),
                            Table(
                              defaultColumnWidth: const FlexColumnWidth(1.0),
                              border: TableBorder.all(
                                  color: Colors.black, width: 1),
                              children: [
                                const TableRow(
                                  children: [
                                    CampoTabelaCabecalho(value: 'Calibre'),
                                    CampoTabelaCabecalho(value: 'Quantidade'),
                                  ],
                                ),
                                ...calibresCP
                                    .where((ele) => ele.quant > 0)
                                    .map(
                                      (e) => TableRow(children: [
                                        CampoTabelaCabecalho(value: e.calibre),
                                        CampoTabela(value: e.quant.toString()),
                                      ]),
                                    )
                                    .toList(),
                              ],
                            ),
                            const SizedBox(
                              height: defaultPadding,
                            ),
                            const Divider(),
                            const SizedBox(
                              height: defaultPadding,
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const Center();
                    }
                  } else {
                    return const Center(
                      child: Text('Erro ao carregar dados'),
                    );
                  }
                },
              ),
              FutureBuilder<List<PaletePALista>>(
                future: buscarPaletePA(client),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData) {
                    if (snapshot.data!.isNotEmpty) {
                      paletePA = snapshot.data!;
                      calibresPA = parseCalibrePa(paletePA[0]);
                      return SizedBox(
                        width: romaneioArea,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextBoldNormal(
                                bold: 'Fruta: ',
                                normal:
                                    '${paletePA[0].fruta.nome} ${paletePA[0].fruta.variedade}'),
                            TextBoldNormal(
                                bold: 'Embalagem: ',
                                normal: paletePA[0].embalagem.nome),
                            const SizedBox(height: defaultPadding),
                            Table(
                              defaultColumnWidth: const FlexColumnWidth(1.0),
                              border: TableBorder.all(
                                  color: Colors.black, width: 1),
                              children: [
                                const TableRow(
                                  children: [
                                    CampoTabelaCabecalho(value: 'Calibre'),
                                    CampoTabelaCabecalho(value: 'Quantidade'),
                                  ],
                                ),
                                ...calibresPA
                                    .where((ele) => ele.quant > 0)
                                    .map(
                                      (e) => TableRow(children: [
                                        CampoTabelaCabecalho(value: e.calibre),
                                        CampoTabela(value: e.quant.toString()),
                                      ]),
                                    )
                                    .toList(),
                              ],
                            ),
                            const SizedBox(
                              height: defaultPadding,
                            ),
                            const Divider(),
                            const SizedBox(
                              height: defaultPadding,
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const Center();
                    }
                  } else {
                    return const Center(
                      child: Text('Erro ao carregar dados'),
                    );
                  }
                },
              ),
              FutureBuilder<List<PaleteO>>(
                future: buscarPaleteO(client),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData) {
                    if (snapshot.data!.isNotEmpty) {
                      paleteO = snapshot.data!;
                      return SizedBox(
                        width: romaneioArea,
                        child: Table(
                          defaultColumnWidth: const FlexColumnWidth(1.0),
                          border:
                              TableBorder.all(color: Colors.black, width: 1),
                          children: [
                            const TableRow(
                              children: [
                                CampoTabelaCabecalho(value: 'Fruta'),
                                CampoTabelaCabecalho(value: 'Embalagem'),
                                CampoTabelaCabecalho(value: 'Quantidade'),
                              ],
                            ),
                            ...paleteO
                                .where((ele) => ele.quant > 0)
                                .map(
                                  (e) => TableRow(children: [
                                    CampoTabelaCabecalho(value: e.nome),
                                    CampoTabelaCabecalho(value: e.embalagem),
                                    CampoTabela(value: e.quant.toString()),
                                  ]),
                                )
                                .toList(),
                          ],
                        ),
                      );
                    } else {
                      return const Center();
                    }
                  } else {
                    return const Center(
                      child: Text('Erro ao carregar dados'),
                    );
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CampoTabelaCabecalho extends StatelessWidget {
  final String value;

  const CampoTabelaCabecalho({Key? key, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: TableCell(
          child: Center(
              child: SelectableText(
        value,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ))),
    );
  }
}

class CampoTabela extends StatelessWidget {
  final String value;

  const CampoTabela({Key? key, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: TableCell(
          child: Center(
              child: SelectableText(
        value,
      ))),
    );
  }
}
