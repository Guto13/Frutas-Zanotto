import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maca_ipe/componetes_gerais/alert.dart';
import 'package:maca_ipe/componetes_gerais/app_bar.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/datas/classifi_lista.dart';
import 'package:maca_ipe/funcoes/banco_de_dados.dart';
import 'package:maca_ipe/screens/classificacao/classifi_romaneio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TabelaClassifi extends StatefulWidget {
  const TabelaClassifi({Key? key}) : super(key: key);

  @override
  State<TabelaClassifi> createState() => _TabelaClassifiState();
}

class _TabelaClassifiState extends State<TabelaClassifi> {
  final client = Supabase.instance.client;
  List<ClassifiLista> classifi = [];
  bool _isloading = false;

  Future<List<ClassifiLista>> buscarClassifi(SupabaseClient client) async {
    final classifisJson = await client
        .from('Classificacao')
        .select(
            'id, Fruta(id, Nome, Variedade), Embalagem(id, Nome), Quantidade, Produtor(id, Nome, Sobrenome), Data, Refugo, RomaneioId')
        .order('Data');

    return parseClassifi(classifisJson);
  }

  List<ClassifiLista> parseClassifi(List<dynamic> responseBody) {
    List<ClassifiLista> classifis =
        responseBody.map((e) => ClassifiLista.fromJson(e)).toList();
    return classifis;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: "Lista Classificações"),
        body: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Container(
            padding: const EdgeInsets.all(defaultPadding),
            decoration: const BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: _isloading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SizedBox(
                    width: double.infinity,
                    child: FutureBuilder<List<ClassifiLista>>(
                      future: buscarClassifi(client),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasData) {
                          classifi = snapshot.data!;
                          return SingleChildScrollView(
                            child: SizedBox(
                              width: double.infinity,
                              child: DataTable(
                                columnSpacing:
                                    16.0, // Espaçamento entre colunas
                                dataRowHeight:
                                    60.0, // Altura das linhas de dados
                                headingRowHeight: 70.0,
                                // Altura da linha de cabeçalho
                                dividerThickness:
                                    1.0, // Espessura da borda entre células
                                horizontalMargin: 20.0,
                                columns: [
                                  columnTable('Fruta'),
                                  columnTable('Quantidade'),
                                  columnTable('Refugo'),
                                  columnTable('Embalagem'),
                                  columnTable('Produtor'),
                                  columnTable('Data'),
                                  columnTable('Romaneio'),
                                ],
                                rows: classifi.map((e) {
                                  return DataRow(
                                      onLongPress: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Alert(
                                              content:
                                                  'Deseja mesmo excluir está Classificação?',
                                              title: 'Deletar',
                                              onCancel: () {
                                                Navigator.of(context).pop();
                                              },
                                              onConfirm: () async {
                                                setState(() {
                                                  _isloading = true;
                                                });
                                                Duration diference =
                                                    DateTime.now()
                                                        .difference(e.data);

                                                if (diference.inDays > 4) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                    content: const Text(
                                                      "Essa Classificação é muito antiga para ser excluida",
                                                      style: TextStyle(
                                                          color: textColor),
                                                    ),
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .error,
                                                  ));
                                                } else {
                                                  _onConfirm(
                                                      e.id,
                                                      e.fruta.id,
                                                      e.produtor.id,
                                                      e.embalagem.id,
                                                      e.quantidade);
                                                }
                                                setState(() {
                                                  _isloading = false;
                                                });
                                                Navigator.of(context).pop();
                                              },
                                            );
                                          },
                                        );
                                      },
                                      cells: [
                                        columnData(
                                            '${e.fruta.nome} ${e.fruta.variedade}'),
                                        columnData(e.quantidade.toString()),
                                        columnData(e.refugo.toString()),
                                        columnData(e.embalagem.nome),
                                        columnData(
                                            '${e.produtor.nome} ${e.produtor.sobrenome}'),
                                        columnData(formatDate(
                                            e.data, [dd, '-', mm, '-', yyyy])),
                                        columnIconBtn(() {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ClassifiRomaneio(
                                                      classifi: e,
                                                    )),
                                          );
                                        }, 'assets/icons/list.svg'),
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
                  ),
          ),
        ));
  }

  DataCell columnData(String data) {
    return DataCell(Text(data, style: const TextStyle(fontSize: 16)));
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

  DataColumn columnTable(String title) {
    return DataColumn(
      label: Text(title,
          style: const TextStyle(
              color: textColor, fontWeight: FontWeight.bold, fontSize: 18)),
    );
  }

  Future<void> _onConfirm(int id, int frutaId, int produtorId, int embalagemId,
      double quantidade) async {
    try {
      await excluirClassifi(
          client, frutaId, produtorId, embalagemId, quantidade, id, context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "Erro ao excluir tente novamente",
            style: TextStyle(color: textColor),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}
