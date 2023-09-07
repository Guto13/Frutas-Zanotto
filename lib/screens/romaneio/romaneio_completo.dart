import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/app_bar.dart';
import 'package:maca_ipe/componetes_gerais/campos_tabela.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/componetes_gerais/text_bold_normal.dart';
import 'package:maca_ipe/datas/romaneio_cp.dart';
import 'package:maca_ipe/datas/romaneio_lista.dart';
import 'package:maca_ipe/datas/romaneio_m.dart';
import 'package:maca_ipe/datas/romaneio_o.dart';
import 'package:maca_ipe/datas/romaneio_pa.dart';
import 'package:maca_ipe/funcoes/banco_de_dados.dart';
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
              future: buscarRomaneioM(client, widget.romaneio.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData) {
                  romaneioM = snapshot.data!;
                  calibresM = parseCalibreMPRomaneio(romaneioM[0]);
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
              future: buscarRomaneioCp(client, widget.romaneio.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData) {
                  romaneioCp = snapshot.data!;
                  calibresCp = parseCalibreCpPRomaneio(romaneioCp[0]);
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
              future: buscarRomaneioPa(client, widget.romaneio.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData) {
                  romaneioPa = snapshot.data!;
                  calibresCp = parseCalibrePaPRomaneio(romaneioPa[0]);
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
            return FutureBuilder<List<RomaneioO>>(
              future: buscarRomaneioO(client, widget.romaneio.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData) {
                  List<RomaneioO> romaneioO = snapshot.data!;
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
                                  CampoTabelaCabecalho(value: 'Nome'),
                                  CampoTabelaCabecalho(value: 'Quantidade'),
                                ],
                              ),
                              ...romaneioO
                                  .map(
                                    (e) => TableRow(children: [
                                      CampoTabelaCabecalho(value: e.nome),
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
