// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/componetes_gerais/text_bold_normal.dart';
import 'package:maca_ipe/componetes_gerais/title_medium.dart';
import 'package:maca_ipe/datas/palete_fruta.dart';

import '../../componetes_gerais/campos_tabela.dart';

class PaleteDemontracao extends StatelessWidget {
  const PaleteDemontracao({Key? key, required this.paleteFruta}) : super(key: key);

  final List<PaleteFrutaLista> paleteFruta;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: romaneioArea,
        child: GroupedListView<PaleteFrutaLista, String>(
          groupHeaderBuilder: (element) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: defaultPadding),
              TextBoldNormal(
                  bold: 'Fruta: ',
                  normal: '${element.fruta.nome} ${element.fruta.variedade}'),
              TextBoldNormal(
                  bold: 'Palete: ', normal: element.paleteId.toString()),
              const SizedBox(height: defaultPadding),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: TitleMedium(title: "Calibre", context: context)),
                  Expanded(
                      child: TitleMedium(title: "Categoria", context: context)),
                  Expanded(
                      child:
                          TitleMedium(title: "Quantidade", context: context)),
                ],
              ),
              const SizedBox(height: defaultPadding),
            ],
          ),
          shrinkWrap: true,
          elements: paleteFruta,
          groupBy: (element) =>
              '${element.fruta.nome} ${element.fruta.variedade}',
          itemBuilder: (context, element) => Card(
            elevation: 4,
            child: Table(
              defaultColumnWidth: const FlexColumnWidth(1.0),
              border: TableBorder.all(color: Colors.black, width: 1),
              children: [
                TableRow(
                  children: [
                    CampoTabelaCabecalho(value: element.calibre),
                    CampoTabelaCabecalho(value: element.categoria),
                    CampoTabelaCabecalho(value: element.quantidade.toString()),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
