import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/app_bar.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/datas/palete.dart';
import 'package:maca_ipe/screens/carga/palete_demonstracao.dart';

class ConfirmacaoCarga extends StatefulWidget {
  const ConfirmacaoCarga({Key? key, required this.paletes}) : super(key: key);

  final List<Palete> paletes;

  @override
  State<ConfirmacaoCarga> createState() => _ConfirmacaoCargaState();
}

class _ConfirmacaoCargaState extends State<ConfirmacaoCarga> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Confirmação da Carga'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              ...widget.paletes
                  .map(
                    (e) => PaleteDemonstracao(palete: e),
                  )
                  .toList()
            ],
          ),
        ),
      ),
    );
  }
}
