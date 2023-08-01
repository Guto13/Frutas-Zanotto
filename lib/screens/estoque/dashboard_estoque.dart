import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/componetes_gerais/title_medium.dart';
import 'package:maca_ipe/datas/estoque_lista.dart';
import 'package:maca_ipe/screens/estoque/cabecalho_estoque.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardEstoque extends StatefulWidget {
  const DashboardEstoque({
    Key? key,
  }) : super(key: key);

  @override
  State<DashboardEstoque> createState() => _DashboardEstoqueState();
}

class _DashboardEstoqueState extends State<DashboardEstoque> {
  final client = Supabase.instance.client;
  List<EstoqueLista> estoqueSC = [];
  bool _isSCorC = true;
  String tabela = 'EstoqueSC';
  String _pesquisa = '';
  bool _isChecked = false;

  void atualizarPesquisa(String novaPesquisa) {
    setState(() {
      _pesquisa = novaPesquisa;
    });
  }

  Future<List<EstoqueLista>> buscarEstoqueSC(
      SupabaseClient client, String tabela) async {
    final estoqueJson = await client
        .from(tabela)
        .select(
            'id, Fruta:FrutaId(id, Nome, Variedade), Embalagem(id, Nome), Quantidade, Produtor(id, Nome, Sobrenome)')
        .order('Quantidade');

    return parseEstoqueSC(estoqueJson);
  }

  List<EstoqueLista> parseEstoqueSC(List<dynamic> responseBody) {
    List<EstoqueLista> estoque =
        responseBody.map((e) => EstoqueLista.fromJson(e)).toList();
    return estoque;
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
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _isSCorC = true;
                                  tabela = 'EstoqueSC';
                                });
                              },
                              child: Container(
                                decoration: _isSCorC
                                    ? const BoxDecoration(color: Colors.blue)
                                    : const BoxDecoration(),
                                child: TitleMedium(
                                    context: context, title: "Estoque Sc"),
                              ),
                            ),
                            const SizedBox(
                              width: defaultPadding * 2,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _isSCorC = false;
                                  tabela = 'EstoqueC';
                                });
                              },
                              child: Container(
                                decoration: _isSCorC
                                    ? const BoxDecoration()
                                    : const BoxDecoration(color: Colors.blue),
                                child: TitleMedium(
                                    context: context, title: "Estoque C"),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Expanded(
                          child: Row(
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
                      ))
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: FutureBuilder<List<EstoqueLista>>(
                        future: buscarEstoqueSC(client, tabela),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasData) {
                            estoqueSC = snapshot.data!;
                            //Organiza os dados baseado na pesquisa
                            estoqueSC = estoqueSC
                                .where(
                                  (est) =>
                                      est.fruta.nome
                                          .toLowerCase()
                                          .contains(_pesquisa.toLowerCase()) ||
                                      est.produtor.nome
                                          .toLowerCase()
                                          .contains(_pesquisa.toLowerCase()) ||
                                      est.produtor.sobrenome
                                          .toLowerCase()
                                          .contains(_pesquisa.toLowerCase()) ||
                                      est.embalagem.nome
                                          .toLowerCase()
                                          .contains(_pesquisa.toLowerCase()) ||
                                      est.fruta.variedade
                                          .toLowerCase()
                                          .contains(_pesquisa.toLowerCase()),
                                )
                                .toList();
                            if (_isChecked == false) {
                              estoqueSC = estoqueSC
                                  .where((element) => element.quantidade > 0)
                                  .toList();
                            }
                            return DataTable(
                              columnSpacing: 16.0,
                              dataRowHeight: 60.0,
                              headingRowHeight:
                                  70.0, // Altura da linha de cabeçalho
                              dividerThickness:
                                  1.0, // Espessura da borda entre células
                              horizontalMargin: 20.0,
                              columns: [
                                columnTable('Fruta'),
                                columnTable('Produtor'),
                                columnTable('Embalagem'),
                                columnTable('Quantidade'),
                              ],
                              rows: estoqueSC.map((e) {
                                return DataRow(cells: [
                                  columnData(
                                      '${e.fruta.nome} ${e.fruta.variedade}'),
                                  columnData(
                                      '${e.produtor.nome} ${e.produtor.sobrenome}'),
                                  columnData(e.embalagem.nome),
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
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataCell columnData(String data) {
    return DataCell(Text(data, style: const TextStyle(fontSize: 16)));
  }

  DataColumn columnTable(String title) {
    return DataColumn(
      label: Text(
        title,
        style: const TextStyle(color: textColor),
      ),
    );
  }
}
