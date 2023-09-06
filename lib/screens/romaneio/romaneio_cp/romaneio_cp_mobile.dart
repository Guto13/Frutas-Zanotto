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
import 'package:maca_ipe/datas/romaneio_cp.dart';
import 'package:maca_ipe/funcoes/banco_de_dados.dart';
import 'package:maca_ipe/screens/romaneio/card_romaneio.dart';
import 'package:maca_ipe/screens/romaneio/lista_romaneios.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RomaneioCPMobile extends StatefulWidget {
  const RomaneioCPMobile(
      {Key? key, required this.textControllers, required this.frutaR})
      : super(key: key);

  final List<TextEditingController> textControllers;
  final String frutaR;
  @override
  State<RomaneioCPMobile> createState() => _RomaneioCPMobileState();
}

class _RomaneioCPMobileState extends State<RomaneioCPMobile> {
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
                      mainAxisAlignment: MainAxisAlignment.center,
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
                            controller: widget.textControllers[0], name: 'GG'),
                        CardRomaneio(
                            controller: widget.textControllers[1], name: 'G'),
                        CardRomaneio(
                            controller: widget.textControllers[2], name: 'M'),
                        CardRomaneio(
                            controller: widget.textControllers[3], name: 'P'),
                        CardRomaneio(
                            controller: widget.textControllers[4], name: 'PP'),
                        CardRomaneio(
                            controller: widget.textControllers[5],
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
      ),
    );
  }

  Future<void> _salvar() async {
    Romaneio romaneio = Romaneio(
        id: 1,
        frutaId: _frutaSelecionada!.id,
        embalagemId: _embalagemSelecionada!.id,
        tFruta: "RomaneioCP",
        data: DateTime.now(),
        produtorId: _produtorSelecionado!.id);

    RomaneioCp romaneioCp = RomaneioCp(
        id: 1,
        romaneioId: 1,
        gg: int.tryParse(widget.textControllers[0].text) ?? 0,
        g: int.tryParse(widget.textControllers[1].text) ?? 0,
        m: int.tryParse(widget.textControllers[2].text) ?? 0,
        p: int.tryParse(widget.textControllers[3].text) ?? 0,
        pp: int.tryParse(widget.textControllers[4].text) ?? 0,
        cat2: int.tryParse(widget.textControllers[5].text) ?? 0);

    await cadastrarRomaneioCP(client, romaneio, romaneioCp, context);

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