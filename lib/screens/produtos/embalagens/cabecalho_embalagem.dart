import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/botao_padrao.dart';
import 'package:maca_ipe/componetes_gerais/search_field.dart';
import 'package:maca_ipe/screens/produtos/embalagens/add_embalagens.dart';

class CabecalhoEmbalagem extends StatelessWidget {
  const CabecalhoEmbalagem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SearchField(
            press: () {},
          ),
        ),
        const Spacer(),
        BotaoPadrao(
            context: context, title: 'Editar', onPressed: () {}),
        BotaoPadrao(
            context: context,
            title: 'Add',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AddEmbalagens()),
              );
            }),
      ],
    );
  }
}
