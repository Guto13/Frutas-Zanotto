import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/left_menu.dart';
import 'package:maca_ipe/funcoes/responsive.dart';
import 'package:maca_ipe/screens/carga/carga_cabecalho.dart';
import 'package:maca_ipe/screens/carga/carga_dashboard.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CargaScreen extends StatelessWidget {
  CargaScreen({Key? key}) : super(key: key);

  final client = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> key = GlobalKey();
    return Scaffold(
      key: key,
      drawer: LeftMenu(client: client),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              Expanded(child: LeftMenu(client: client)),
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CargaCabecalho(
                      keyCarga: key,
                    ),
                    const CargaDashboard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
