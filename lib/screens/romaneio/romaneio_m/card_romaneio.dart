import 'package:flutter/material.dart';
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
        width: 215,
        child: Row(
          children: [
            Expanded(
                flex: 1,
                child: Text(
                  name,
                  style: const TextStyle(fontSize: fontSubTitle),
                )),
            const SizedBox(
              width: defaultPadding,
            ),
            Expanded(
              flex: 2,
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                    label: Text(
                  'Valor',
                  style: TextStyle(fontSize: fontSubTitle),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
