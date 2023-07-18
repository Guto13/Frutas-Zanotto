import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/app_bar.dart';
import 'package:maca_ipe/componetes_gerais/botao_padrao.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';

class ClassificacaoScreen extends StatefulWidget {
  const ClassificacaoScreen({Key? key}) : super(key: key);

  @override
  State<ClassificacaoScreen> createState() => _ClassificacaoScreenState();
}

class _ClassificacaoScreenState extends State<ClassificacaoScreen> {
  //Falta lógica necessária para utilizar o _isloading falta apenas testar e analisar as outras maneiras.
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > maxWidthArea) {
        return Scaffold(
            appBar: CustomAppBar(title: 'Classificação'),
            body: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(defaultPadding),
                          child: BotaoPadrao(
                              context: context,
                              title: 'Lista',
                              onPressed: () {}),
                        ),
                        const SizedBox(
                          height: defaultPadding * 2,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(defaultPadding),
                          child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: FutureBuilder(
                                          builder: ((context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            } else if (snapshot.hasData) {
                                              //Montar parte para salvar os dados se funcionar
                                              return Container();
                                            } else {
                                              return const Center(
                                                  child: Text(
                                                      'Erro ao carregar dados'));
                                            }
                                          }),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: defaultPadding * 2,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: defaultPadding,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(flex: 1, child: TextFormField()),
                                      Expanded(flex: 1, child: TextFormField()),
                                      Expanded(flex: 1, child: TextFormField()),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: defaultPadding,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(flex: 1, child: TextFormField()),
                                      Expanded(flex: 1, child: TextFormField()),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: defaultPadding,
                                  ),
                                  TextFormField(),
                                  const SizedBox(
                                    height: defaultPadding * 3,
                                  ),
                                  Center(
                                    child: BotaoPadrao(
                                      context: context,
                                      title: 'Salvar',
                                      onPressed: () {},
                                    ),
                                  )
                                ],
                              )),
                        ),
                      ],
                    ),
                  ));
      } else {
        return const Center();
      }
    });
  }
}
