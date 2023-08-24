import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/app_bar.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/datas/produtor.dart';
import 'package:maca_ipe/datas/romaneio_lista.dart';
import 'package:maca_ipe/funcoes/banco_de_dados.dart';
import 'package:maca_ipe/screens/romaneio/romaneio_produtor/r_produtor_completo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RProdutorFruta extends StatefulWidget {
  const RProdutorFruta({Key? key, required this.produtor}) : super(key: key);

  final Produtor produtor;

  @override
  State<RProdutorFruta> createState() => _RProdutorFrutaState();
}

class _RProdutorFrutaState extends State<RProdutorFruta> {
  final client = Supabase.instance.client;
  List<RomaneioLista> romaneioLista = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Romaneio Produtor - Fruta"),
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(defaultPadding),
            decoration: const BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: FutureBuilder<List<RomaneioLista>>(
                  future:
                      buscarRomaneioListaProdutor(client, widget.produtor.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasData) {
                      romaneioLista = snapshot.data!;

                      Set<String> nomesDiferentes = <String>{};
                      List<RomaneioLista> produtorFruta = [];

                      for (var romaneio in romaneioLista) {
                        if (!nomesDiferentes.contains(
                            '${romaneio.fruta.nome} ${romaneio.fruta.variedade}')) {
                          nomesDiferentes.add(
                              '${romaneio.fruta.nome} ${romaneio.fruta.variedade}');
                          produtorFruta.add(romaneio);
                        }
                      }

                      return produtorFruta.isEmpty
                          ? const Center(
                              child: Text('Sem romaneios vinculados'),
                            )
                          : DataTable(
                              columnSpacing: 16.0,
                              dataRowHeight: 60.0,
                              headingRowHeight:
                                  70.0, // Altura da linha de cabeçalho
                              dividerThickness:
                                  1.0, // Espessura da borda entre células
                              horizontalMargin: 20.0,
                              columns: [
                                columnTable('Produtor'),
                                columnTable('Fruta'),
                              ],
                              rows: produtorFruta.map((e) {
                                return DataRow(
                                    onLongPress: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RProdutorCompleto(
                                                    id: e.id,
                                                    romaneioLista:
                                                        romaneioLista,
                                                    tFruta: e.tfruta,
                                                  )),
                                        ),
                                    cells: [
                                      columnData(
                                          '${e.produtor.nome} ${e.produtor.sobrenome}',
                                          message: e.id.toString()),
                                      columnData(
                                          '${e.fruta.nome} ${e.fruta.variedade}',
                                          message: e.id.toString()),
                                    ]);
                              }).toList(),
                            );
                    } else {
                      return const Center(
                        child: Text('Erro ao carregar os dados'),
                      );
                    }
                  }),
            ),
          ),
        ),
      ),
    );
  }
}
