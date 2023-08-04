// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/botao_padrao.dart';
import 'package:maca_ipe/componetes_gerais/campo_retorno.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/datas/embalagem.dart';
import 'package:maca_ipe/datas/fruta.dart';
import 'package:maca_ipe/datas/produtor.dart';
import 'package:maca_ipe/datas/romaneio.dart';
import 'package:maca_ipe/datas/romaneio_m.dart';
import 'package:maca_ipe/funcoes/banco_de_dados.dart';
import 'package:maca_ipe/screens/romaneio/card_romaneio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RomaneioMDesktop extends StatefulWidget {
  const RomaneioMDesktop({
    Key? key,
    required this.textControllers,
  }) : super(key: key);

  final List<TextEditingController> textControllers;

  @override
  State<RomaneioMDesktop> createState() => _RomaneioMDesktopState();
}

class _RomaneioMDesktopState extends State<RomaneioMDesktop> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late List<Fruta> frutas;
  late List<Embalagem> embalagens;
  late List<Produtor> produtores;

  Fruta? _frutaSelecionada;
  Embalagem? _embalagemSelecionada;
  Produtor? _produtorSelecionado;

  final client = Supabase.instance.client;

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
                        SizedBox(
                          width: const BoxConstraints().maxWidth / 3,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                flex: 1,
                                child: FutureBuilder<List<Fruta>>(
                                    future: fetchFrutas(client, 'Maçã', ''),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else if (snapshot.hasError) {
                                        return Center(
                                          child:
                                              Text('Error: ${snapshot.error}'),
                                        );
                                      } else {
                                        frutas = snapshot.data!;
                                        return DropdownButton<Fruta>(
                                          hint:
                                              const Text("Selecione uma Fruta"),
                                          items: frutas.map((Fruta fruta) {
                                            return DropdownMenuItem<Fruta>(
                                              value: fruta,
                                              child: Text(fruta.nomeVariedade),
                                            );
                                          }).toList(),
                                          onChanged: (Fruta? value) {
                                            setState(() {
                                              _frutaSelecionada = value!;
                                            });
                                          },
                                        );
                                      }
                                    }),
                              ),
                              const SizedBox(
                                width: defaultPadding * 2,
                              ),
                              Expanded(
                                flex: 1,
                                child: FutureBuilder<List<Embalagem>>(
                                    future: fetchEmbalagens(client),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else if (snapshot.hasError) {
                                        return Center(
                                          child:
                                              Text('Error: ${snapshot.error}'),
                                        );
                                      } else {
                                        embalagens = snapshot.data!;
                                        return DropdownButton<Embalagem>(
                                          hint: const Text(
                                              "Selecione uma Embalagem"),
                                          items: embalagens
                                              .map((Embalagem embalagem) {
                                            return DropdownMenuItem<Embalagem>(
                                              value: embalagem,
                                              child: Text(embalagem.nomePeso),
                                            );
                                          }).toList(),
                                          onChanged: (Embalagem? value) {
                                            setState(() {
                                              _embalagemSelecionada = value;
                                            });
                                          },
                                        );
                                      }
                                    }),
                              ),
                              Expanded(
                                flex: 1,
                                child: FutureBuilder<List<Produtor>>(
                                    future: fetchProdutores(client),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else if (snapshot.hasError) {
                                        return Center(
                                          child:
                                              Text('Error: ${snapshot.error}'),
                                        );
                                      } else {
                                        produtores = snapshot.data!;
                                        return DropdownButton<Produtor>(
                                          hint: const Text(
                                              "Selecione um Produtor"),
                                          items: produtores
                                              .map((Produtor produtor) {
                                            return DropdownMenuItem<Produtor>(
                                              value: produtor,
                                              child:
                                                  Text(produtor.nomeCompleto),
                                            );
                                          }).toList(),
                                          onChanged: (Produtor? value) {
                                            setState(() {
                                              _produtorSelecionado = value;
                                            });
                                          },
                                        );
                                      }
                                    }),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: defaultPadding,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              flex: 1,
                              child: CampoRetorno(
                                controller: TextEditingController(
                                    text: _frutaSelecionada?.nomeVariedade),
                                label: 'Fruta',
                              ),
                            ),
                            const SizedBox(
                              width: defaultPadding * 2,
                            ),
                            Expanded(
                              flex: 1,
                              child: CampoRetorno(
                                controller: TextEditingController(
                                    text: _embalagemSelecionada?.nomePeso),
                                label: 'Embalagem',
                              ),
                            ),
                            const SizedBox(
                              width: defaultPadding * 2,
                            ),
                            Expanded(
                              flex: 1,
                              child: CampoRetorno(
                                controller: TextEditingController(
                                    text: _produtorSelecionado?.nomeCompleto),
                                label: 'Produtor',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: defaultPadding,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
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
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
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
                                      controller: widget.textControllers[19],
                                      name: '90'),
                                  CardRomaneio(
                                      controller: widget.textControllers[20],
                                      name: '80'),
                                  CardRomaneio(
                                      controller: widget.textControllers[21],
                                      name: '70'),
                                  CardRomaneio(
                                      controller: widget.textControllers[22],
                                      name: 'Com'),
                                ],
                              ),
                            ),
                          ],
                        ),
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
  }
}
