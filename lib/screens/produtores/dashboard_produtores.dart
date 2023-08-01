import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/datas/produtor.dart';
import 'package:maca_ipe/screens/produtores/cabecalho_produtores.dart';
import 'package:maca_ipe/screens/produtores/edit_produtores.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardProdutores extends StatefulWidget {
  const DashboardProdutores({Key? key}) : super(key: key);

  @override
  State<DashboardProdutores> createState() => _DashboardProdutoresState();
}

class _DashboardProdutoresState extends State<DashboardProdutores> {
  final client = Supabase.instance.client;
  List<Produtor> produtores = [];
  //String _pesquisa = '';

  Future<List<Produtor>> buscarProdutores(SupabaseClient client) async {
    final produtoresJson =
        await client.from('Produtor').select().order('Nome').order('Sobrenome');

    return parseProdutores(produtoresJson);
  }

  List<Produtor> parseProdutores(List<dynamic> responseBody) {
    List<Produtor> produtores =
        responseBody.map((e) => Produtor.fromJson(e)).toList();
    return produtores;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        children: [
          const CabecalhoProdutores(),
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
              width: double.infinity,
              child: FutureBuilder<List<Produtor>>(
                  future: buscarProdutores(client),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasData) {
                      produtores = snapshot.data!;

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
