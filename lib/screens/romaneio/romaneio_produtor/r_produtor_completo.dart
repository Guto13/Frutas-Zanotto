import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/app_bar.dart';
import 'package:maca_ipe/componetes_gerais/campos_tabela.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/datas/romaneio_cp.dart';
import 'package:maca_ipe/datas/romaneio_lista.dart';
import 'package:maca_ipe/datas/romaneio_m.dart';
import 'package:maca_ipe/datas/romaneio_o.dart';
import 'package:maca_ipe/datas/romaneio_pa.dart';
import 'package:maca_ipe/funcoes/banco_de_dados.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RProdutorCompleto extends StatefulWidget {
  const RProdutorCompleto(
      {Key? key,
      required this.romaneioLista,
      required this.id,
      required this.tFruta})
      : super(key: key);

  final List<RomaneioLista> romaneioLista;
  final String tFruta;
  final int id;

  @override
  State<RProdutorCompleto> createState() => _RProdutorCompletoState();
}

class _RProdutorCompletoState extends State<RProdutorCompleto> {
  final client = Supabase.instance.client;
  List<RomaneioLista> romaneioListaok = [];

  Future<List<RomaneioM>> buscarRomaneiosM(
      List<RomaneioLista> romaneios) async {
    List<RomaneioM> romaneiosM = [];
    for (var romaneio in romaneios) {
      List<RomaneioM> aux = [];
      aux = await buscarRomaneioM(client, romaneio.id);
      romaneiosM.add(aux[0]);
    }

    return romaneiosM;
  }

  List<List<CalibreM>> buscarCalibresM(List<RomaneioM> romaneiosM) {
    List<List<CalibreM>> calibres = [];
    for (var romaneioM in romaneiosM) {
      calibres.add(parseCalibreMPRomaneio(romaneioM));
    }

    return calibres;
  }

  Future<List<RomaneioCp>> buscarRomaneiosCp(
      List<RomaneioLista> romaneios) async {
    List<RomaneioCp> romaneiosCp = [];
    for (var romaneio in romaneios) {
      List<RomaneioCp> aux = [];
      aux = await buscarRomaneioCp(client, romaneio.id);
      romaneiosCp.add(aux[0]);
    }

    return romaneiosCp;
  }

  List<List<CalibreCp>> buscarCalibresCp(List<RomaneioCp> romaneiosCp) {
    List<List<CalibreCp>> calibres = [];
    for (var romaneioCp in romaneiosCp) {
      calibres.add(parseCalibreCpPRomaneio(romaneioCp));
    }

    return calibres;
  }

  Future<List<RomaneioPa>> buscarRomaneiosPa(
      List<RomaneioLista> romaneios) async {
    List<RomaneioPa> romaneiosPa = [];
    for (var romaneio in romaneios) {
      List<RomaneioPa> aux = [];
      aux = await buscarRomaneioPa(client, romaneio.id);
      romaneiosPa.add(aux[0]);
    }

    return romaneiosPa;
  }

  List<List<CalibreCp>> buscarCalibresPa(List<RomaneioPa> romaneiosPa) {
    List<List<CalibreCp>> calibres = [];
    for (var romaneioPa in romaneiosPa) {
      calibres.add(parseCalibrePaPRomaneio(romaneioPa));
    }

    return calibres;
  }

