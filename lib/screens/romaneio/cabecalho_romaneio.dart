import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/botao_padrao.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';

class CabecalhoRomaneio extends StatelessWidget {
  const CabecalhoRomaneio({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              SizedBox(
                height: defaultPadding * 1.5,
              ),
              Text(
                'Selecione uma fruta abaixo',
                style: TextStyle(color: textColor, fontSize: fontTitle),
              ),
            ],
          )),
          const Spacer(),
          BotaoPadrao(context: context, title: 'Romaneios', onPressed: () {}),
        ],
      ),
    );
  }
}
