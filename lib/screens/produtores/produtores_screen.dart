import 'package:maca_ipe/componetes_gerais/left_menu.dart';
import 'package:maca_ipe/screens/produtores/dashboard_produtores.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../componetes_gerais/app_bar.dart';
import 'package:flutter/material.dart';
import '../../componetes_gerais/constants.dart';

class ProdutoresScreen extends StatelessWidget {
  ProdutoresScreen({Key? key}) : super(key: key);

  final client = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Produtores"),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > maxWidthArea) {
            return SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: LeftMenu(client: client)),
                  const Expanded(
                    flex: 5,
                    child: DashBoardProdutores(),
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
