import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/app_bar.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/componetes_gerais/left_menu.dart';
import 'package:maca_ipe/screens/produtos/embalagens/dashboard_embalagens.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmbalagensScreen extends StatelessWidget {
  EmbalagensScreen({Key? key}) : super(key: key);

  final client = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Embalagens"),
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
                    child: DashBoardEmbalagens(),
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


