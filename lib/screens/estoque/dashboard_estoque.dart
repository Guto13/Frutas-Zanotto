import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/botao_padrao.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/componetes_gerais/title_medium.dart';
import 'package:maca_ipe/datas/estoque_lista.dart';
import 'package:maca_ipe/funcoes/banco_de_dados.dart';
import 'package:maca_ipe/funcoes/responsive.dart';
import 'package:maca_ipe/screens/estoque/cabecalho_estoque.dart';
import 'package:maca_ipe/screens/estoque/estoque_statics.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardEstoque extends StatefulWidget {
  const DashboardEstoque({
    Key? key,
    required this.keyEstoque,
  }) : super(key: key);

  final GlobalKey<ScaffoldState> keyEstoque;

  @override
  State<DashboardEstoque> createState() => _DashboardEstoqueState();
}

class _DashboardEstoqueState extends State<DashboardEstoque> {
  final client = Supabase.instance.client;
  List<EstoqueListaC> estoque = [];
  String tabela = 'EstoqueSC';
  String _pesquisa = '';
  bool _isChecked = false;

  void atualizarPesquisa(String novaPesquisa) {
    setState(() {
      _pesquisa = novaPesquisa;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            CabecalhoEstoque(
              onSearch: atualizarPesquisa,
              keyEstoque: widget.keyEstoque,
              title: tabela == 'EstoqueSC'
                  ? 'Estoque a Classificar'
                  : 'Estoque Classificado',
            ),
            const SizedBox(height: defaultPadding),
            Container(
              padding: const EdgeInsets.all(defaultPadding),
              decoration: const BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!Responsive.isMobile(context))
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                            child: TitleMedium(
                                title: 'Mostrar estoque negativo',
                                context: context)),
                        Expanded(
                          child: Checkbox(
                            value: _isChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                _isChecked = value!;
                              });
                            },
                          ),
                        ),
                        const Spacer(
                          flex: 1,
                        ),
                        BotaoPadrao(
                            context: context,
                            title: "Mudar Estoque",
                            onPressed: () {
                              setState(() {
                                if (tabela == 'EstoqueSC') {
                                  tabela = 'EstoqueC';
                                } else {
                                  tabela = 'EstoqueSC';
                                }
                              });
                            })
                      ],
                    ),
                  if (Responsive.isMobile(context))
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                            child: TitleMedium(
                                title: 'Mostrar estoque negativo',
                                context: context)),
                        Expanded(
                          child: Checkbox(
                            value: _isChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                _isChecked = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  if (Responsive.isMobile(context))
                    const SizedBox(
                      height: defaultPadding,
                    ),
                  if (Responsive.isMobile(context))
                    BotaoPadrao(
                        context: context,
                        title: "Mudar Estoque",
                        onPressed: () {
                          setState(() {
                            if (tabela == 'EstoqueSC') {
                              tabela = 'EstoqueC';
                            } else {
                              tabela = 'EstoqueSC';
                            }
                          });
                        })
                ],
              ),
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            tabela == 'EstoqueC'
                ? SizedBox(
                    width: double.infinity,
                    child: FutureBuilder<List<EstoqueListaC>>(
                        future: buscarEstoqueC(client),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasData) {
                            estoque = snapshot.data!;
                            //Organiza os dados baseado na pesquisa
                            estoque = estoque
                                .where(
                                  (est) =>
                                      est.fruta.nome
                                          .toLowerCase()
                                          .contains(_pesquisa.toLowerCase()) ||
                                      est.fruta.variedade
                                          .toLowerCase()
                                          .contains(_pesquisa.toLowerCase()),
                                )
                                .toList();
                            if (_isChecked == false) {
                              estoque = estoque
                                  .where((element) => element.quantidade > 0)
                                  .toList();
                            }
                            return !Responsive.isMobile(context)
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 4,
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: bgColor,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                          child: DataTable(
                                            columnSpacing: 16.0,
                                            dataRowHeight: 60.0,
                                            headingRowHeight:
                                                70.0, // Altura da linha de cabeçalho
                                            dividerThickness:
                                                1.0, // Espessura da borda entre células
                                            horizontalMargin: 20.0,
                                            columns: [
                                              columnTable('Fruta'),
                                              columnTable('Quantidade'),
                                            ],
                                            rows: estoque.map((e) {
                                              return DataRow(cells: [
                                                columnData(
                                                    '${e.fruta.nome} ${e.fruta.variedade}'),
                                                columnData(
                                                    e.quantidade.toString()),
                                              ]);
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: defaultPadding,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: bgColor,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                          child:
                                              EstoqueStatics(estoque: estoque),
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      Container(
                                        decoration: const BoxDecoration(
                                          color: bgColor,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        child: DataTable(
                                          columnSpacing: 16.0,
                                          dataRowHeight: 60.0,
                                          headingRowHeight:
                                              70.0, // Altura da linha de cabeçalho
                                          dividerThickness:
                                              1.0, // Espessura da borda entre células
                                          horizontalMargin: 20.0,
                                          columns: [
                                            columnTable('Fruta'),
                                            columnTable('Quantidade'),
                                          ],
                                          rows: estoque.map((e) {
                                            return DataRow(cells: [
                                              columnData(
                                                  '${e.fruta.nome} ${e.fruta.variedade}'),
                                              columnData(
                                                  e.quantidade.toString()),
                                            ]);
                                          }).toList(),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: defaultPadding,
                                      ),
                                      Container(
                                        decoration: const BoxDecoration(
                                          color: bgColor,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        child: EstoqueStatics(estoque: estoque),
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
                  )
                : SizedBox(
                    width: double.infinity,
                    child: FutureBuilder<List<EstoqueLista>>(
                        future: buscarEstoque(client, tabela),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasData) {
                            List<EstoqueLista> estoqueLista = snapshot.data!;
                            //Organiza os dados baseado na pesquisa
                            estoqueLista = estoqueLista
                                .where(
                                  (est) =>
                                      est.fruta.nome
                                          .toLowerCase()
                                          .contains(_pesquisa.toLowerCase()) ||
                                      est.fruta.variedade
                                          .toLowerCase()
                                          .contains(_pesquisa.toLowerCase()),
                                )
                                .toList();
                            if (_isChecked == false) {
                              estoqueLista = estoqueLista
                                  .where((element) => element.quantidade > 0)
                                  .toList();
                            }
                            return !Responsive.isMobile(context)
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 4,
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: bgColor,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                          child: DataTable(
                                            columnSpacing: 16.0,
                                            dataRowHeight: 60.0,
                                            headingRowHeight:
                                                70.0, // Altura da linha de cabeçalho
                                            dividerThickness:
                                                1.0, // Espessura da borda entre células
                                            horizontalMargin: 20.0,
                                            columns: [
                                              columnTable('Fruta'),
                                              columnTable('Quantidade'),
                                              columnTable('Produtor'),
                                            ],
                                            rows: estoqueLista.map((e) {
                                              return DataRow(cells: [
                                                columnData(
                                                    '${e.fruta.nome} ${e.fruta.variedade}'),
                                                columnData(
                                                    e.quantidade.toString()),
                                                columnData(
                                                    '${e.produtor.nome} ${e.produtor.sobrenome}'),
                                              ]);
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: defaultPadding,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: bgColor,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                          child:
                                              EstoqueStatics(estoque: estoque),
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      Container(
                                        decoration: const BoxDecoration(
                                          color: bgColor,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        child: DataTable(
                                          columnSpacing: 16.0,
                                          dataRowHeight: 60.0,
                                          headingRowHeight:
                                              70.0, // Altura da linha de cabeçalho
                                          dividerThickness:
                                              1.0, // Espessura da borda entre células
                                          horizontalMargin: 20.0,
                                          columns: [
                                            columnTable('Fruta'),
                                            columnTable('Quantidade'),
                                            columnTable('Produtor'),
                                          ],
                                          rows: estoqueLista.map((e) {
                                            return DataRow(cells: [
                                              columnData(
                                                  '${e.fruta.nome} ${e.fruta.variedade}'),
                                              columnData(
                                                  e.quantidade.toString()),
                                              columnData(
                                                  '${e.produtor.nome} ${e.produtor.sobrenome}'),
                                            ]);
                                          }).toList(),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: defaultPadding,
                                      ),
                                      Container(
                                        decoration: const BoxDecoration(
                                          color: bgColor,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        child: EstoqueStatics(estoque: estoque),
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
          ],
        ),
      ),
    );
  }
}
