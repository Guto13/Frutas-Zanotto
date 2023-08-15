import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/botao_padrao.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/componetes_gerais/title_medium.dart';
import 'package:maca_ipe/funcoes/responsive.dart';
import 'package:maca_ipe/screens/carga/carga_nova.dart';

class CargaCabecalho extends StatelessWidget {
  final GlobalKey<ScaffoldState> keyCarga;

  const CargaCabecalho({Key? key, required this.keyCarga}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Row(
        children: [
          if (!Responsive.isDesktop(context))
            IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  keyCarga.currentState!.openDrawer();
                }),
          TitleMedium(title: 'Carga', context: context),
          Spacer(
            flex: Responsive.isDesktop(context) ? 2 : 1,
          ),
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
