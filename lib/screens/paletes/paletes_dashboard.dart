import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/componetes_gerais/title_medium.dart';
import 'package:maca_ipe/datas/palete.dart';
import 'package:maca_ipe/datas/palete_cp_lista.dart';
import 'package:maca_ipe/datas/palete_info.dart';
import 'package:maca_ipe/datas/palete_m_lista.dart';
import 'package:maca_ipe/datas/palete_o.dart';
import 'package:maca_ipe/datas/palete_pa_lista.dart';
import 'package:maca_ipe/datas/romaneio_cp.dart';
import 'package:maca_ipe/datas/romaneio_m.dart';
import 'package:maca_ipe/datas/statics.dart';
import 'package:maca_ipe/funcoes/banco_de_dados.dart';
import 'package:maca_ipe/funcoes/responsive.dart';
import 'package:maca_ipe/screens/paletes/file_info_card_palete.dart';
import 'package:maca_ipe/screens/paletes/paletes_cabecalho.dart';
import 'package:maca_ipe/screens/paletes/paletes_statics.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PaletesDashboard extends StatefulWidget {
  const PaletesDashboard({Key? key, required this.keyPaletes})
      : super(key: key);

  final GlobalKey<ScaffoldState> keyPaletes;

  @override
  State<PaletesDashboard> createState() => _PaletesDashboardState();
}

class _PaletesDashboardState extends State<PaletesDashboard> {
  final client = Supabase.instance.client;
  List<Palete> paleteLista = [];
  List<PaleteInfo> paleteInfo = [];
  bool _isCarga = false;
  PaleteMLista? paleteM;
  PaleteCpLista? paleteCp;
  PaleteO? paleteO;
  PaletePALista? paletePa;
  String _pesquisa = '';

  void atualizarPesquisa(String novaPesquisa) {
    setState(() {
      _pesquisa = novaPesquisa;
      paleteLista.clear();
      paleteInfo.clear();
    });
  }

  void atualizarIsCarga(bool iscarga) {
    setState(() {
      _isCarga = iscarga;
      paleteLista.clear();
      paleteInfo.clear();
    });
  }

