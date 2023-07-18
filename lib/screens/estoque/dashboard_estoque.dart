import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
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

  void atualizarPesquisa(String novaPesquisa) {
    setState(() {
      _pesquisa = novaPesquisa;
    });
  }

  Future<List<EstoqueLista>> buscarEstoqueSC(
      SupabaseClient client, String tabela) async {
    final estoqueJson = await client.from(tabela).select(
        'id, Fruta(Nome, Variedade), Embalagem(Nome), Quantidade, Produtor(Nome, Sobrenome)');

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
                          child: Text(
                            'Estoque Sc',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
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
                          child: Text(
                            'Estoque C',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ),
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
                            return DataTable(
                              columnSpacing: 16.0, // Espaçamento entre colunas
                              dataRowHeight: 60.0, // Altura das linhas de dados
                              headingRowHeight: 70.0,
                              // Altura da linha de cabeçalho
                              dividerThickness:
                                  1.0, // Espessura da borda entre células
                              horizontalMargin: 20.0,
                              // Margem horizontal interna
                              columns: const [
                                DataColumn(
                                  label: Text(
                                    'Fruta',
                                    style: TextStyle(color: textColor),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Produtor',
                                    style: TextStyle(color: textColor),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Embalagem',
                                    style: TextStyle(color: textColor),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Quantidade',
                                    style: TextStyle(color: textColor),
                                  ),
                                ),
                              ],
                              rows: estoqueSC.map((e) {
                                return DataRow(cells: [
                                  DataCell(Text(
                                      '${e.fruta.nome} ${e.fruta.variedade}',
                                      style: const TextStyle(fontSize: 16))),
                                  DataCell(Text(
                                      '${e.produtor.nome} ${e.produtor.sobrenome}',
                                      style: const TextStyle(fontSize: 16))),
                                  DataCell(Text(e.embalagem.nome,
                                      style: const TextStyle(fontSize: 16))),
                                  DataCell(Text(e.quantidade.toString(),
                                      style: const TextStyle(fontSize: 16))),
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
}
