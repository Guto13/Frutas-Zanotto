import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/app_bar.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/datas/produtor.dart';
import 'package:maca_ipe/funcoes/banco_de_dados.dart';
import 'package:maca_ipe/screens/romaneio/romaneio_produtor/r_produtor_fruta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RomaneioProdutor extends StatefulWidget {
  const RomaneioProdutor({Key? key}) : super(key: key);

  @override
  State<RomaneioProdutor> createState() => _RomaneioProdutorState();
}

class _RomaneioProdutorState extends State<RomaneioProdutor> {
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
    return Scaffold(
      appBar: CustomAppBar(title: "Romaneio Produtor"),
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: SingleChildScrollView(
          child: Column(children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      atualizarPesquisa(value);
                    },
                    decoration: InputDecoration(
                      fillColor: bgColor.withOpacity(0.5),
                      filled: true,
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      suffixIcon: Container(
                        padding: const EdgeInsets.all(defaultPadding * 0.6),
                        margin:
                            const EdgeInsets.only(right: defaultPadding / 3),
                        decoration: const BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: const Icon(
                          Icons.search,
                          color: textColor,
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                const SizedBox(),
              ],
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
                          headingRowHeight:
                              70.0, // Altura da linha de cabeçalho
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
                                onLongPress: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => RProdutorFruta(
                                                produtor: e,
                                              )),
                                    ),
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
            )
          ]),
        ),
      ),
    );
  }
}