  Future<List<RomaneioO>> buscarRomaneiosO(
      List<RomaneioLista> romaneios) async {
    List<RomaneioO> romaneiosO = [];
    for (var romaneio in romaneios) {
      List<RomaneioO> aux = [];
      aux = await buscarRomaneioO(client, romaneio.id);
      romaneiosO.add(aux[0]);
    }

    return romaneiosO;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
          title:
              'Romaneio ${widget.romaneioLista.first.produtor.nome} Completo'),
      body: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: LayoutBuilder(builder: (context, constraints) {
              romaneioListaok.clear();
              for (var romaneio in widget.romaneioLista) {
                if (romaneio.tfruta == widget.tFruta) {
                  romaneioListaok.add(romaneio);
                }
              }

              if (widget.tFruta == 'RomaneioM') {
                return FutureBuilder<List<RomaneioM>>(
                  future: buscarRomaneiosM(romaneioListaok),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasData) {
                      List<RomaneioM> romaneioM = snapshot.data!;
                      List<List<CalibreM>> calibresM =
                          buscarCalibresM(romaneioM);
                      calibresM = addTotaisCalibreM(calibresM);
                      int isHeaderAdded = 0;
                      return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Row(
                          children: calibresM.map((ele) {
                            isHeaderAdded++;
                            return SizedBox(
                                width: isHeaderAdded == 1
                                    ? romaneioArea
                                    : (romaneioArea / 3) * 2,
                                child: Column(
                                  children: [
                                    if (isHeaderAdded != calibresM.length)
                                      Text(formatDate(
                                          romaneioListaok[isHeaderAdded - 1]
                                              .data,
                                          [dd, '-', mm, '-', yyyy])),
                                    if (isHeaderAdded == calibresM.length)
                                      const Text('Totais'),
                                    const SizedBox(
                                      height: defaultPadding,
                                    ),
                                    Table(
                                      defaultColumnWidth:
                                          const FlexColumnWidth(1.0),
                                      border: TableBorder.all(
                                          color: Colors.black, width: 1),
                                      children: [
                                        if (isHeaderAdded == 1)
                                          const TableRow(
                                            children: [
                                              CampoTabelaCabecalho(
                                                  value: 'Calibre'),
                                              CampoTabelaCabecalho(
                                                  value: 'Cat1'),
                                              CampoTabelaCabecalho(
                                                  value: 'Cat2'),
                                            ],
                                          ),
                                        if (isHeaderAdded != 1)
                                          const TableRow(
                                            children: [
                                              CampoTabelaCabecalho(
                                                  value: 'Cat1'),
                                              CampoTabelaCabecalho(
                                                  value: 'Cat2'),
                                            ],
                                          ),
                                        if (isHeaderAdded == 1)
                                          ...ele
                                              .map(
                                                (e) => TableRow(children: [
                                                  CampoTabelaCabecalho(
                                                      value: e.calibre),
                                                  CampoTabela(
                                                      value: e.cat1.toString()),
                                                  CampoTabela(
                                                      value: e.cat2.toString()),
                                                ]),
                                              )
                                              .toList(),
                                        if (isHeaderAdded != 1)
                                          ...ele
                                              .map(
                                                (e) => TableRow(children: [
                                                  CampoTabela(
                                                      value: e.cat1.toString()),
                                                  CampoTabela(
                                                      value: e.cat2.toString()),
                                                ]),
                                              )
                                              .toList(),
                                      ],
                                    ),
                                  ],
                                ));
                          }).toList(),
                        ),
                      );
                    } else {
                      return const Center(
                        child: Text('Erro ao carregar dados'),
                      );
                    }
                  },
                );
              } else if (widget.tFruta == 'RomaneioCP') {
                return FutureBuilder<List<RomaneioCp>>(
                  future: buscarRomaneiosCp(romaneioListaok),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasData) {
                      List<RomaneioCp> romaneioCp = snapshot.data!;
                      List<List<CalibreCp>> calibreCp =
                          buscarCalibresCp(romaneioCp);
                      calibreCp = addTotaisCalibreCP(calibreCp);
                      int isHeaderAdded = 0;
                      return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Row(
                          children: calibreCp.map((ele) {
                            isHeaderAdded++;
                            return SizedBox(
                                width: isHeaderAdded == 1
                                    ? romaneioArea
                                    : romaneioArea / 2,
                                child: Column(
                                  children: [
                                    if (isHeaderAdded != calibreCp.length)
                                      Text(formatDate(
                                          romaneioListaok[isHeaderAdded - 1]
                                              .data,
                                          [dd, '-', mm, '-', yyyy])),
                                    if (isHeaderAdded == calibreCp.length)
                                      const Text('Totais'),
                                    const SizedBox(
                                      height: defaultPadding,
                                    ),
                                    Table(
                                      defaultColumnWidth:
                                          const FlexColumnWidth(1.0),
                                      border: TableBorder.all(
                                          color: Colors.black, width: 1),
                                      children: [
                                        if (isHeaderAdded == 1)
                                          const TableRow(
                                            children: [
                                              CampoTabelaCabecalho(
                                                  value: 'Calibre'),
                                              CampoTabelaCabecalho(
                                                  value: 'Quant'),
                                            ],
                                          ),
                                        if (isHeaderAdded != 1)
                                          const TableRow(
                                            children: [
                                              CampoTabelaCabecalho(
                                                  value: 'Quant'),
                                            ],
                                          ),
                                        if (isHeaderAdded == 1)
                                          ...ele
                                              .map(
                                                (e) => TableRow(children: [
                                                  CampoTabelaCabecalho(
                                                      value: e.calibre),
                                                  CampoTabela(
                                                      value:
                                                          e.quant.toString()),
                                                ]),
                                              )
                                              .toList(),
                                        if (isHeaderAdded != 1)
                                          ...ele
                                              .map(
                                                (e) => TableRow(children: [
                                                  CampoTabela(
                                                      value:
                                                          e.quant.toString()),
                                                ]),
                                              )
                                              .toList(),
                                      ],
                                    ),
                                  ],
                                ));
                          }).toList(),
                        ),
                      );
                    } else {
                      return const Center(
                        child: Text('Erro ao carregar dados'),
                      );
                    }
                  },
                );
              } else if (widget.tFruta == 'RomaneioO') {
                return FutureBuilder<List<RomaneioO>>(
                  future: buscarRomaneiosO(romaneioListaok),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasData) {
                      List<RomaneioO> romaneioO = snapshot.data!;
                      int isHeaderAdded = 0;
                      return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Row(
                          children: romaneioO.map((ele) {
                            isHeaderAdded++;
                            return SizedBox(
                                width: isHeaderAdded == 1
                                    ? romaneioArea
                                    : romaneioArea / 2,
                                child: Column(
                                  children: [
                                    if (isHeaderAdded != romaneioO.length)
                                      Text(formatDate(
                                          romaneioListaok[isHeaderAdded - 1]
                                              .data,
                                          [dd, '-', mm, '-', yyyy])),
                                    if (isHeaderAdded == romaneioO.length)
                                      const Text('Totais'),
                                    const SizedBox(
                                      height: defaultPadding,
                                    ),
                                    Table(
                                      defaultColumnWidth:
                                          const FlexColumnWidth(1.0),
                                      border: TableBorder.all(
                                          color: Colors.black, width: 1),
                                      children: [
                                        if (isHeaderAdded == 1)
                                          const TableRow(
                                            children: [
                                              CampoTabelaCabecalho(
                                                  value: 'Calibre'),
                                              CampoTabelaCabecalho(
                                                  value: 'Quant'),
                                            ],
                                          ),
                                        if (isHeaderAdded != 1)
                                          const TableRow(
                                            children: [
                                              CampoTabelaCabecalho(
                                                  value: 'Quant'),
                                            ],
                                          ),
                                        if (isHeaderAdded == 1)
                                          TableRow(children: [
                                            CampoTabelaCabecalho(
                                                value: ele.nome),
                                            CampoTabela(
                                                value: ele.quant.toString()),
                                          ]),
                                        if (isHeaderAdded != 1)
                                          TableRow(children: [
                                            CampoTabela(
                                                value: ele.quant.toString()),
                                          ]),
                                      ],
                                    ),
                                  ],
                                ));
                          }).toList(),
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
                return FutureBuilder<List<RomaneioPa>>(
                  future: buscarRomaneiosPa(romaneioListaok),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasData) {
                      List<RomaneioPa> romaneioPa = snapshot.data!;
                      List<List<CalibreCp>> calibreCp =
                          buscarCalibresPa(romaneioPa);
                      calibreCp = addTotaisCalibrePA(calibreCp);
                      int isHeaderAdded = 0;
                      return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Row(
                          children: calibreCp.map((ele) {
                            isHeaderAdded++;
                            return SizedBox(
                                width: isHeaderAdded == 1
                                    ? romaneioArea
                                    : romaneioArea / 2,
                                child: Column(
                                  children: [
                                    if (isHeaderAdded != calibreCp.length)
                                      Text(formatDate(
                                          romaneioListaok[isHeaderAdded - 1]
                                              .data,
                                          [dd, '-', mm, '-', yyyy])),
                                    if (isHeaderAdded == calibreCp.length)
                                      const Text('Totais'),
                                    const SizedBox(
                                      height: defaultPadding,
                                    ),
                                    Table(
                                      defaultColumnWidth:
                                          const FlexColumnWidth(1.0),
                                      border: TableBorder.all(
                                          color: Colors.black, width: 1),
                                      children: [
                                        if (isHeaderAdded == 1)
                                          const TableRow(
                                            children: [
                                              CampoTabelaCabecalho(
                                                  value: 'Calibre'),
                                              CampoTabelaCabecalho(
                                                  value: 'Quant'),
                                            ],
                                          ),
                                        if (isHeaderAdded != 1)
                                          const TableRow(
                                            children: [
                                              CampoTabelaCabecalho(
                                                  value: 'Quant'),
                                            ],
                                          ),
                                        if (isHeaderAdded == 1)
                                          ...ele
                                              .map(
                                                (e) => TableRow(children: [
                                                  CampoTabelaCabecalho(
                                                      value: e.calibre),
                                                  CampoTabela(
                                                      value:
                                                          e.quant.toString()),
                                                ]),
                                              )
                                              .toList(),
                                        if (isHeaderAdded != 1)
                                          ...ele
                                              .map(
                                                (e) => TableRow(children: [
                                                  CampoTabela(
                                                      value:
                                                          e.quant.toString()),
                                                ]),
                                              )
                                              .toList(),
                                      ],
                                    ),
                                  ],
                                ));
                          }).toList(),
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
          )),
    );
  }
}
