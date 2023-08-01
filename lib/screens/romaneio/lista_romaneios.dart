import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maca_ipe/componetes_gerais/app_bar.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/datas/romaneio_lista.dart';
import 'package:maca_ipe/screens/romaneio/romaneio_completo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ListaRomaneios extends StatefulWidget {
  const ListaRomaneios({Key? key}) : super(key: key);

  @override
  State<ListaRomaneios> createState() => _ListaRomaneiosState();
}

class _ListaRomaneiosState extends State<ListaRomaneios> {
  final client = Supabase.instance.client;
  List<RomaneioLista> romaneioLista = [];
  String _pesquisa = '';

  void atualizarPesquisa(String novaPesquisa) {
    setState(() {
      _pesquisa = novaPesquisa;
    });
  }

  Future<List<RomaneioLista>> buscarEstoqueSC(SupabaseClient client) async {
    final romaneioJson = await client
        .from('Romaneio')
        .select(
            'id, Fruta(id, Nome, Variedade), Embalagem(id, Nome), Data, Produtor(id, Nome, Sobrenome), TFruta')
        .order('Data');

    return parseRomaneioJson(romaneioJson);
  }

  List<RomaneioLista> parseRomaneioJson(List<dynamic> responseBody) {
    List<RomaneioLista> romaneio =
        responseBody.map((e) => RomaneioLista.fromJson(e)).toList();
    return romaneio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: "Lista Romaneios"),
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
                  const SizedBox(
                    width: defaultPadding,
                  ),
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
                  child: FutureBuilder<List<RomaneioLista>>(
                      future: buscarEstoqueSC(client),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasData) {
                          romaneioLista = snapshot.data!;
                          //Organiza os dados baseado na pesquisa
                          romaneioLista = romaneioLista
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
                              columnTable('Embalagem'),
                              columnTable('Data'),
                              columnTable('Dados')
                            ],
                            rows: romaneioLista.map((e) {
                              return DataRow(cells: [
                                columnData(
                                    '${e.produtor.nome} ${e.produtor.sobrenome}',
                                    e.id.toString()),
                                columnData(
                                    '${e.fruta.nome} ${e.fruta.variedade}',
                                    e.id.toString()),
                                columnData(e.embalagem.nome, e.id.toString()),
                                columnData(
                                    formatDate(
                                        e.data, [dd, '-', mm, '-', yyyy]),
                                    e.id.toString()),
                                columnIconBtn(() {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RomaneioCompleto(
                                              romaneio: e,
                                            )),
                                  );
                                }, 'assets/icons/list.svg'),
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
            ]),
          ),
        ));
  }

  DataCell columnData(String data, String message) {
    return DataCell(Tooltip(
        message: message,
        child: Text(data, style: const TextStyle(fontSize: 16))));
  }

  DataColumn columnTable(String title) {
    return DataColumn(
      label: Text(
        title,
        style: const TextStyle(color: textColor),
      ),
    );
  }

  DataCell columnIconBtn(VoidCallback press, String icon) {
    return DataCell(
      SvgPicture.asset(
        icon,
        height: 25,
      ),
      onTap: press,
    );
  }
}