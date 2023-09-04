// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/app_bar.dart';
import 'package:maca_ipe/componetes_gerais/botao_padrao.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/datas/estoque.dart';
import 'package:maca_ipe/datas/estoque_lista.dart';
import 'package:maca_ipe/datas/palete.dart';
import 'package:maca_ipe/funcoes/banco_de_dados.dart';
import 'package:maca_ipe/funcoes/responsive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PaleteNovoConfirm extends StatefulWidget {
  PaleteNovoConfirm({Key? key, required this.estoqueSelecionado})
      : super(key: key);

  List<EstoqueListaC> estoqueSelecionado;

  @override
  State<PaleteNovoConfirm> createState() => _PaleteNovoConfirmState();
}

class _PaleteNovoConfirmState extends State<PaleteNovoConfirm> {
  final client = Supabase.instance.client;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Palete confirmação'),
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: SingleChildScrollView(
          child: SizedBox(
            width: Responsive.isDesktop(context) ? 700 : double.infinity,
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Center(
                    child: Column(
                      children: [
                        ...widget.estoqueSelecionado
                            .map((e) => Column(
                                  children: [
                                    const SizedBox(
                                      height: defaultPadding,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                              ("${e.fruta.nome} ${e.fruta.variedade} ") +
                                                  (e.fruta.nome == "Maçã"
                                                      ? e.categoria
                                                      : "") +
                                                  (e.calibre == '1'
                                                      ? ""
                                                      : ' - ${e.calibre}')),
                                        ),
                                        const SizedBox(
                                          width: defaultPadding,
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: TextFormField(
                                            initialValue:
                                                e.quantidade.toString(),
                                            keyboardType: TextInputType.number,
                                            onChanged: (value) {
                                              setState(() {
                                                e.quantidade =
                                                    double.parse(value);
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ))
                            .toList(),
                        const SizedBox(
                          height: defaultPadding,
                        ),
                        const Text(
                          "Palete:",
                          style: TextStyle(fontSize: fontTitle),
                        ),
                        const SizedBox(
                          height: defaultPadding,
                        ),
                        ...widget.estoqueSelecionado
                            .map((ele) => Text(
                                ("${ele.fruta.nome} ${ele.fruta.variedade} ") +
                                    (ele.fruta.nome == "Maçã"
                                        ? ele.categoria
                                        : "") +
                                    (ele.calibre == '1'
                                        ? " -"
                                        : ' - ${ele.calibre} - ') +
                                    ele.quantidade.toString()))
                            .toList(),
                        const SizedBox(
                          height: defaultPadding,
                        ),
                        widget.estoqueSelecionado.isNotEmpty
                            ? BotaoPadrao(
                                context: context,
                                title: 'Selecionar',
                                onPressed: _cadastro,
                              )
                            : const Center(),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _cadastro() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<EstoqueC> estoqueCad = [];
      for (var ele in widget.estoqueSelecionado) {
        estoqueCad.add(EstoqueC(
            id: ele.id,
            frutaId: ele.fruta.id,
            quantidade: int.parse(ele.quantidade.toString()),
            calibre: ele.calibre,
            categoria: ele.categoria));
      }
      await createPalete(
          client,
          estoqueCad,
          Palete(id: 1, carga: 0, data: DateTime.now(), carregado: false),
          context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text(
          "Palete criado com sucesso",
          style: TextStyle(color: textColor),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ));
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Ocorreu um erro, tente novamente!"),
        backgroundColor: Theme.of(context).colorScheme.error,
      ));
      setState(() {
        _isLoading = false;
      });
    }
  }
}
