import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/datas/carga.dart';
import 'package:maca_ipe/funcoes/banco_de_dados.dart';
import 'package:maca_ipe/screens/carga/carga_completa.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CargaDashboard extends StatefulWidget {
  const CargaDashboard({Key? key}) : super(key: key);

  @override
  State<CargaDashboard> createState() => _CargaDashboardState();
}

class _CargaDashboardState extends State<CargaDashboard> {
  final client = Supabase.instance.client;
  List<Carga> cargaLista = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
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
          child: FutureBuilder<List<Carga>>(
              future: buscarCargas(client),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData) {
                  cargaLista = snapshot.data!;

                  return DataTable(
                    columnSpacing: 16.0,
                    dataRowHeight: 60.0,
                    headingRowHeight: 70.0, // Altura da linha de cabeçalho
                    dividerThickness: 1.0, // Espessura da borda entre células
                    horizontalMargin: 20.0,
                    columns: [
                      columnTable('Carga'),
                      columnTable('Data'),
                      columnTable('Motorista'),
                      columnTable('Dados')
                    ],
                    rows: cargaLista.map((e) {
                      return DataRow(cells: [
                        columnData(e.id.toString(), message: e.id.toString()),
                        columnData(formatDate(e.data, [dd, '-', mm, '-', yyyy]),
                           message: e.id.toString()),
                        columnData(e.motorista.toString(), message: e.id.toString()),
                        columnIconBtn(
                            () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CargaCompleta(
                                            carga: e,
                                          )),
                                ),
                            'assets/icons/list.svg'),
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
    );
  }
}
