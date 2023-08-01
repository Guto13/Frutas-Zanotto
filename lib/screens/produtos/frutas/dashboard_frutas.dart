import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/datas/fruta.dart';
import 'package:maca_ipe/screens/produtos/frutas/cabecalho_frutas.dart';
import 'package:maca_ipe/screens/produtos/frutas/edit_frutas.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashBoardFrutas extends StatefulWidget {
  const DashBoardFrutas({
    Key? key,
  }) : super(key: key);

  @override
  State<DashBoardFrutas> createState() => _DashBoardFrutasState();
}

class _DashBoardFrutasState extends State<DashBoardFrutas> {
  final client = Supabase.instance.client;
  List<Fruta> frutas = [];
  //String _pesquisa = '';

  Future<List<Fruta>> buscarFrutas(SupabaseClient client) async {
    final frutasJson = await client
        .from('Fruta')
        .select()
        .order('Nome', ascending: true)
        .order('Variedade', ascending: true);

    return parseFrutas(frutasJson);
  }

  List<Fruta> parseFrutas(List<dynamic> responseBody) {
    List<Fruta> frutas = responseBody.map((e) => Fruta.fromJson(e)).toList();
    return frutas;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const CabecalhoFrutas(),
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
                child: FutureBuilder<List<Fruta>>(
                    future: buscarFrutas(client),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasData) {
                        frutas = snapshot.data!;

                        return DataTable(
                          columnSpacing: 16.0,
                          dataRowHeight: 60.0,
                          headingRowHeight:
                              70.0, // Altura da linha de cabeçalho
                          dividerThickness:
                              1.0, // Espessura da borda entre células
                          horizontalMargin: 20.0,
                          columns: [
                            columnTable('Nome'),
                            columnTable('Variedade'),
                          ],
                          rows: frutas.map((e) {
                            return DataRow(
                                onLongPress: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EditFrutas(fruta: e)),
                                  );
                                },
                                cells: [
                                  columnData(e.nome),
                                  columnData(e.variedade),
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
