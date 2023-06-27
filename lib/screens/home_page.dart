import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/componetes_gerais/left_menu.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final client = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > maxWidthArea) {
            // Se a largura for maior que 600 pixels, mostraremos os botões em uma linha
            return SafeArea(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(child: LeftMenu(client: client)),
                    Expanded(
                        flex: 5,
                        child: Container(
                          color: Colors.orangeAccent,
                        ))
                  ]),
            );
          } else {
            // Se a largura for menor ou igual a 600 pixels, mostraremos os botões em uma coluna
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            );
          }
        },
      ),
    );
  }
}


