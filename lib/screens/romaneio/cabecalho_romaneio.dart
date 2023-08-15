import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/botao_padrao.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/componetes_gerais/title_medium.dart';
import 'package:maca_ipe/funcoes/responsive.dart';
import 'package:maca_ipe/screens/romaneio/lista_romaneios.dart';

class CabecalhoRomaneio extends StatelessWidget {
  const CabecalhoRomaneio({Key? key, required this.keyRomaneio})
      : super(key: key);

  final GlobalKey<ScaffoldState> keyRomaneio;

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
                  keyRomaneio.currentState!.openDrawer();
                }),
          TitleMedium(title: 'Romaneio', context: context),
          Spacer(
            flex: Responsive.isDesktop(context) ? 2 : 1,
          ),
          BotaoPadrao(
            context: context,
            title: 'Romaneios',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ListaRomaneios()),
            ),
          ),
        ],
      ),
    );
  }
}
