import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/app_bar.dart';
import 'package:maca_ipe/funcoes/responsive.dart';
import 'package:maca_ipe/screens/romaneio/romaneio_cp/romaneio_cp_desktop.dart';
import 'package:maca_ipe/screens/romaneio/romaneio_cp/romaneio_cp_mobile.dart';

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
      body: !Responsive.isMobile(context) ? RomaneioCPDesktop(
              textControllers: textControllers, frutaR: widget.frutaR) : RomaneioCPMobile(textControllers: textControllers, frutaR: widget.frutaR),
       
    );
  }
}
