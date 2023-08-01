import 'package:flutter/material.dart';

class TextBoldNormal extends StatelessWidget {
  const TextBoldNormal({
    Key? key,
    required this.bold,
    required this.normal,
  }) : super(key: key);

  final String bold;
  final String normal;

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(children: [
      TextSpan(
        text: bold,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      TextSpan(
        text: normal,
      )
    ]));
  }
}
