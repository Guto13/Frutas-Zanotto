import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/componetes_gerais/left_menu.dart';
import 'package:maca_ipe/componetes_gerais/palete_info_card.dart';
import 'package:maca_ipe/componetes_gerais/title_medium.dart';
import 'package:maca_ipe/datas/palete.dart';
import 'package:maca_ipe/datas/palete_fruta.dart';
import 'package:maca_ipe/funcoes/banco_de_dados.dart';
import 'package:maca_ipe/funcoes/responsive.dart';
import 'package:maca_ipe/screens/paletes/palete_tabela.dart';
import 'package:maca_ipe/screens/paletes/paletes_cabecalho.dart';
import 'package:maca_ipe/screens/paletes/paletes_statics.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PaletesScreen extends StatefulWidget {
  const PaletesScreen({Key? key}) : super(key: key);

  @override
  State<PaletesScreen> createState() => _PaletesScreenState();
}

class _PaletesScreenState extends State<PaletesScreen> {
  final client = Supabase.instance.client;
  final GlobalKey<ScaffoldState> key = GlobalKey();
  bool _isCarga = false;
  List<Palete> paleteLista = [];

  void atualizarIsCarga(bool iscarga) {
    setState(() {
      _isCarga = iscarga;
      paleteLista.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: key,
      drawer: LeftMenu(client: client),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              Expanded(child: LeftMenu(client: client)),
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    PaletesCabecalho(
                        onCarga: atualizarIsCarga, keyPaletes: key),
                    const SizedBox(height: defaultPadding),
                    FutureBuilder<List<Palete>>(
                        future: buscarPaletesNCarregados(client, _isCarga),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
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
                                          padding: const EdgeInsets.all(
                                              defaultPadding),
                                          decoration: const BoxDecoration(
                                            color: bgColor,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: Column(
                                              children: [
                                                TitleMedium(
                                                    title: _isCarga
                                                        ? "Carregados"
                                                        : "P/Carregar",
                                                    context: context),
                                                const SizedBox(
                                                    height: defaultPadding),
                                                GridView.builder(
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        paleteLista.length,
                                                    gridDelegate:
                                                        SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount:
                                                          size.width < 650
                                                              ? 2
                                                              : 4,
                                                      crossAxisSpacing:
                                                          defaultPadding,
                                                      mainAxisSpacing:
                                                          defaultPadding,
                                                      childAspectRatio: 2,
                                                    ),
                                                    itemBuilder:
                                                        (context, index) {
                                                      final palete =
                                                          paleteLista[index];
                                                      return FutureBuilder<
                                                          List<
                                                              PaleteFrutaLista>>(
                                                        future:
                                                            buscarPaleteFruta(
                                                                client,
                                                                palete.id),
                                                        builder: (context,
                                                            snapshot) {
                                                          if (snapshot
                                                                  .connectionState ==
                                                              ConnectionState
                                                                  .waiting) {
                                                            return const Center(
                                                              child:
                                                                  CircularProgressIndicator(),
                                                            );
                                                          }
                                                          if (snapshot
                                                              .hasData) {
                                                            return InkWell(
                                                              onTap: () async {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            PaleteTabela(
                                                                      paleteFruta:
                                                                          snapshot
                                                                              .data!,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                              child:
                                                                  PaleteInfoCard(
                                                                palete: palete,
                                                                paleteFruta:
                                                                    snapshot
                                                                        .data!,
                                                              ),
                                                            );
                                                          } else {
                                                            return const Center(
                                                              child: Text(
                                                                  'Erro ao retornar dados'),
                                                            );
                                                          }
                                                        },
                                                      );
                                                    })
                                              ],
                                            ),
                                          ),
                                        )),
                                    const SizedBox(
                                      width: defaultPadding,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: FutureBuilder<Map<String, double>>(
                                          future: buscarPaletesPChart(client,
                                              carregado: _isCarga),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            } else if (snapshot.hasData) {
                                              return snapshot.data!.isNotEmpty
                                                  ? PaletesStatics(
                                                      paletes: snapshot.data!)
                                                  : const Center();
                                            } else {
                                              return const Center(
                                                child: Text(
                                                    'Erro ao trazer estatiticas'),
                                              );
                                            }
                                          }),
                                    )
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
