import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';

class PaleteOutros extends StatelessWidget {
  const PaleteOutros({
    Key? key,
    required TextEditingController nameController,
    required TextEditingController quantController,
    required TextEditingController embalController,
  }) : _nameController = nameController, _quantController = quantController, _embalController = embalController, super(key: key);

  final TextEditingController _nameController;
  final TextEditingController _quantController;
  final TextEditingController _embalController;

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
                labelText: 'Fruta'),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          TextFormField(
            controller: _quantController,
            decoration: const InputDecoration(
                labelText: 'Quantidade'),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          TextFormField(
            controller: _embalController,
            decoration: const InputDecoration(
                labelText: 'Embalagem'),
          ),
        ],
      );
  }
}