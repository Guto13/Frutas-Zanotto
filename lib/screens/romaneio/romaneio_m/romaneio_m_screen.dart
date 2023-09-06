import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/app_bar.dart';
import 'package:maca_ipe/funcoes/responsive.dart';
import 'package:maca_ipe/screens/romaneio/romaneio_m/romaneio_m_desktop.dart';
import 'package:maca_ipe/screens/romaneio/romaneio_m/romaneio_m_mobile.dart';

class RomaneioMScreen extends StatefulWidget {
  const RomaneioMScreen({Key? key}) : super(key: key);

  @override
  State<RomaneioMScreen> createState() => _RomaneioMScreenState();
}

class _RomaneioMScreenState extends State<RomaneioMScreen> {
  List<TextEditingController> textControllers =
      List.generate(23, (_) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Romaneio - Maçã'),
      body: !Responsive.isMobile(context)
          ? RomaneioMDesktop(textControllers: textControllers)
          : RomaneioMMobile(textControllers: textControllers),
    );
  }
}
