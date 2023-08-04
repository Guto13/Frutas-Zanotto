import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/app_bar.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/componetes_gerais/left_menu.dart';
import 'package:maca_ipe/screens/carga/carga_cabecalho.dart';
import 'package:maca_ipe/screens/carga/carga_dashboard.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CargaScreen extends StatelessWidget {
  CargaScreen({Key? key}) : super(key: key);

  final client = Supabase.instance.client;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Carga'),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > maxWidthArea) {
            return SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: LeftMenu(client: client)),
                  Expanded(
                    flex: 5,
                    child: SingleChildScrollView(
                      child: Column(
                        children: const [
                          CargaCabecalho(),
                          CargaDashboard(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center();
          }
        },
      ),
    );
  }
}
