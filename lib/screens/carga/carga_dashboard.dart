import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/datas/carga.dart';
import 'package:maca_ipe/funcoes/banco_de_dados.dart';
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
                        columnData(e.id.toString(), e.id.toString()),
                        columnData(formatDate(e.data, [dd, '-', mm, '-', yyyy]),
                            e.id.toString()),
                        columnData(e.motorista.toString(), e.id.toString()),
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
