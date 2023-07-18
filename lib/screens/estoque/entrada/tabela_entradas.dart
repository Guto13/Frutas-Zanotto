// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/app_bar.dart';
import 'package:maca_ipe/datas/entrada_lista.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TabelaEntrada extends StatefulWidget {
  const TabelaEntrada({Key? key}) : super(key: key);

  @override
  State<TabelaEntrada> createState() => _TabelaEntradaState();
}

class _TabelaEntradaState extends State<TabelaEntrada> {
  final client = Supabase.instance.client;
  List<EntradaLista> entradas = [];

  Future<List<EntradaLista>> buscarEntradas(SupabaseClient client) async {
    final entradasJson = await client.from('Entradas').select(
        'Fruta(Nome, Variedade), Embalagem(Nome), Quantidade, Produtor(Nome, Sobrenome), Data');

    return parseEntrada(entradasJson);
  }

  List<EntradaLista> parseEntrada(List<dynamic> responseBody) {
    List<EntradaLista> entradas =
        responseBody.map((e) => EntradaLista.fromJson(e)).toList();
    return entradas;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: "Tabela Entradas"),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(),
            FutureBuilder<List<EntradaLista>>(
              future: buscarEntradas(client),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData) {
                  entradas = snapshot.data!;
                  return SingleChildScrollView(
                    child: SizedBox(
                      width: double.infinity,
                      child: DataTable(
                        columnSpacing: 16.0, // Espaçamento entre colunas
                        dataRowHeight: 60.0, // Altura das linhas de dados
                        headingRowHeight: 70.0,
                        // Altura da linha de cabeçalho
                        dividerThickness: 1.0, // Espessura da borda entre células
                        horizontalMargin: 20.0,
                        // Margem horizontal interna
                        columns: const [
                          DataColumn(
                              label: Text(
                            'Fruta',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          )),
                          DataColumn(
                              label: Text(
                            'Quantidade',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          )),
                          DataColumn(
                              label: Text(
                            'Embalagem',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          )),
                          DataColumn(
                              label: Text(
                            'Produtor',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          )),
                          DataColumn(
                              label: Text(
                            'Data',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          )),
                        ],
                        rows: entradas.map((e) {
                          return DataRow(cells: [
                            DataCell(Text('${e.fruta.nome} ${e.fruta.variedade}',
                                style: const TextStyle(fontSize: 16))),
                            DataCell(Text(e.quantidade.toString(),
                                style: const TextStyle(fontSize: 16))),
                            DataCell(Text(e.embalagem.nome,
                                style: const TextStyle(fontSize: 16))),
                            DataCell(Text(
                                '${e.produtor.nome} ${e.produtor.sobrenome}',
                                style: const TextStyle(fontSize: 16))),
                            DataCell(Text(
                                e.data.day.toString() +
                                    "/" +
                                    e.data.month.toString() +
                                    '/' +
                                    e.data.year.toString() +
                                    '  ' +
                                    e.data.hour.toString() +
                                    ':' +
                                    e.data.minute.toString() +
                                    'h',
                                style: const TextStyle(fontSize: 16))),
                          ]);
                        }).toList(),
                      ),
                    ),
                  );
                } else {
                  return const Center(
                    child: Text("Erro ao retornar dados"),
                  );
                }
              },
            ),
          ],
        ));
  }
}
