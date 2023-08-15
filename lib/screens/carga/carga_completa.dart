import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:maca_ipe/componetes_gerais/app_bar.dart';
import 'package:maca_ipe/componetes_gerais/campos_tabela.dart';
import 'package:maca_ipe/componetes_gerais/text_bold_normal.dart';
import 'package:maca_ipe/componetes_gerais/title_medium.dart';
import 'package:maca_ipe/datas/carga.dart';
import 'package:maca_ipe/datas/carga_lista.dart';
import 'package:maca_ipe/datas/palete.dart';
import 'package:maca_ipe/datas/palete_cp_lista.dart';
import 'package:maca_ipe/datas/palete_m_lista.dart';
import 'package:maca_ipe/datas/palete_o.dart';
import 'package:maca_ipe/datas/palete_pa_lista.dart';
import 'package:maca_ipe/datas/romaneio_cp.dart';
import 'package:maca_ipe/datas/romaneio_m.dart';
import 'package:maca_ipe/funcoes/banco_de_dados.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../componetes_gerais/constants.dart';

class CargaCompleta extends StatefulWidget {
  const CargaCompleta({Key? key, required this.carga}) : super(key: key);

  final Carga carga;

  @override
  State<CargaCompleta> createState() => _CargaCompletaState();
}

class _CargaCompletaState extends State<CargaCompleta> {
  final client = Supabase.instance.client;
  List<Palete> paletes = [];
  List<CalibreM> calibreMCerto = [];
  PaleteMLista? paleteM;
  PaleteCpLista? paleteCp;
  PaleteO? paleteO;
  PaletePALista? paletePa;
  List<CargaLista> cargaLista = [];
  List<CargaLista> cargaListaUse = [];

