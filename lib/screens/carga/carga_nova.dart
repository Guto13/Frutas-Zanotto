import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maca_ipe/componetes_gerais/app_bar.dart';
import 'package:maca_ipe/componetes_gerais/botao_padrao.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/datas/palete.dart';
import 'package:maca_ipe/funcoes/banco_de_dados.dart';
import 'package:maca_ipe/screens/carga/confirmacao_carga.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CargaNova extends StatefulWidget {
  const CargaNova({Key? key}) : super(key: key);

  @override
  State<CargaNova> createState() => _CargaNovaState();
}

class _CargaNovaState extends State<CargaNova> {
  final client = Supabase.instance.client;
  List<Palete> paleteLista = [];
  List<Palete> paletesSelecionados = [];
  Map<int, bool> selectedMap = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Nova Carga'),
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
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: FutureBuilder<List<Palete>>(
                      future: buscarPaletesNCarregados(client, false),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasData) {
                          paleteLista = snapshot.data!;

                          return DataTable(
                            columnSpacing: 16.0,
                            dataRowHeight: 60.0,
                            headingRowHeight:
                                70.0, // Altura da linha de cabeçalho
                            dividerThickness:
                                1.0, // Espessura da borda entre células
                            horizontalMargin: 20.0,
                            columns: [
                              columnTable(''),
                              columnTable('Palete'),
                              columnTable('Data'),
                              columnTable('Carga'),
                              columnTable('Carregado'),
                              columnTable('Dados')
                            ],
                            rows: paleteLista.map((e) {
                              bool isSelected = selectedMap.containsKey(e.id)
                                  ? selectedMap[e.id]!
                                  : false;
                              return DataRow(cells: [
                                DataCell(
                                  Checkbox(
                                    value: isSelected,
                                    onChanged: (value) {
                                      if (value!) {
                                        setState(() {
                                          paletesSelecionados.add(e);
                                          selectedMap[e.id] = value;
                                        });
                                      } else {
                                        setState(() {
                                          paletesSelecionados.removeWhere(
                                              (element) => element.id == e.id);
                                          selectedMap[e.id] = value;
                                        });
                                      }
                                    },
                                  ),
                                ),
                                columnData(e.id.toString(), e.id.toString()),
                                columnData(
                                    formatDate(
                                        e.data, [dd, '-', mm, '-', yyyy]),
                                    e.id.toString()),
                                columnData(e.carga.toString(), e.id.toString()),
                                columnData(e.carregado ? "Sim" : "Não",
                                    e.id.toString()),
                                columnIconBtn(() {}, 'assets/icons/list.svg'),
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
                const SizedBox(
                  height: defaultPadding,
                ),
                Column(
                  children: [
                    ...paletesSelecionados
                        .map((e) => Text(e.id.toString()))
                        .toList(),
                  ],
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                paletesSelecionados.isNotEmpty
                    ? BotaoPadrao(
                        context: context,
                        title: 'Selecionar',
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ConfirmacaoCarga(
                                    paletes: paletesSelecionados,
                                  )),
                        ),
                      )
                    : const Center(),
              ],
            ),
          ),
        ),
      ),
    );
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
