import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/app_bar.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/componetes_gerais/text_bold_normal.dart';
import 'package:maca_ipe/datas/romaneio_cp.dart';
import 'package:maca_ipe/datas/romaneio_lista.dart';
import 'package:maca_ipe/datas/romaneio_m.dart';
import 'package:maca_ipe/datas/romaneio_pa.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RomaneioCompleto extends StatefulWidget {
  const RomaneioCompleto({Key? key, required this.romaneio}) : super(key: key);

  final RomaneioLista romaneio;

  @override
  State<RomaneioCompleto> createState() => _RomaneioCompletoState();
}

class _RomaneioCompletoState extends State<RomaneioCompleto> {
  final client = Supabase.instance.client;
  List<RomaneioM> romaneioM = [];
  List<CalibreM> calibresM = [];
  List<RomaneioCp> romaneioCp = [];
  List<CalibreCp> calibresCp = [];
  List<RomaneioPa> romaneioPa = [];

  //recebendo dados para romaneio M
  Future<List<RomaneioM>> buscarRomaneioM(SupabaseClient client) async {
    final romaneioMJson = await client
        .from('RomaneioM')
        .select()
        .eq('RomaneioId', widget.romaneio.id);

    return parseRomaneioMJson(romaneioMJson);
  }

  List<RomaneioM> parseRomaneioMJson(List<dynamic> responseBody) {
    List<RomaneioM> romaneioM =
        responseBody.map((e) => RomaneioM.fromJson(e)).toList();
    return romaneioM;
  }

  List<CalibreM> parseCalibreM(RomaneioM r) {
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
          cat2: r.c1801 +
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

  //recebendo dados para romaneio CP

  Future<List<RomaneioCp>> buscarRomaneioCp(SupabaseClient client) async {
    final romaneioCpJson = await client
        .from('RomaneioCP')
        .select()
        .eq('RomaneioId', widget.romaneio.id);

    return parseRomaneioCpJson(romaneioCpJson);
  }

  List<RomaneioCp> parseRomaneioCpJson(List<dynamic> responseBody) {
    List<RomaneioCp> romaneioCp =
        responseBody.map((e) => RomaneioCp.fromJson(e)).toList();
    return romaneioCp;
  }

  List<CalibreCp> parseCalibreCp(RomaneioCp rcp) {
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

  //recebendo dados para romaneio PA

  Future<List<RomaneioPa>> buscarRomaneioPa(SupabaseClient client) async {
    final romaneioPaJson = await client
        .from('RomaneioPA')
        .select()
        .eq('RomaneioId', widget.romaneio.id);

    return parseRomaneioPaJson(romaneioPaJson);
  }

  List<RomaneioPa> parseRomaneioPaJson(List<dynamic> responseBody) {
    List<RomaneioPa> romaneioPa =
        responseBody.map((e) => RomaneioPa.fromJson(e)).toList();
    return romaneioPa;
  }

  List<CalibreCp> parseCalibrePa(RomaneioPa rpa) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Romaneio Completo'),
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: LayoutBuilder(builder: (context, constraints) {
          //Parte dedicada ao romaneio da maçã

          if (widget.romaneio.tfruta == 'RomaneioM') {
            return FutureBuilder<List<RomaneioM>>(
              future: buscarRomaneioM(client),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData) {
                  romaneioM = snapshot.data!;
                  calibresM = parseCalibreM(romaneioM[0]);
                  return SingleChildScrollView(
                    child: SizedBox(
                      width: romaneioArea,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CabecalhoRomaneio(widget: widget),
                          Table(
                            defaultColumnWidth: const FlexColumnWidth(1.0),
                            border:
                                TableBorder.all(color: Colors.black, width: 1),
                            children: [
                              const TableRow(
                                children: [
                                  CampoTabelaCabecalho(value: 'Calibre'),
                                  CampoTabelaCabecalho(value: 'Cat1'),
                                  CampoTabelaCabecalho(value: 'Cat2'),
                                ],
                              ),
                              ...calibresM
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
                        ],
                      ),
                    ),
                  );
                } else {
                  return const Center(
                    child: Text('Erro ao carregar dados'),
                  );
                }
              },
            );
          } else if (widget.romaneio.tfruta == 'RomaneioCP') {
            //Parte dedicada ao romaneio do Caqui e da Pêra

            return FutureBuilder<List<RomaneioCp>>(
              future: buscarRomaneioCp(client),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData) {
                  romaneioCp = snapshot.data!;
                  calibresCp = parseCalibreCp(romaneioCp[0]);
                  return SingleChildScrollView(
                    child: SizedBox(
                      width: romaneioArea,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CabecalhoRomaneio(widget: widget),
                          Table(
                            defaultColumnWidth: const FlexColumnWidth(1.0),
                            border:
                                TableBorder.all(color: Colors.black, width: 1),
                            children: [
                              const TableRow(
                                children: [
                                  CampoTabelaCabecalho(value: 'Calibre'),
                                  CampoTabelaCabecalho(value: 'Quantidade'),
                                ],
                              ),
                              ...calibresCp
                                  .map(
                                    (e) => TableRow(children: [
                                      CampoTabelaCabecalho(value: e.calibre),
                                      CampoTabela(value: e.quant.toString()),
                                    ]),
                                  )
                                  .toList(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return const Center(
                    child: Text('Erro ao carregar dados'),
                  );
                }
              },
            );
          } else if (widget.romaneio.tfruta == 'RomaneioPA') {
            //Parte dedicada ao romaneio da Ameixa e do Pêssego

            return FutureBuilder<List<RomaneioPa>>(
              future: buscarRomaneioPa(client),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData) {
                  romaneioPa = snapshot.data!;
                  calibresCp = parseCalibrePa(romaneioPa[0]);
                  return SingleChildScrollView(
                    child: SizedBox(
                      width: romaneioArea,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CabecalhoRomaneio(widget: widget),
                          Table(
                            defaultColumnWidth: const FlexColumnWidth(1.0),
                            border:
                                TableBorder.all(color: Colors.black, width: 1),
                            children: [
                              const TableRow(
                                children: [
                                  CampoTabelaCabecalho(value: 'Calibre'),
                                  CampoTabelaCabecalho(value: 'Quantidade'),
                                ],
                              ),
                              ...calibresCp
                                  .map(
                                    (e) => TableRow(children: [
                                      CampoTabelaCabecalho(value: e.calibre),
                                      CampoTabela(value: e.quant.toString()),
                                    ]),
                                  )
                                  .toList(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return const Center(
                    child: Text('Erro ao carregar dados'),
                  );
                }
              },
            );
          } else {
            return const Center();
          }
        }),
      ),
    );
  }
}

class CabecalhoRomaneio extends StatelessWidget {
  const CabecalhoRomaneio({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final RomaneioCompleto widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextBoldNormal(
                bold: 'Fruta: ',
                normal:
                    '${widget.romaneio.fruta.nome} ${widget.romaneio.fruta.variedade}',
              )),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextBoldNormal(
                bold: "Data: ",
                normal: formatDate(
                  widget.romaneio.data,
                  [dd, '-', mm, '-', yyyy],
                ),
              )),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextBoldNormal(
                bold: "Produtor: ",
                normal:
                    "${widget.romaneio.produtor.nome} ${widget.romaneio.produtor.sobrenome}",
              )),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextBoldNormal(
                bold: "Embalagem: ",
                normal: widget.romaneio.embalagem.nome,
              )),
        ],
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
