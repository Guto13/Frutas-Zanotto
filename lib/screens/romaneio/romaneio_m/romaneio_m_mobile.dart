// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/botao_padrao.dart';
import 'package:maca_ipe/componetes_gerais/campo_retorno.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/componetes_gerais/future_drop_fruta.dart';
import 'package:maca_ipe/componetes_gerais/future_drop_produtor.dart';
import 'package:maca_ipe/datas/embalagem.dart';
import 'package:maca_ipe/datas/fruta.dart';
import 'package:maca_ipe/datas/produtor.dart';
import 'package:maca_ipe/datas/romaneio.dart';
import 'package:maca_ipe/datas/romaneio_m.dart';
import 'package:maca_ipe/funcoes/banco_de_dados.dart';
import 'package:maca_ipe/screens/romaneio/card_romaneio.dart';
import 'package:maca_ipe/screens/romaneio/lista_romaneios.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../componetes_gerais/future_drop_embalagem.dart';

class RomaneioMMobile extends StatefulWidget {
  const RomaneioMMobile({
    Key? key,
    required this.textControllers,
  }) : super(key: key);

  final List<TextEditingController> textControllers;

  @override
  State<RomaneioMMobile> createState() => _RomaneioMMobileState();
}

class _RomaneioMMobileState extends State<RomaneioMMobile> {
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Cat1',
                              style: TextStyle(fontSize: fontTitle),
                            ),
                            const SizedBox(height: defaultPadding),
                            CardRomaneio(
                                controller: widget.textControllers[0],
                                name: '220'),
                            CardRomaneio(
                                controller: widget.textControllers[1],
                                name: '198'),
                            CardRomaneio(
                                controller: widget.textControllers[2],
                                name: '180'),
                            CardRomaneio(
                                controller: widget.textControllers[3],
                                name: '165'),
                            CardRomaneio(
                                controller: widget.textControllers[4],
                                name: '150'),
                            CardRomaneio(
                                controller: widget.textControllers[5],
                                name: '135'),
                            CardRomaneio(
                                controller: widget.textControllers[6],
                                name: '120'),
                            CardRomaneio(
                                controller: widget.textControllers[7],
                                name: '110'),
                            CardRomaneio(
                                controller: widget.textControllers[8],
                                name: '100'),
                            CardRomaneio(
                                controller: widget.textControllers[9],
                                name: '90'),
                            CardRomaneio(
                                controller: widget.textControllers[10],
                                name: '80'),
                            CardRomaneio(
                                controller: widget.textControllers[11],
                                name: '70'),
                          ],
                        ),
                        const SizedBox(
                          height: defaultPadding,
                        ),
                        const Text(
                          'Cat2',
                          style: TextStyle(fontSize: fontTitle),
                        ),
                        const SizedBox(height: defaultPadding),
                        CardRomaneio(
                            controller: widget.textControllers[12],
                            name: '180'),
                        CardRomaneio(
                            controller: widget.textControllers[13],
                            name: '165'),
                        CardRomaneio(
                            controller: widget.textControllers[14],
                            name: '150'),
                        CardRomaneio(
                            controller: widget.textControllers[15],
                            name: '135'),
                        CardRomaneio(
                            controller: widget.textControllers[16],
                            name: '120'),
                        CardRomaneio(
                            controller: widget.textControllers[17],
                            name: '110'),
                        CardRomaneio(
                            controller: widget.textControllers[18],
                            name: '100'),
                        CardRomaneio(
                            controller: widget.textControllers[19], name: '90'),
                        CardRomaneio(
                            controller: widget.textControllers[20], name: '80'),
                        CardRomaneio(
                            controller: widget.textControllers[21], name: '70'),
                        CardRomaneio(
                            controller: widget.textControllers[22],
                            name: 'Com'),
                        const SizedBox(height: defaultPadding),
                        BotaoPadrao(
                            context: context,
                            title: 'Salvar',
                            onPressed: _salvar),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _salvar() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
    }

    Romaneio romaneio = Romaneio(
        id: 1,
        frutaId: _frutaSelecionada!.id,
        embalagemId: _embalagemSelecionada!.id,
        tFruta: "RomaneioM",
        data: DateTime.now(),
        produtorId: _produtorSelecionado!.id);

    RomaneioM romaneioM = RomaneioM(
        id: 1,
        romaneioId: 1,
        c2201: int.tryParse(widget.textControllers[0].text) ?? 0,
        c1981: int.tryParse(widget.textControllers[1].text) ?? 0,
        c1801: int.tryParse(widget.textControllers[2].text) ?? 0,
        c1651: int.tryParse(widget.textControllers[3].text) ?? 0,
        c1501: int.tryParse(widget.textControllers[4].text) ?? 0,
        c1351: int.tryParse(widget.textControllers[5].text) ?? 0,
        c1201: int.tryParse(widget.textControllers[6].text) ?? 0,
        c1101: int.tryParse(widget.textControllers[7].text) ?? 0,
        c1001: int.tryParse(widget.textControllers[8].text) ?? 0,
        c901: int.tryParse(widget.textControllers[9].text) ?? 0,
        c801: int.tryParse(widget.textControllers[10].text) ?? 0,
        c701: int.tryParse(widget.textControllers[11].text) ?? 0,
        c1802: int.tryParse(widget.textControllers[12].text) ?? 0,
        c1652: int.tryParse(widget.textControllers[13].text) ?? 0,
        c1502: int.tryParse(widget.textControllers[14].text) ?? 0,
        c1352: int.tryParse(widget.textControllers[15].text) ?? 0,
        c1202: int.tryParse(widget.textControllers[16].text) ?? 0,
        c1102: int.tryParse(widget.textControllers[17].text) ?? 0,
        c1002: int.tryParse(widget.textControllers[18].text) ?? 0,
        c902: int.tryParse(widget.textControllers[19].text) ?? 0,
        c802: int.tryParse(widget.textControllers[20].text) ?? 0,
        c702: int.tryParse(widget.textControllers[21].text) ?? 0,
        comercial: int.tryParse(widget.textControllers[22].text) ?? 0);

    await cadastrarRomaneioM(client, romaneio, romaneioM, context);

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
