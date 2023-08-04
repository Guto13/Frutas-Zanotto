import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/botao_padrao.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/screens/carga/carga_nova.dart';

class CargaCabecalho extends StatelessWidget {
  const CargaCabecalho({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(child: Center()),
          const Spacer(),
          BotaoPadrao(
            context: context,
            title: 'Lista paletes completo',
            onPressed: () {},
          ),
          BotaoPadrao(
            context: context,
            title: 'Novo',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CargaNova()),
            ),
          ),
        ],
      ),
    );
  }
}