  Future<List<CargaLista>> fetchResults(List<Palete> paletes) async {
    for (var e in paletes) {
      final responses = await Future.wait([
        client
            .from('PaleteM')
            .select('*, Fruta(id, Nome, Variedade), Embalagem(id, Nome)')
            .eq('PaleteId', e.id),
        client
            .from('PaleteCP')
            .select('*, Fruta(id, Nome, Variedade), Embalagem(id, Nome)')
            .eq('PaleteId', e.id),
        client.from('PaleteO').select().eq('PaleteId', e.id),
        client
            .from('PaletePA')
            .select('*, Fruta(id, Nome, Variedade), Embalagem(id, Nome)')
            .eq('PaleteId', e.id),
      ]);
      if (responses[0].isNotEmpty) {
        paleteM = PaleteMLista.fromJson(responses[0][0]);
      }

      if (responses[1].isNotEmpty) {
        paleteCp = PaleteCpLista.fromJson(responses[1][0]);
      }

      if (responses[2].isNotEmpty) {
        paleteO = PaleteO.fromJson(responses[2][0]);
      }

      if (responses[3].isNotEmpty) {
        paletePa = PaletePALista.fromJson(responses[3][0]);
      }

      if (paleteM != null) {
        List<CalibreM> calibreM = parseCalibreM(paleteM!);
        calibreM.where((ele) => ele.cat1 > 0 || ele.cat2 > 0).map((c) {
          bool somou = false;
          for (var i = 0; i < cargaLista.length; i++) {
            if (cargaLista[i].calibre == c.calibre) {
              if (c.calibre == "Total") {
                if (cargaLista[i].fruta.nome == "Maçã") {
                  int quant = cargaLista[i].quant + c.cat1;
                  int quantCat2 = cargaLista[i].cat2 + c.cat2;
                  cargaLista.removeWhere((element) =>
                      element.calibre == c.calibre &&
                      (element.fruta.nome == "Maçã"));

                  cargaLista.add(CargaLista(
                      fruta: paleteM!.fruta,
                      calibre: c.calibre,
                      embalagem: paleteM!.embalagem,
                      quant: quant,
                      cat2: quantCat2));
                  somou = true;
                  break;
                }
              } else {
                int quant = cargaLista[i].quant + c.cat1;
                int quantCat2 = cargaLista[i].cat2 + c.cat2;
                cargaLista
                    .removeWhere((element) => element.calibre == c.calibre);

                cargaLista.add(CargaLista(
                    fruta: paleteM!.fruta,
                    calibre: c.calibre,
                    embalagem: paleteM!.embalagem,
                    quant: quant,
                    cat2: quantCat2));
                somou = true;
                break;
              }
            }
          }
          if (somou == true) {
          } else {
            cargaLista.add(CargaLista(
                fruta: paleteM!.fruta,
                calibre: c.calibre,
                embalagem: paleteM!.embalagem,
                quant: c.cat1,
                cat2: c.cat2));
          }
        }).toList();
      }

      if (paleteCp != null) {
        List<CalibreCp> calibreCP = parseCalibreCp(paleteCp!);
        calibreCP.where((ele) => ele.quant > 0).map((c) {
          bool somou = false;
          for (var i = 0; i < cargaLista.length; i++) {
            if (cargaLista[i].calibre == c.calibre) {
              if (c.calibre == "Total") {
                if (cargaLista[i].fruta.nome == "Caqui" ||
                    cargaLista[i].fruta.nome == "Pêra") {
                  int quant = cargaLista[i].quant + c.quant;
                  cargaLista.removeWhere((element) =>
                      element.calibre == c.calibre &&
                      (element.fruta.nome == "Caqui" ||
                          element.fruta.nome == "Pêra"));

                  cargaLista.add(CargaLista(
                    fruta: paleteCp!.fruta,
                    calibre: c.calibre,
                    embalagem: paleteM!.embalagem,
                    quant: quant,
                  ));
                  somou = true;
                  break;
                }
              } else {
                int quant = cargaLista[i].quant + c.quant;
                cargaLista
                    .removeWhere((element) => element.calibre == c.calibre);

                cargaLista.add(CargaLista(
                  fruta: paleteCp!.fruta,
                  calibre: c.calibre,
                  embalagem: paleteM!.embalagem,
                  quant: quant,
                ));
                somou = true;
                break;
              }
            }
          }
          if (somou == true) {
          } else {
            cargaLista.add(CargaLista(
                fruta: paleteCp!.fruta,
                calibre: c.calibre,
                embalagem: paleteCp!.embalagem,
                quant: c.quant));
          }
        }).toList();
      }

      if (paleteO != null) {
        List<PaleteO> paletesO = await buscarPaleteO(client, e.id);
        paletesO.where((ele) => ele.quant > 0).map((c) {
          cargaLista.add(CargaLista(
              fruta: FrutaPalete(id: 0, nome: c.nome, variedade: ''),
              calibre: '',
              embalagem: EmbalagemPalete(nome: c.embalagem, id: 0),
              quant: c.quant));
        }).toList();
      }

      if (paletePa != null) {
        List<CalibreCp> calibrePa = parseCalibrePa(paletePa!);
        calibrePa.where((ele) => ele.quant > 0).map((c) {
          bool somou = false;
          for (var i = 0; i < cargaLista.length; i++) {
            if (cargaLista[i].calibre == c.calibre) {
              if (c.calibre == "Total") {
                if (cargaLista[i].fruta.nome == "Pêssego" ||
                    cargaLista[i].fruta.nome == "Ameixa") {
                  int quant = cargaLista[i].quant + c.quant;
                  cargaLista.removeWhere((element) =>
                      element.calibre == c.calibre &&
                      (element.fruta.nome == "Pêssego" ||
                          element.fruta.nome == "Ameixa"));

                  cargaLista.add(CargaLista(
                      fruta: paletePa!.fruta,
                      calibre: c.calibre,
                      embalagem: paletePa!.embalagem,
                      quant: quant));
                  somou = true;
                  break;
                }
              } else {
                int quant = cargaLista[i].quant + c.quant;
                cargaLista
                    .removeWhere((element) => element.calibre == c.calibre);

                cargaLista.add(CargaLista(
                    fruta: paletePa!.fruta,
                    calibre: c.calibre,
                    embalagem: paletePa!.embalagem,
                    quant: quant));
                somou = true;
                break;
              }
            }
          }
          if (somou == true) {
          } else {
            cargaLista.add(CargaLista(
                fruta: paletePa!.fruta,
                calibre: c.calibre,
                embalagem: paletePa!.embalagem,
                quant: c.quant));
          }
        }).toList();
      }
    }

    return cargaLista;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Carga: ${widget.carga.id}'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextBoldNormal(
                    bold: 'Carga: ',
                    normal: widget.carga.id.toString(),
                  )),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextBoldNormal(
                    bold: "Data: ",
                    normal: formatDate(
                      widget.carga.data,
                      [dd, '-', mm, '-', yyyy],
                    ),
                  )),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextBoldNormal(
                    bold: "Motorista: ",
                    normal: widget.carga.motorista,
                  )),
              const SizedBox(
                height: defaultPadding * 3,
              ),
              FutureBuilder<List<Palete>>(
                  future: buscarPaletesPelaCarga(client, widget.carga.id),
                  builder: ((context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasData) {
                      paletes = snapshot.data!;

                      return FutureBuilder<List<CargaLista>>(
                          future: fetchResults(paletes),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasData) {
                              cargaListaUse = snapshot.data!;
                              cargaListaUse.sort(CargaLista.customSort);
                              return SizedBox(
                                width: romaneioArea,
                                child: GroupedListView<CargaLista, String>(
                                  groupHeaderBuilder: (element) => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: defaultPadding),
                                      TextBoldNormal(
                                          bold: 'Fruta: ',
                                          normal:
                                              '${element.fruta.nome} ${element.fruta.variedade}'),
                                      const SizedBox(height: defaultPadding),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                              child: TitleMedium(
                                                  title: "Calibre",
                                                  context: context)),
                                          Expanded(
                                              child: TitleMedium(
                                                  title: "Cat1",
                                                  context: context)),
                                          Expanded(
                                              child: TitleMedium(
                                                  title: "Cat2",
                                                  context: context)),
                                        ],
                                      ),
                                      const SizedBox(height: defaultPadding),
                                    ],
                                  ),
                                  shrinkWrap: true,
                                  elements: cargaListaUse,
                                  groupBy: (element) =>
                                      '${element.fruta.nome} ${element.fruta.variedade}',
                                  itemBuilder: (context, element) => Card(
                                    elevation: 4,
                                    child: Table(
                                      defaultColumnWidth:
                                          const FlexColumnWidth(1.0),
                                      border: TableBorder.all(
                                          color: Colors.black, width: 1),
                                      children: [
                                        TableRow(
                                          children: [
                                            CampoTabelaCabecalho(
                                                value: element.calibre.isEmpty
                                                    ? element.fruta.nome
                                                    : element.calibre),
                                            CampoTabelaCabecalho(
                                                value:
                                                    element.quant.toString()),
                                            CampoTabelaCabecalho(
                                                value: element.cat2.toString()),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return const Center(
                                child:
                                    Text('Erro ao carregar os dados internos'),
                              );
                            }
                          });
                    } else {
                      return const Center(
                        child: Text('Erro ao carregar os dados'),
                      );
                    }
                  }))
            ],
          ),
        ),
      ),
    );
  }
}
