import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/app_bar.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/componetes_gerais/left_menu.dart';
import 'package:maca_ipe/screens/paletes/paletes_cabecalho.dart';
import 'package:maca_ipe/screens/paletes/paletes_dashboard.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PaletesScreen extends StatefulWidget {
  const PaletesScreen({Key? key}) : super(key: key);

  @override
  State<PaletesScreen> createState() => _PaletesScreenState();
}

class _PaletesScreenState extends State<PaletesScreen> {
  final client = Supabase.instance.client;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Paletes'),
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
                          PaletesCabecalho(),
                          PaletesDashboard(),
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
