// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/botao_padrao.dart';
import 'package:maca_ipe/componetes_gerais/campo_retorno.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/componetes_gerais/future_drop_embalagem.dart';
import 'package:maca_ipe/componetes_gerais/future_drop_fruta.dart';
import 'package:maca_ipe/componetes_gerais/future_drop_produtor.dart';
import 'package:maca_ipe/datas/embalagem.dart';
import 'package:maca_ipe/datas/fruta.dart';
import 'package:maca_ipe/datas/produtor.dart';
import 'package:maca_ipe/datas/romaneio.dart';
import 'package:maca_ipe/datas/romaneio_pa.dart';
import 'package:maca_ipe/funcoes/banco_de_dados.dart';
import 'package:maca_ipe/screens/romaneio/card_romaneio.dart';
import 'package:maca_ipe/screens/romaneio/lista_romaneios.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RomaneioPAMobile extends StatefulWidget {
  const RomaneioPAMobile(
      {Key? key, required this.textControllers, required this.frutaR})
      : super(key: key);

  final List<TextEditingController> textControllers;
  final String frutaR;

  @override
  State<RomaneioPAMobile> createState() => _RomaneioPAMobileState();
}

class _RomaneioPAMobileState extends State<RomaneioPAMobile> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Fruta? _frutaSelecionada;
  Embalagem? _embalagemSelecionada;
  Produtor? _produtorSelecionado;

  final client = Supabase.instance.client;

  void handleFrutaSelected(Fruta fruta) {
    setState(() {
      _frutaSelecionada = fruta;
    });
  }

  void handleEmbalSelected(Embalagem embalagem) {
    setState(() {
      _embalagemSelecionada = embalagem;
    });
  }

  void handleProdutorSelected(Produtor produtor) {
    setState(() {
      _produtorSelecionado = produtor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.all(defaultPadding),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          FutureDropFruta(
                            client: client,
                            onFrutaSelected: handleFrutaSelected,
                          ),
                          const SizedBox(
                            height: defaultPadding,
                          ),
                          CampoRetorno(
                            controller: TextEditingController(
                                text: _frutaSelecionada?.nomeVariedade),
                            label: 'Fruta',
                          ),
                          const SizedBox(
                            height: defaultPadding,
                          ),
                          FutureDropEmbalagem(
                            client: client,
                            onEmbalagemSelected: handleEmbalSelected,
                          ),
                          const SizedBox(
                            height: defaultPadding,
                          ),
                          CampoRetorno(
                            controller: TextEditingController(
                                text: _embalagemSelecionada?.nomePeso),
                            label: 'Embalagem',
                          ),
                          const SizedBox(
                            height: defaultPadding,
                          ),
                          FutureDropProdutor(
                            client: client,
                            onProdutorSelect: handleProdutorSelected,
                          ),
                          const SizedBox(
                            height: defaultPadding,
                          ),
                          CampoRetorno(
                            controller: TextEditingController(
                                text: _produtorSelecionado?.nomeCompleto),
                            label: 'Produtor',
                          ),
                          const SizedBox(
                            height: defaultPadding,
                          ),
                          const Text(
                            'Preencha as quantidades abaixo',
                            style: TextStyle(fontSize: fontTitle),
                          ),
                          const SizedBox(height: defaultPadding),
                          CardRomaneio(
                              controller: widget.textControllers[0],
                              name: 'Granel'),
                          CardRomaneio(
                              controller: widget.textControllers[1],
                              name: '40'),
                          CardRomaneio(
                              controller: widget.textControllers[2],
                              name: '36'),
                          CardRomaneio(
                              controller: widget.textControllers[3],
                              name: '32'),
                          CardRomaneio(
                              controller: widget.textControllers[4],
                              name: '30'),
                          CardRomaneio(
                              controller: widget.textControllers[5],
                              name: '28'),
                          CardRomaneio(
                              controller: widget.textControllers[6],
                              name: '24'),
                          CardRomaneio(
                              controller: widget.textControllers[7],
                              name: '22'),
                          CardRomaneio(
                              controller: widget.textControllers[8],
                              name: '20'),
                          CardRomaneio(
                              controller: widget.textControllers[9],
                              name: '18'),
                          CardRomaneio(
                              controller: widget.textControllers[10],
                              name: '14'),
                          CardRomaneio(
                              controller: widget.textControllers[11],
                              name: '12'),
                          CardRomaneio(
                              controller: widget.textControllers[12],
                              name: 'Cat2'),
                          const SizedBox(height: defaultPadding),
                          BotaoPadrao(
                              context: context,
                              title: 'Salvar',
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  _salvar();
                                }
                              }),
                        ],
                      ),
                    ),
            ),
          ),
        ));
  }

  Future<void> _salvar() async {
    Romaneio romaneio = Romaneio(
        id: 1,
        frutaId: _frutaSelecionada!.id,
        embalagemId: _embalagemSelecionada!.id,
        tFruta: "RomaneioPA",
        data: DateTime.now(),
        produtorId: _produtorSelecionado!.id);

    RomaneioPa romaneioPa = RomaneioPa(
        id: 1,
        romaneioId: 1,
        c45: int.tryParse(widget.textControllers[0].text) ?? 0,
        c40: int.tryParse(widget.textControllers[1].text) ?? 0,
        c36: int.tryParse(widget.textControllers[2].text) ?? 0,
        c32: int.tryParse(widget.textControllers[3].text) ?? 0,
        c30: int.tryParse(widget.textControllers[4].text) ?? 0,
        c28: int.tryParse(widget.textControllers[5].text) ?? 0,
        c24: int.tryParse(widget.textControllers[6].text) ?? 0,
        c22: int.tryParse(widget.textControllers[7].text) ?? 0,
        c20: int.tryParse(widget.textControllers[8].text) ?? 0,
        c18: int.tryParse(widget.textControllers[9].text) ?? 0,
        c14: int.tryParse(widget.textControllers[10].text) ?? 0,
        c12: int.tryParse(widget.textControllers[11].text) ?? 0,
        cat2: int.tryParse(widget.textControllers[12].text) ?? 0);

    await cadastrarRomaneioPA(client, romaneio, romaneioPa, context);

    setState(() {
      _isLoading = false;
      for (var element in widget.textControllers) {
        element.clear();
      }
      _embalagemSelecionada = null;
      _frutaSelecionada = null;
      _produtorSelecionado = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          "Romaneio cadastrado com sucesso",
          style: TextStyle(color: textColor),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ListaRomaneios()),
    );
  }
}
