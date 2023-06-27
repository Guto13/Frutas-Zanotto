import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';

class BotaoPadrao extends StatelessWidget {
  const BotaoPadrao({
    Key? key,
    required this.context,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  final BuildContext context;
  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(defaultPadding),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
        ),
        onPressed: onPressed,
        child: Text(title, style: const TextStyle(color: textColor)),
      ),
    );
  }
}
