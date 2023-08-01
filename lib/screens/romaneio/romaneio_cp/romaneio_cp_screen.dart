import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/app_bar.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/screens/romaneio/romaneio_cp/romaneio_cp_desktop.dart';

class RomaneioCPScreen extends StatefulWidget {
  const RomaneioCPScreen({Key? key, required this.frutaR}) : super(key: key);

  final String frutaR;

  @override
  State<RomaneioCPScreen> createState() => _RomaneioCPScreenState();
}

class _RomaneioCPScreenState extends State<RomaneioCPScreen> {
  List<TextEditingController> textControllers =
      List.generate(6, (_) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Romaneio - ${widget.frutaR}'),
      body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth > maxWidthArea) {
          return RomaneioCPDesktop(
              textControllers: textControllers, frutaR: widget.frutaR);
        } else {
          return const SingleChildScrollView();
        }
      }),
    );
  }
}
