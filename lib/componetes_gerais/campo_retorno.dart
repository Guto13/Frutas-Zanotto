import 'package:flutter/material.dart';

class CampoRetorno extends StatelessWidget {
  const CampoRetorno({Key? key, required this.controller, required this.label})
      : super(key: key);

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
      ),
      readOnly: true,
      controller: controller,
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return 'Por favor, preencha este campo';
        }
        return null;
      },
    );
  }
}
