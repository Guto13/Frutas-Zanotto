import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/app_bar.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';

class RomaneioScreen extends StatefulWidget {
  const RomaneioScreen({Key? key}) : super(key: key);

  @override
  State<RomaneioScreen> createState() => _RomaneioScreenState();
}

class _RomaneioScreenState extends State<RomaneioScreen> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > maxWidthArea) {
        return Scaffold(
          appBar: CustomAppBar(title: 'Romaneio'),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Selecione a fruta classificada"),
                  const SizedBox(height: defaultPadding * 2),
                  InkWell(
                    onTap: () {},
                    child: const Text('Maçã'),
                  ),
                  const SizedBox(height: defaultPadding * 2),
                  InkWell(
                    onTap: () {},
                    child: const Text('Pêssego/ameixa'),
                  ),
                  const SizedBox(height: defaultPadding * 2),
                  InkWell(
                    onTap: () {},
                    child: const Text('Pêra'),
                  ),
                  const SizedBox(height: defaultPadding * 2),
                  InkWell(
                    onTap: () {},
                    child: const Text('Caqui'),
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        return Container();
      }
    });
  }
}
