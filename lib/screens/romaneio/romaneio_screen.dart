import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/componetes_gerais/left_menu.dart';
import 'package:maca_ipe/funcoes/responsive.dart';
import 'package:maca_ipe/screens/romaneio/cabecalho_romaneio.dart';
import 'package:maca_ipe/screens/romaneio/dashboard_romaneio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RomaneioScreen extends StatefulWidget {
  const RomaneioScreen({Key? key}) : super(key: key);

  @override
  State<RomaneioScreen> createState() => _RomaneioScreenState();
}

class _RomaneioScreenState extends State<RomaneioScreen> {
  final GlobalKey<ScaffoldState> key = GlobalKey();
  final client = Supabase.instance.client;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      drawer: LeftMenu(client: client),
      body: SafeArea(
        child: Row(
          children: [
           if (Responsive.isDesktop(context))
              Expanded(child: LeftMenu(client: client)),
            Expanded(
              flex: 5,
              child: Drawer(
                backgroundColor: bgColor.withOpacity(0.9),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:  [
                      CabecalhoRomaneio(keyRomaneio: key,),
                      const SizedBox(
                        width: defaultPadding,
                      ),
                      const DashboardRomaneio(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
