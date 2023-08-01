// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/botao_padrao.dart';
import 'package:maca_ipe/componetes_gerais/campo_retorno.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/datas/embalagem.dart';
import 'package:maca_ipe/datas/fruta.dart';
import 'package:maca_ipe/datas/produtor.dart';
import 'package:maca_ipe/datas/romaneio.dart';
import 'package:maca_ipe/datas/romaneio_cp.dart';
import 'package:maca_ipe/funcoes/banco_de_dados.dart';
import 'package:maca_ipe/screens/romaneio/card_romaneio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RomaneioCPDesktop extends StatefulWidget {
  const RomaneioCPDesktop(
      {Key? key, required this.textControllers, required this.frutaR})
      : super(key: key);

  final List<TextEditingController> textControllers;
  final String frutaR;
  @override
  State<RomaneioCPDesktop> createState() => _RomaneioCPDesktopState();
}

class _RomaneioCPDesktopState extends State<RomaneioCPDesktop> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late List<Fruta> frutas;
  late List<Embalagem> embalagens;
  late List<Produtor> produtores;

  Fruta? _frutaSelecionada;
  Embalagem? _embalagemSelecionada;
  Produtor? _produtorSelecionado;

  final client = Supabase.instance.client;

  Future<List<Fruta>> fetchFrutas(SupabaseClient client) async {
    final frutasJson = await client
        .from("Fruta")
        .select()
        .eq('Nome', widget.frutaR)
        .order('Nome', ascending: true)
        .order('Variedade', ascending: true);
    return parseFrutas(frutasJson);
  }

  Future<List<Embalagem>> fetchEmbalagens(SupabaseClient client) async {
    final embalagensJson =
        await client.from("Embalagem").select().order('Nome', ascending: true);
    return parseEmbalagem(embalagensJson);
  }

  Future<List<Produtor>> fetchProdutores(SupabaseClient client) async {
    final produtoresJson = await client
        .from("Produtor")
        .select()
        .order('Nome', ascending: true)
        .order('Sobrenome', ascending: true);
    return parseProdutor(produtoresJson);
  }

  List<Embalagem> parseEmbalagem(List<dynamic> responseBody) {
    List<Embalagem> embalagemList =
        responseBody.map((item) => Embalagem.fromJson(item)).toList();
    return embalagemList;
  }

  List<Fruta> parseFrutas(List<dynamic> responseBody) {
    List<Fruta> frutasList =
        responseBody.map((item) => Fruta.fromJson(item)).toList();
    return frutasList;
  }

  List<Produtor> parseProdutor(List<dynamic> responseBody) {
    List<Produtor> produtorList =
        responseBody.map((item) => Produtor.fromJson(item)).toList();
    return produtorList;
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
                        SizedBox(
                          width: const BoxConstraints().maxWidth / 3,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                flex: 1,
                                child: FutureBuilder<List<Fruta>>(
                                    future: fetchFrutas(client),
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
  }
}
