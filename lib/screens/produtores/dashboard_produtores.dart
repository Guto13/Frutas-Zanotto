import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/datas/produtor.dart';
import 'package:maca_ipe/funcoes/banco_de_dados.dart';
import 'package:maca_ipe/funcoes/responsive.dart';
import 'package:maca_ipe/screens/produtores/cabecalho_produtores.dart';
import 'package:maca_ipe/screens/produtores/edit_produtores.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardProdutores extends StatefulWidget {
  const DashboardProdutores({Key? key, required this.keyProdutores})
      : super(key: key);

  final GlobalKey<ScaffoldState> keyProdutores;
  @override
  State<DashboardProdutores> createState() => _DashboardProdutoresState();
}

class _DashboardProdutoresState extends State<DashboardProdutores> {
  final client = Supabase.instance.client;
  List<Produtor> produtores = [];
  String _pesquisa = '';

  void atualizarPesquisa(String novaPesquisa) {
    setState(() {
      _pesquisa = novaPesquisa;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        children: [
          CabecalhoProdutores(
            onSearch: atualizarPesquisa,
            keyProdutores: widget.keyProdutores,
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
            child: SizedBox(
              width: Responsive.isMobile(context)
                  ? 600
                  : MediaQuery.of(context).size.width,
              child: FutureBuilder<List<Produtor>>(
                  future: buscarProdutores(client),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasData) {
                      produtores = snapshot.data!;

                      produtores = produtores
                          .where(
                            (ele) => ele.nomeCompleto
                                .toLowerCase()
                                .contains(_pesquisa.toLowerCase()),
                          )
                          .toList();

                      return DataTable(
                        columnSpacing: 16.0,
                        dataRowHeight: 60.0,
                        headingRowHeight: 70.0, // Altura da linha de cabeçalho
                        dividerThickness:
                            1.0, // Espessura da borda entre células
                        horizontalMargin: 20.0,
                        columns: [
                          columnTable('Nome'),
                          columnTable('Telefone'),
                          columnTable('Endereço'),
                        ],
                        rows: produtores.map((e) {
                          return DataRow(
                              onLongPress: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          EditProdutores(produtor: e)),
                                );
                              },
                              cells: [
                                columnData('${e.nome} ${e.sobrenome}'),
                                columnData(e.telefone),
                                columnData(e.endereco),
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
          ),
        ],
      ),
    ));
  }
}
