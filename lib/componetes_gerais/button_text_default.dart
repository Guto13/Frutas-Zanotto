import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';

class ButtonTextDefault extends StatelessWidget {
  const ButtonTextDefault({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(defaultPadding),
        decoration: const BoxDecoration(
          color: bgColor2,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(fontSize: fontSubTitle, color: textColor),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
