import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/left_menu.dart';
import 'package:maca_ipe/funcoes/responsive.dart';
import 'package:maca_ipe/screens/paletes/paletes_dashboard.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PaletesScreen extends StatefulWidget {
  const PaletesScreen({Key? key}) : super(key: key);

  @override
  State<PaletesScreen> createState() => _PaletesScreenState();
}

class _PaletesScreenState extends State<PaletesScreen> {
  final client = Supabase.instance.client;
  final GlobalKey<ScaffoldState> key = GlobalKey();
  @override
  Widget build(BuildContext context) {
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
                    PaletesDashboard(
                      keyPaletes: key,
                    ),
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
