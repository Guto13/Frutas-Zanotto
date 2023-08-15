import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maca_ipe/componetes_gerais/app_bar.dart';
import 'package:maca_ipe/componetes_gerais/campos_tabela.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/componetes_gerais/text_bold_normal.dart';
import 'package:maca_ipe/datas/palete.dart';
import 'package:maca_ipe/datas/palete_cp_lista.dart';
import 'package:maca_ipe/datas/palete_m_lista.dart';
import 'package:maca_ipe/datas/palete_o.dart';
import 'package:maca_ipe/datas/palete_pa_lista.dart';
import 'package:maca_ipe/datas/romaneio_cp.dart';
import 'package:maca_ipe/datas/romaneio_m.dart';
import 'package:maca_ipe/funcoes/banco_de_dados.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: SvgPicture.asset(
          'assets/icons/pdf.svg',
          height: 25,
        ),
      ),
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
                future: buscarPaleteM(client, widget.palete.id),
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
                future: buscarPaleteCP(client, widget.palete.id),
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
                future: buscarPaletePA(client, widget.palete.id),
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
                future: buscarPaleteO(client, widget.palete.id),
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
