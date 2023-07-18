import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/app_bar.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/componetes_gerais/left_menu.dart';
import 'package:maca_ipe/screens/estoque/dashboard_estoque.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EstoqueScreen extends StatelessWidget {
  EstoqueScreen({Key? key}) : super(key: key);

  final client = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Estoque"),
      body:  LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > maxWidthArea) {
            return SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: LeftMenu(client: client)),
                  const Expanded(
                    flex: 5,
                    child: DashboardEstoque(),
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

