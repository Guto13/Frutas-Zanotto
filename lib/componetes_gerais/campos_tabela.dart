import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';

class CampoTabelaCabecalho extends StatelessWidget {
  final String value;

  const CampoTabelaCabecalho({Key? key, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: TableCell(
          child: SizedBox(
        width: double.infinity,
        child: Center(
            child: SelectableText(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        )),
      )),
    );
  }
}

class CampoTabela extends StatelessWidget {
  final String value;

  const CampoTabela({Key? key, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: TableCell(
          child: SizedBox(
            width: double.infinity,
            child: Center(
                child: SelectableText(
                  value,
                )),
          )),
    );
  }
}
