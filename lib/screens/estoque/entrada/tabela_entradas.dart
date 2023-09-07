// ignore_for_file: use_build_context_synchronously

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/alert.dart';
import 'package:maca_ipe/componetes_gerais/app_bar.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/datas/entrada_lista.dart';
import 'package:maca_ipe/funcoes/banco_de_dados.dart';
import 'package:maca_ipe/funcoes/responsive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TabelaEntrada extends StatefulWidget {
  const TabelaEntrada({Key? key}) : super(key: key);

  @override
  State<TabelaEntrada> createState() => _TabelaEntradaState();
}

class _TabelaEntradaState extends State<TabelaEntrada> {
  final client = Supabase.instance.client;
  List<EntradaLista> entradas = [];
  bool _isloading = false;

  Future<List<EntradaLista>> buscarEntradas(SupabaseClient client) async {
    final entradasJson = await client
        .from('Entradas')
        .select(
            'id, Fruta(id, Nome, Variedade), Embalagem(id, Nome), Quantidade, Produtor(id, Nome, Sobrenome), Data, IsClassifi')
        .order('Data');

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
                ? const Center(child: CircularProgressIndicator())
                : SizedBox(
                    width: double.infinity,
                    child: FutureBuilder<List<EntradaLista>>(
                      future: buscarEntradas(client),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasData) {
                          entradas = snapshot.data!;
                          return SingleChildScrollView(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: SizedBox(
                                width: Responsive.isMobile(context)
                                    ? 600
                                    : MediaQuery.of(context).size.width,
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
                                    columnTable('Embalagem'),
                                    columnTable('Produtor'),
                                    columnTable('Data'),
                                  ],
                                  rows: entradas.map((e) {
                                    return DataRow(
                                        onLongPress: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Alert(
                                                content:
                                                    'Deseja mesmo excluir está entrada?',
                                                title: 'Deletar',
                                                onCancel: () {
                                                  Navigator.of(context).pop();
                                                },
                                                onConfirm: () async {
                                                  setState(() {
                                                    _isloading = true;
                                                  });
                                                  _onConfirm(
                                                      e.id,
                                                      e.fruta.id,
                                                      e.produtor.id,
                                                      e.embalagem.id,
                                                      e.quantidade,
                                                      e.isClassifi);
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
                                          columnData(e.embalagem.nome),
                                          columnData(
                                              '${e.produtor.nome} ${e.produtor.sobrenome}'),
                                          columnData(formatDate(e.data,
                                              [dd, '-', mm, '-', yyyy])),
                                        ]);
                                  }).toList(),
                                ),
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

  Future<void> _onConfirm(int id, int frutaId, int produtorId, int embalagemId,
      double quantidade, bool isClassifi) async {
    if (isClassifi) {
      try {
        /*await excluirEntradaC(
            client, frutaId, produtorId, embalagemId, quantidade, id, context);*/
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
    } else {
      try {
        await excluirEntradaSC(
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
}
