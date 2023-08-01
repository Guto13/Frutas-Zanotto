import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/datas/embalagem.dart';
import 'package:maca_ipe/screens/produtos/embalagens/cabecalho_embalagem.dart';
import 'package:maca_ipe/screens/produtos/embalagens/edit_embalagens.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashBoardEmbalagens extends StatefulWidget {
  const DashBoardEmbalagens({
    Key? key,
  }) : super(key: key);

  @override
  State<DashBoardEmbalagens> createState() => _DashBoardEmbalagensState();
}

class _DashBoardEmbalagensState extends State<DashBoardEmbalagens> {
  final client = Supabase.instance.client;
  List<Embalagem> embalagens = [];
  //String _pesquisa = '';

  Future<List<Embalagem>> buscarEmbalagem(SupabaseClient client) async {
    final embalagensJson =
        await client.from('Embalagem').select().order('Nome', ascending: true);

    return parseEmbalagem(embalagensJson);
  }

  List<Embalagem> parseEmbalagem(List<dynamic> responseBody) {
    List<Embalagem> embalagens =
        responseBody.map((e) => Embalagem.fromJson(e)).toList();
    return embalagens;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const CabecalhoEmbalagem(),
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
                child: FutureBuilder<List<Embalagem>>(
                    future: buscarEmbalagem(client),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasData) {
                        embalagens = snapshot.data!;

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
                            columnTable('Peso Aprox.'),
                          ],
                          rows: embalagens.map((e) {
                            return DataRow(
                                onLongPress: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EditEmbalagens(embalagem: e)),
                                  );
                                },
                                cells: [
                                  columnData(e.nome),
                                  columnData(e.pesoAprox),
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
