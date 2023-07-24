import 'package:flutter/material.dart';

class TitleMedium extends StatelessWidget {
  final String title;
  final BuildContext context;
  const TitleMedium({
    Key? key, required this.title, required this.context,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(title, style: Theme.of(context).textTheme.titleMedium,);
  }
}