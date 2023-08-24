import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/componetes_gerais/left_menu.dart';
import 'package:maca_ipe/componetes_gerais/title_medium.dart';
import 'package:maca_ipe/datas/estoque_lista.dart';
import 'package:maca_ipe/datas/palete.dart';
import 'package:maca_ipe/datas/palete_cp_lista.dart';
import 'package:maca_ipe/datas/palete_m_lista.dart';
import 'package:maca_ipe/datas/palete_o.dart';
import 'package:maca_ipe/datas/palete_pa_lista.dart';
import 'package:maca_ipe/datas/romaneio_cp.dart';
import 'package:maca_ipe/datas/romaneio_m.dart';
import 'package:maca_ipe/datas/statics.dart';
import 'package:maca_ipe/funcoes/banco_de_dados.dart';
import 'package:maca_ipe/funcoes/responsive.dart';
import 'package:maca_ipe/screens/estoque/estoque_statics.dart';
import 'package:maca_ipe/screens/paletes/paletes_statics.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final client = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> key = GlobalKey();
    return Scaffold(
      key: key,
      drawer: LeftMenu(client: client),
      body: SafeArea(
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          if (Responsive.isDesktop(context))
            Expanded(
              child: LeftMenu(
                client: client,
              ),
            ),
          Expanded(
              flex: 5,
              child: Drawer(
                backgroundColor: bgColor2,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(defaultPadding),
                        child: Row(
                          children: [
                            if (!Responsive.isDesktop(context))
                              IconButton(
                                  icon: const Icon(Icons.menu),
                                  onPressed: () {
                                    key.currentState!.openDrawer();
                                  }),
                            TitleMedium(title: 'Home', context: context),
                            Spacer(
                              flex: Responsive.isDesktop(context) ? 2 : 1,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(defaultPadding),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(defaultPadding),
                                  child: Container(
                                    padding:
                                        const EdgeInsets.all(defaultPadding),
                                    decoration: const BoxDecoration(
                                      color: bgColor,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: FutureBuilder<List<Palete>>(
                                        future: buscarPaletesNCarregados(
                                            client, false),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          } else if (snapshot.hasData) {
                                            return FutureBuilder<
                                                    StaticsPaletes>(
                                                future: returnStatics(
                                                    snapshot.data!),
                                                builder: (context, snapshot2) {
                                                  if (snapshot2
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    );
                                                  } else if (snapshot2
                                                      .hasData) {
                                                    return PaletesStatics(
                                                        statics:
                                                            snapshot2.data!);
                                                  } else {
                                                    return const Center(
                                                      child: Text(
                                                          'Erro ao trazer estatiticas'),
                                                    );
                                                  }
                                                });
                                          } else {
                                            return const Center(
                                              child: Text(
                                                  'Erro ao trazer estatiticas'),
                                            );
                                          }
                                        }),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(defaultPadding),
                                  child: Container(
                                    padding:
                                        const EdgeInsets.all(defaultPadding),
                                    decoration: const BoxDecoration(
                                      color: bgColor,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: FutureBuilder<List<EstoqueLista>>(
                                        future:
                                            buscarEstoque(client, 'EstoqueC'),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          } else if (snapshot.hasData) {
                                            List<EstoqueLista> estoque =
                                                snapshot.data!;

                                            return Column(
                                              children: [
                                                const Text(
                                                    'Estoque Classificado'),
                                                const SizedBox(
                                                  height: defaultPadding,
                                                ),
                                                EstoqueStatics(
                                                  estoque: estoque,
                                                ),
                                              ],
                                            );
                                          } else {
                                            return const Center(
                                              child: Text(
                                                'Erro ao carregar os dados',
                                                style: TextStyle(
                                                  color: textColor,
                                                ),
                                              ),
                                            );
                                          }
                                        }),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(defaultPadding),
                                  child: Container(
                                    padding:
                                        const EdgeInsets.all(defaultPadding),
                                    decoration: const BoxDecoration(
                                      color: bgColor,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: FutureBuilder<List<EstoqueLista>>(
                                        future:
                                            buscarEstoque(client, "EstoqueSC"),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          } else if (snapshot.hasData) {
                                            List<EstoqueLista> estoque =
                                                snapshot.data!;

                                            return Column(
                                              children: [
                                                const Text(
                                                    'Estoque a Classificar'),
                                                const SizedBox(
                                                  height: defaultPadding,
                                                ),
                                                EstoqueStatics(
                                                  estoque: estoque,
                                                ),
                                              ],
                                            );
                                          } else {
                                            return const Center(
                                              child: Text(
                                                'Erro ao carregar os dados',
                                                style: TextStyle(
                                                  color: textColor,
                                                ),
                                              ),
                                            );
                                          }
                                        }),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              ))
        ]),
      ),
    );
  }

  //Retorna estatisticas.
  Future<StaticsPaletes> returnStatics(List<Palete> paletes) async {
    StaticsPaletes statics = StaticsPaletes();
    PaleteMLista? paleteM;
    PaleteCpLista? paleteCp;
    PaleteO? paleteO;
    PaletePALista? paletePa;
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
        List<CalibreM> calibreM = parseCalibreM(paleteM);
        calibreM.where((ele) => ele.cat1 > 0 || ele.cat2 > 0).map((c) {
          if (c.calibre == "Total") {
            statics.maca += (c.cat1 + c.cat2) / 49;
          }
        }).toList();
      }

      if (paleteCp != null) {
        List<CalibreCp> calibreCP = parseCalibreCp(paleteCp);
        calibreCP.where((ele) => ele.quant > 0).map((c) {
          if (c.calibre == "Total") {
            if (paleteCp!.fruta.nome == 'Caqui') {
              statics.caqui += c.quant / 60;
            } else {
              statics.pera += c.quant / 60;
            }
          }
        }).toList();
      }

      if (paleteO != null) {
        List<PaleteO> paletesO = await buscarPaleteO(client, e.id);
        paletesO.where((ele) => ele.quant > 0).map((c) {
          statics.outro += 1;
        }).toList();
      }

      if (paletePa != null) {
        List<CalibreCp> calibrePa = parseCalibrePa(paletePa);
        calibrePa.where((ele) => ele.quant > 0).map((c) {
          if (c.calibre == "Total") {
            if (paletePa!.fruta.nome == 'Ameixa') {
              statics.ameixa += c.quant / 104;
            } else {
              statics.pessego += c.quant / 104;
            }
          }
        }).toList();
      }
    }

    return statics;
  }
}
