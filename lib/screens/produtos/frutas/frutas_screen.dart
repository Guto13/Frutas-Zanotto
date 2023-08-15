import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/left_menu.dart';
import 'package:maca_ipe/funcoes/responsive.dart';
import 'package:maca_ipe/screens/produtos/frutas/dashboard_frutas.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FrutasScreen extends StatelessWidget {
  FrutasScreen({Key? key}) : super(key: key);

  final client = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> key = GlobalKey();
    return Builder(builder: (context) {
      return Scaffold(
        key: key,
        drawer: LeftMenu(client: client),
        body: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (Responsive.isDesktop(context))
                Expanded(
                  child: LeftMenu(
                    client: client,
                  ),
                ),
              Expanded(
                flex: 5,
                child: DashBoardFrutas(
                  keyFrutas: key,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
