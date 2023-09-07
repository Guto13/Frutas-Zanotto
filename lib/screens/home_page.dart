import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/componetes_gerais/left_menu.dart';
import 'package:maca_ipe/componetes_gerais/title_medium.dart';
import 'package:maca_ipe/datas/estoque_lista.dart';
import 'package:maca_ipe/funcoes/banco_de_dados.dart';
import 'package:maca_ipe/funcoes/responsive.dart';
import 'package:maca_ipe/screens/estoque/estoque_statics.dart';
import 'package:maca_ipe/screens/estoque/estoque_statics_SC.dart';
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
                          child: !Responsive.isMobile(context)
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.all(
                                            defaultPadding),
                                        child: Container(
                                          padding: const EdgeInsets.all(
                                              defaultPadding),
                                          decoration: const BoxDecoration(
                                            color: bgColor,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                          child: FutureBuilder<
                                                  Map<String, double>>(
                                              future:
                                                  buscarPaletesPChart(client),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                } else if (snapshot.hasData) {
                                                  return snapshot
                                                          .data!.isNotEmpty
                                                      ? PaletesStatics(
                                                          paletes:
                                                              snapshot.data!)
                                                      : const Center();
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
                                        padding: const EdgeInsets.all(
                                            defaultPadding),
                                        child: Container(
                                          padding: const EdgeInsets.all(
                                              defaultPadding),
                                          decoration: const BoxDecoration(
                                            color: bgColor,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                          child: FutureBuilder<
                                                  List<EstoqueListaC>>(
                                              future: buscarEstoqueC(client),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                } else if (snapshot.hasData) {
                                                  List<EstoqueListaC> estoque =
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
                                        padding: const EdgeInsets.all(
                                            defaultPadding),
                                        child: Container(
                                          padding: const EdgeInsets.all(
                                              defaultPadding),
                                          decoration: const BoxDecoration(
                                            color: bgColor,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                          child: FutureBuilder<
                                                  List<EstoqueLista>>(
                                              future: buscarEstoque(
                                                  client, "EstoqueSC"),
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
                                                      EstoqueStaticsSC(
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
                                )
                              : Column(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.all(defaultPadding),
                                      child: Container(
                                        padding: const EdgeInsets.all(
                                            defaultPadding),
                                        decoration: const BoxDecoration(
                                          color: bgColor,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        child: FutureBuilder<
                                                Map<String, double>>(
                                            future: buscarPaletesPChart(client),
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
                                      ),
                                    ),
                                    const SizedBox(
                                      height: defaultPadding,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.all(defaultPadding),
                                      child: Container(
                                        padding: const EdgeInsets.all(
                                            defaultPadding),
                                        decoration: const BoxDecoration(
                                          color: bgColor,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        child: FutureBuilder<
                                                List<EstoqueListaC>>(
                                            future: buscarEstoqueC(client),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              } else if (snapshot.hasData) {
                                                List<EstoqueListaC> estoque =
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
                                    const SizedBox(
                                      height: defaultPadding,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.all(defaultPadding),
                                      child: Container(
                                        padding: const EdgeInsets.all(
                                            defaultPadding),
                                        decoration: const BoxDecoration(
                                          color: bgColor,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        child: FutureBuilder<
                                                List<EstoqueLista>>(
                                            future: buscarEstoque(
                                                client, "EstoqueSC"),
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
                                                    EstoqueStaticsSC(
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
}
