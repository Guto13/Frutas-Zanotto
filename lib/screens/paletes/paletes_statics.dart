import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/datas/statics.dart';
import 'package:maca_ipe/screens/paletes/chart.dart';

class PaletesStatics extends StatelessWidget {
  const PaletesStatics({
    Key? key,
    required this.statics,
  }) : super(key: key);

  final StaticsPaletes statics;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Paletes",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: defaultPadding),
          Chart(
            statics: statics,
          )
        ],
      ),
    );
  }
}