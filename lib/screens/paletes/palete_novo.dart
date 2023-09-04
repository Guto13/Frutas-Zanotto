// ignore_for_file: use_build_context_synchronously, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/app_bar.dart';
import 'package:maca_ipe/componetes_gerais/botao_padrao.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/datas/estoque_lista.dart';
import 'package:maca_ipe/funcoes/banco_de_dados.dart';
import 'package:maca_ipe/funcoes/responsive.dart';
import 'package:maca_ipe/screens/paletes/palete_novo_confirm.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PaleteNovo extends StatefulWidget {
  const PaleteNovo({Key? key}) : super(key: key);

  @override
  State<PaleteNovo> createState() => _PaleteNovoState();
}

class _PaleteNovoState extends State<PaleteNovo> {
  final client = Supabase.instance.client;
  List<EstoqueListaC> estoqueCLista = [];
  List<EstoqueListaC> estoqueSelecionado = [];
  Map<int, bool> selectedMap = {};
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Novo Palete'),
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: SingleChildScrollView(
          child:  Container(
                  padding: const EdgeInsets.all(defaultPadding),
                  decoration: const BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        width: Responsive.isDesktop(context)
                            ? 700
                            : double.infinity,
                        child: FutureBuilder<List<EstoqueListaC>>(
                            future: buscarEstoqueC(client),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasData) {
                                estoqueCLista = snapshot.data!;

                                return DataTable(
                                  columnSpacing: 16.0,
                                  dataRowHeight: 60.0,
                                  headingRowHeight:
                                      70.0, // Altura da linha de cabeçalho
                                  dividerThickness:
                                      1.0, // Espessura da borda entre células
                                  horizontalMargin: 20.0,
                                  columns: [
                                    columnTable(''),
                                    columnTable('Fruta'),
                                    columnTable('Quantidade'),
                                  ],
                                  rows: estoqueCLista.map((e) {
                                    bool isSelected =
                                        selectedMap.containsKey(e.id)
                                            ? selectedMap[e.id]!
                                            : false;
                                    return DataRow(cells: [
                                      DataCell(
                                        Checkbox(
                                          value: isSelected,
                                          onChanged: (value) {
                                            if (value!) {
                                              setState(() {
                                                estoqueSelecionado.add(e);
                                                selectedMap[e.id] = value;
                                              });
                                            } else {
                                              setState(() {
                                                estoqueSelecionado.removeWhere(
                                                    (element) =>
                                                        element.id == e.id);
                                                selectedMap[e.id] = value;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                      columnData(
                                          ("${e.fruta.nome} ${e.fruta.variedade} ") +
                                              (e.fruta.nome == "Maçã"
                                                  ? e.categoria
                                                  : "") +
                                              (e.calibre == '1'
                                                  ? ""
                                                  : ' - ${e.calibre}')),
                                      columnData(e.quantidade.toString()),
                                    ]);
                                  }).toList(),
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
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      Column(
                        children: [
                          ...estoqueSelecionado
                              .map((e) => Text(
                                  ("${e.fruta.nome} ${e.fruta.variedade} ") +
                                      (e.fruta.nome == "Maçã"
                                          ? e.categoria
                                          : "") +
                                      (e.calibre == '1'
                                          ? " -"
                                          : ' - ${e.calibre} -') +
                                      e.quantidade.toString()))
                              .toList(),
                        ],
                      ),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      estoqueSelecionado.isNotEmpty
                          ? BotaoPadrao(
                              context: context,
                              title: 'Selecionar',
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PaleteNovoConfirm(
                                          estoqueSelecionado:
                                              estoqueSelecionado,
                                        )),
                              ),
                            )
                          : const Center(),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
