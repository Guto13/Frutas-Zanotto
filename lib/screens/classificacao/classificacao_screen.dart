import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/app_bar.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/componetes_gerais/left_menu.dart';
import 'package:maca_ipe/screens/classificacao/cabecalho_classifi.dart';
import 'package:maca_ipe/screens/classificacao/cadastro_classifi.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ClassificacaoScreen extends StatefulWidget {
  const ClassificacaoScreen({Key? key}) : super(key: key);

  @override
  State<ClassificacaoScreen> createState() => _ClassificacaoScreenState();
}

class _ClassificacaoScreenState extends State<ClassificacaoScreen> {
  String _pesquisa = "";
  void atualizarPesquisa(String novaPesquisa) {
    setState(() {
      _pesquisa = novaPesquisa;
    });
  }

  final client = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> key = GlobalKey();
    return Scaffold(
        key: key,
        drawer: LeftMenu(client: client),
        body: SingleChildScrollView(
          child: Column(
            children: [
              CabecalhoClassifi(
                onSearch: atualizarPesquisa,
                keyClassifi: key,
              ),
              CadastroClassifi(pesquisa: _pesquisa),
            ],
          ),
        ));
  }
}
