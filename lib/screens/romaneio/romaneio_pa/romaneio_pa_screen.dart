import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/app_bar.dart';
import 'package:maca_ipe/screens/romaneio/romaneio_pa/romaneio_pa_desktop.dart';

class RomaneioPAScreen extends StatefulWidget {
  const RomaneioPAScreen({Key? key, required this.frutaR}) : super(key: key);

  final String frutaR;

  @override
  State<RomaneioPAScreen> createState() => _RomaneioPAScreenState();
}

class _RomaneioPAScreenState extends State<RomaneioPAScreen> {
  List<TextEditingController> textControllers =
      List.generate(13, (_) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Romaneio - ${widget.frutaR}'),
      body: RomaneioPADesktop(
          textControllers: textControllers, frutaR: widget.frutaR),
    );
  }
}
