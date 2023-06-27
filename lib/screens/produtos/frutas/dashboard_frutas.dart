import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/botao_padrao.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/componetes_gerais/search_field.dart';
import 'package:maca_ipe/screens/produtos/frutas/add_fruta.dart';

class DashBoardFrutas extends StatelessWidget {
  const DashBoardFrutas({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Row(
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
                        MaterialPageRoute(builder: (context) => const AddFrutas()),
                      );
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}