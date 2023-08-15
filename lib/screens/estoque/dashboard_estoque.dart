import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/componetes_gerais/title_medium.dart';
import 'package:maca_ipe/datas/estoque_lista.dart';
import 'package:maca_ipe/screens/estoque/cabecalho_estoque.dart';
import 'package:maca_ipe/screens/estoque/estoque_statics.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardEstoque extends StatefulWidget {
  const DashboardEstoque({
    Key? key, required this.keyEstoque,
  }) : super(key: key);

  final GlobalKey<ScaffoldState> keyEstoque;

  @override
  State<DashboardEstoque> createState() => _DashboardEstoqueState();
}

class _DashboardEstoqueState extends State<DashboardEstoque> {
  final client = Supabase.instance.client;
  List<EstoqueLista> estoqueSC = [];
  String tabela = 'EstoqueSC';
  String _pesquisa = '';
  bool _isChecked = false;

  void atualizarPesquisa(String novaPesquisa) {
    setState(() {
      _pesquisa = novaPesquisa;
    });
  }

  Future<List<EstoqueLista>> buscarEstoqueSC(SupabaseClient client) async {
    final estoqueJson = await client
        .from("EstoqueSC")
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
              keyEstoque: widget.keyEstoque,
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
                        flex: 2,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            SizedBox(
              width: double.infinity,
              child: FutureBuilder<List<EstoqueLista>>(
                  future: buscarEstoqueSC(client),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
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
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                              child: EstoqueStatics(estoque: estoqueSC),
                            ),
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
          ],
        ),
      ),
    );
  }
}
