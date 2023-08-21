import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maca_ipe/componetes_gerais/botao_padrao.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';

class CardRomaneio extends StatelessWidget {
  const CardRomaneio({Key? key, required this.controller, required this.name})
      : super(key: key);

  final TextEditingController controller;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Container(
        padding: const EdgeInsets.only(
            left: defaultPadding, right: defaultPadding, bottom: 5),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 3),
              blurRadius: 6,
              color: Colors.black,
            ),
          ],
        ),
        width: 310,
        child: Row(
          children: [
            Expanded(
                flex: 2,
                child: Text(
                  name,
                  style: const TextStyle(fontSize: fontSubTitle),
                )),
            const SizedBox(
              width: defaultPadding,
            ),
            Expanded(
                child: BotaoPadrao(
                    context: context,
                    title: '',
                    onPressed: () {
                      int enteredValue = int.tryParse(controller.text) ?? 0;
                      enteredValue -= 1;
                      controller.text = enteredValue.toString();
                    })),
            Expanded(
              flex: 2,
              child: TextField(
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: controller,
                decoration: const InputDecoration(
                    label: Text(
                  'Valor',
                  style: TextStyle(fontSize: fontSubTitle),
                )),
              ),
            ),
            Expanded(
                child: BotaoPadrao(
                    context: context,
                    title: '',
                    onPressed: () {
                      int enteredValue = int.tryParse(controller.text) ?? 0;
                      enteredValue += 1;
                      controller.text = enteredValue.toString();
                    })),
          ],
        ),
      ),
    );
  }
}