  Future<List<PaleteInfo>> fetchResults(List<Palete> paletes) async {
    List<PaleteInfo> paletesInfo = [];
    paletesInfo.clear();
    for (var e in paletes) {
      List<PaleteInfo> aux = [];

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
      paleteM = null;
      paleteCp = null;
      paleteO = null;
      paletePa = null;
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
          if (c.calibre == "Total") {
          } else {
            aux.add(PaleteInfo(
                palete: e.id.toString(),
                fruta: '${paleteM!.fruta.nome} ${paleteM!.fruta.variedade}',
                calibre: c.cat1 > 0 ? '${c.calibre} Cat1' : '${c.calibre} Cat2',
                quant: c.cat1 > 0 ? c.cat1 : c.cat2));
          }
        }).toList();
      }

      if (paleteCp != null) {
        List<CalibreCp> calibreCP = parseCalibreCp(paleteCp!);
        calibreCP.where((ele) => ele.quant > 0).map((c) {
          if (c.calibre == "Total") {
          } else {
            aux.add(PaleteInfo(
                palete: e.id.toString(),
                fruta: '${paleteCp!.fruta.nome} ${paleteCp!.fruta.variedade}',
                calibre: c.calibre,
                quant: c.quant));
          }
        }).toList();
      }

      if (paleteO != null) {
        List<PaleteO> paletesO = await buscarPaleteO(client, e.id);
        paletesO.where((ele) => ele.quant > 0).map((c) {
          aux.add(PaleteInfo(
              palete: e.id.toString(),
              fruta: paleteO!.nome,
              calibre: c.embalagem,
              quant: c.quant));
        }).toList();
      }

      if (paletePa != null) {
        List<CalibreCp> calibrePa = parseCalibrePa(paletePa!);
        calibrePa.where((ele) => ele.quant > 0).map((c) {
          if (c.calibre == "Total") {
          } else {
            aux.add(PaleteInfo(
                palete: e.id.toString(),
                fruta: '${paletePa!.fruta.nome} ${paletePa!.fruta.variedade}',
                calibre: c.calibre,
                quant: c.quant));
          }
        }).toList();
      }

      PaleteInfo maiorValor = aux[0];

      for (var numero in aux) {
        if (numero.quant > maiorValor.quant) {
          maiorValor =
              numero; // Atualiza o maior valor se encontrar um número maior
        }
      }

      paletesInfo.add(maiorValor);
    }

    return paletesInfo;
  }

  //Retorna estatisticas.
  Future<StaticsPaletes> returnStatics(
      List<Palete> paletes, String pesquisa) async {
    StaticsPaletes statics = StaticsPaletes();
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
      paleteM = null;
      paleteCp = null;
      paleteO = null;
      paletePa = null;
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
        if (paleteM!.fruta.nome
                .toLowerCase()
                .contains(_pesquisa.toLowerCase()) ||
            paleteM!.fruta.variedade
                .toLowerCase()
                .contains(_pesquisa.toLowerCase())) {
          List<CalibreM> calibreM = parseCalibreM(paleteM!);
          calibreM.where((ele) => ele.cat1 > 0 || ele.cat2 > 0).map((c) {
            if (c.calibre == "Total") {
              statics.maca += (c.cat1 + c.cat2) / 49;
            }
          }).toList();
        }
      }

      if (paleteCp != null) {
        if (paleteCp!.fruta.nome
                .toLowerCase()
                .contains(_pesquisa.toLowerCase()) ||
            paleteCp!.fruta.variedade
                .toLowerCase()
                .contains(_pesquisa.toLowerCase())) {
          List<CalibreCp> calibreCP = parseCalibreCp(paleteCp!);
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
      }

      if (paleteO != null) {
        if (paleteO!.nome.toLowerCase().contains(_pesquisa.toLowerCase())) {
          List<PaleteO> paletesO = await buscarPaleteO(client, e.id);
          paletesO.where((ele) => ele.quant > 0).map((c) {
            statics.outro += 1;
          }).toList();
        }
      }

      if (paletePa != null) {
        if (paletePa!.fruta.nome
                .toLowerCase()
                .contains(_pesquisa.toLowerCase()) ||
            paletePa!.fruta.variedade
                .toLowerCase()
                .contains(_pesquisa.toLowerCase())) {
          List<CalibreCp> calibrePa = parseCalibrePa(paletePa!);
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
    }

    return statics;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        children: [
          PaletesCabecalho(
            onCarga: atualizarIsCarga,
            onSearch: atualizarPesquisa,
            keyPaletes: widget.keyPaletes,
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          FutureBuilder<List<Palete>>(
              future: buscarPaletesNCarregados(client, _isCarga),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData) {
                  paleteLista = snapshot.data!;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                              flex: 4,
                              child: Container(
                                padding: const EdgeInsets.all(defaultPadding),
                                decoration: const BoxDecoration(
                                  color: bgColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: FutureBuilder<List<PaleteInfo>>(
                                      future: fetchResults(paleteLista),
                                      builder: ((context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        } else if (snapshot.hasData) {
                                          paleteInfo = snapshot.data!;

                                          paleteInfo = paleteInfo
                                              .where(
                                                (ele) => ele.fruta
                                                    .toLowerCase()
                                                    .contains(_pesquisa
                                                        .toLowerCase()),
                                              )
                                              .toList();

                                          return Column(
                                            children: [
                                              TitleMedium(
                                                  title: _isCarga
                                                      ? "Carregados"
                                                      : "P/Carregar",
                                                  context: context),
                                              const SizedBox(
                                                  height: defaultPadding),
                                              Responsive(
                                                mobile: FileInfoCardGridView(
                                                  crossAxisCount:
                                                      size.width < 650 ? 2 : 4,
                                                  childAspectRatio:
                                                      size.width < 650
                                                          ? 1.3
                                                          : 1,
                                                  paletes: paleteInfo,
                                                  client: client,
                                                ),
                                                tablet: FileInfoCardGridView(
                                                  paletes: paleteInfo,
                                                  client: client,
                                                ),
                                                desktop: FileInfoCardGridView(
                                                  childAspectRatio:
                                                      size.width < 1400
                                                          ? 1.1
                                                          : 1.4,
                                                  paletes: paleteInfo,
                                                  client: client,
                                                ),
                                              ),
                                            ],
                                          );
                                        } else {
                                          return const Center(
                                            child: Text(
                                                'Erro ao trazer dados dos paletes'),
                                          );
                                        }
                                      })),
                                ),
                              )),
                          const SizedBox(
                            width: defaultPadding,
                          ),
                          Expanded(
                              flex: 1,
                              child: FutureBuilder<StaticsPaletes>(
                                  future: returnStatics(paleteLista, _pesquisa),
                                  builder: (context, snapshot2) {
                                    if (snapshot2.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else if (snapshot2.hasData) {
                                      return PaletesStatics(
                                          statics: snapshot2.data!);
                                    } else {
                                      return const Center(
                                        child:
                                            Text('Erro ao trazer estatiticas'),
                                      );
                                    }
                                  }))
                        ],
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
        ],
      ),
    );
  }
}
