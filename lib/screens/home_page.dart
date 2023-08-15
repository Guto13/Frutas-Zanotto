import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/left_menu.dart';
import 'package:maca_ipe/funcoes/responsive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final client = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          if (Responsive.isDesktop(context))
            Expanded(
              child: LeftMenu(
                client: client,
              ),
            ),
          Expanded(flex: 5, child: Container())
        ]),
      ),
    );
  }
}
