import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/app_bar.dart';
import 'package:maca_ipe/componetes_gerais/botao_padrao.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/screens/estoque/estoque_entrada.dart';

class EstoqueScreen extends StatelessWidget {
  const EstoqueScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Estoque"),
      body: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            BotaoPadrao(
              context: context,
              title: 'Entrada',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EntradaEstoque()),
              ),
            ),
            const SizedBox(
              width: defaultPadding,
            ),
            BotaoPadrao(context: context, title: 'Saída', onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
