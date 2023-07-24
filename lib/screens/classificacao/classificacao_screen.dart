import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/app_bar.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/screens/classificacao/cabecalho_classifi.dart';
import 'package:maca_ipe/screens/classificacao/cadastro_classifi.dart';

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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > maxWidthArea) {
        return Scaffold(
            appBar: CustomAppBar(title: 'Classificação'),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  CabecalhoClassifi(
                    onSearch: atualizarPesquisa,
                  ),
                  CadastroClassifi(pesquisa: _pesquisa),
                ],
              ),
            ));
      } else {
        return const Center();
      }
    });
  }
}
