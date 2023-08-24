import 'package:flutter/material.dart';

class Alert extends StatelessWidget {
  final String title;
  final String content;
  final String textOnCancel;
  final String textOnConfirm;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const Alert({
    Key? key,
    required this.title,
    required this.content,
    required this.onConfirm,
    required this.onCancel,
    this.textOnCancel = 'Cancelar',
    this.textOnConfirm = 'Confirmar',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: Text(textOnCancel),
        ),
        TextButton(
          onPressed: onConfirm,
          child: Text(textOnConfirm),
        ),
      ],
    );
  }
}
