// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/app_bar.dart';
import 'package:maca_ipe/componetes_gerais/botao_padrao.dart';
import 'package:maca_ipe/componetes_gerais/campo_retorno.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/datas/embalagem.dart';
import 'package:maca_ipe/datas/fruta.dart';
import 'package:maca_ipe/datas/palete.dart';
import 'package:maca_ipe/datas/palete_cp.dart';
import 'package:maca_ipe/datas/palete_m.dart';
import 'package:maca_ipe/datas/palete_o.dart';
import 'package:maca_ipe/datas/palete_pa.dart';
import 'package:maca_ipe/funcoes/banco_de_dados.dart';
import 'package:maca_ipe/screens/paletes/palete_outros.dart';
import 'package:maca_ipe/screens/paletes/palete_tabela.dart';
import 'package:maca_ipe/screens/romaneio/card_romaneio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../componetes_gerais/future_drop_embalagem.dart';
import '../../componetes_gerais/future_drop_fruta.dart';

class PaleteNovo extends StatefulWidget {
  const PaleteNovo({Key? key}) : super(key: key);

  @override
  State<PaleteNovo> createState() => _PaleteNovoState();
}

class _PaleteNovoState extends State<PaleteNovo> {
  //Maçã
  List<TextEditingController> textControllersM =
      List.generate(23, (_) => TextEditingController());
  bool _maca = false;
  String _frutaM = '';
  String _embalagemM = '';
  Fruta? _frutaSelecionadaM;
  Embalagem? _embalagemSelecionadaM;

  void handleFrutaSelectedM(Fruta fruta) {
    setState(() {
      _frutaSelecionadaM = fruta;
      _frutaM = _frutaSelecionadaM!.nomeVariedade;
    });
  }

  void handleEmbalSelectedM(Embalagem embalagem) {
    setState(() {
      _embalagemSelecionadaM = embalagem;
      _embalagemM = _embalagemSelecionadaM!.nome;
    });
  }

  //Ameixa e Pêssego
  List<TextEditingController> textControllersPA =
      List.generate(13, (_) => TextEditingController());
  bool _ameipesse = false;
  String _frutaPA = '';
  String _embalagemPA = '';
  Fruta? _frutaSelecionadaPA;
  Embalagem? _embalagemSelecionadaPA;

  void handleFrutaSelectedPA(Fruta fruta) {
    setState(() {
      _frutaSelecionadaPA = fruta;
      _frutaPA = _frutaSelecionadaPA!.nomeVariedade;
    });
  }

  void handleEmbalSelectedPA(Embalagem embalagem) {
    setState(() {
      _embalagemSelecionadaPA = embalagem;
      _embalagemPA = _embalagemSelecionadaPA!.nome;
    });
  }

  //Caqui e Pêra
  List<TextEditingController> textControllersCP =
      List.generate(6, (_) => TextEditingController());
  bool _peracaqui = false;
  String _frutaCP = '';
  String _embalagemCP = '';
  Fruta? _frutaSelecionadaCP;
  Embalagem? _embalagemSelecionadaCP;

  void handleFrutaSelectedCP(Fruta fruta) {
    setState(() {
      _frutaSelecionadaCP = fruta;
      _frutaCP = _frutaSelecionadaCP!.nomeVariedade;
    });
  }

  void handleEmbalSelectedCP(Embalagem embalagem) {
    setState(() {
      _embalagemSelecionadaCP = embalagem;
      _embalagemCP = _embalagemSelecionadaCP!.nome;
    });
  }

  //Outro1
  final _nameController1 = TextEditingController();
  final _quantController1 = TextEditingController();
  final _embalController1 = TextEditingController();
  bool _outro = false;

  //Outro2
  final _nameController2 = TextEditingController();
  final _quantController2 = TextEditingController();
  final _embalController2 = TextEditingController();
  bool _outro2 = false;

  bool _isLoading = false;
  late List<Embalagem> embalagens;
  final client = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Novo Palete'),
      body: SingleChildScrollView(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Container(
                  padding: const EdgeInsets.all(defaultPadding),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Maçã',
                                style: TextStyle(fontSize: fontTitle),
                              ),
                            ),
                            const Spacer(),
                            Checkbox(
                              value: _maca,
                              onChanged: (bool? value) {
                                setState(() {
                                  _maca = value!;
                                });
                              },
                            )
                          ],
                        ),
                        _maca ? paleteMaca() : const Center(),
                        const Divider(),
                        const SizedBox(
                          height: defaultPadding,
                        ),

                        //Ameixa ou Pêssego
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Ameixa ou Pêssego',
                                style: TextStyle(fontSize: fontTitle),
                              ),
                            ),
                            const Spacer(),
                            Checkbox(
                              value: _ameipesse,
                              onChanged: (bool? value) {
                                setState(() {
                                  _ameipesse = value!;
                                });
                              },
                            )
                          ],
                        ),
                        _ameipesse ? paleteAmeixaPessego() : const Center(),
                        const Divider(),
                        const SizedBox(
                          height: defaultPadding,
                        ),
                        //Pêra ou Caqui
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Pêra ou Caqui',
                                style: TextStyle(fontSize: fontTitle),
                              ),
                            ),
                            const Spacer(),
                            Checkbox(
                              value: _peracaqui,
                              onChanged: (bool? value) {
                                setState(() {
                                  _peracaqui = value!;
                                });
                              },
                            )
                          ],
                        ),
                        _peracaqui ? paletePeraCaqui() : const Center(),
                        const Divider(),
                        const SizedBox(
                          height: defaultPadding,
                        ),
                        //Outros
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Outro',
                                style: TextStyle(fontSize: fontTitle),
                              ),
                            ),
                            const Spacer(),
                            Checkbox(
                              value: _outro,
                              onChanged: (bool? value) {
                                setState(() {
                                  _outro = value!;
                                });
                              },
                            )
                          ],
                        ),
                        _outro
                            ? PaleteOutros(
                                nameController: _nameController1,
                                quantController: _quantController1,
                                embalController: _embalController1)
                            : const Center(),
                        const Divider(),
                        const SizedBox(
                          height: defaultPadding,
                        ),
                        //Outros 2
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Outro 2',
                                style: TextStyle(fontSize: fontTitle),
                              ),
                            ),
                            const Spacer(),
                            Checkbox(
                              value: _outro2,
                              onChanged: (bool? value) {
                                setState(() {
                                  _outro2 = value!;
                                });
                              },
                            )
                          ],
                        ),
                        _outro2
                            ? PaleteOutros(
                                nameController: _nameController2,
                                quantController: _quantController2,
                                embalController: _embalController2)
                            : const Center(),
                        const Divider(),
                        const SizedBox(
                          height: defaultPadding * 2,
                        ),
                        Center(
                            child: BotaoPadrao(
                          context: context,
                          title: 'Salvar',
                          onPressed: (() {
                            if (_maca == true ||
                                _ameipesse == true ||
                                _peracaqui == true ||
                                _outro == true ||
                                _outro2 == true) {
                              _salvar();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    'Selecione ao menos um tipo de fruta para o palete',
                                    style: TextStyle(color: textColor),
                                  ),
                                  backgroundColor:
                                      Theme.of(context).colorScheme.error,
                                ),
                              );
                            }
                          }),
                        ))
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  //Parte que lida com o palete de Caqui e Pêra
  Column paletePeraCaqui() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisSize: MainAxisSize.min, children: [
            Expanded(
              flex: 1,
              child: FutureDropFruta(
                client: client,
                onFrutaSelected: handleFrutaSelectedCP,
                fruta1: 'Caqui',
                fruta2: 'Pêra',
              ),
            ),
            const SizedBox(
              width: defaultPadding * 2,
            ),
            Expanded(
              flex: 1,
              child: FutureDropEmbalagem(
                client: client,
                onEmbalagemSelected: handleEmbalSelectedCP,
              ),
            ),
          ]),
          const SizedBox(
            height: defaultPadding,
          ),
          Row(mainAxisSize: MainAxisSize.min, children: [
            Expanded(
              flex: 1,
              child: CampoRetorno(
                controller: TextEditingController(
                    text: _frutaSelecionadaCP?.nomeVariedade),
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
                    text: _embalagemSelecionadaCP?.nomePeso),
                label: 'Embalagem',
              ),
            ),
          ]),
          const SizedBox(height: defaultPadding),
          CardRomaneio(controller: textControllersCP[0], name: 'GG'),
          CardRomaneio(controller: textControllersCP[1], name: 'G'),
          CardRomaneio(controller: textControllersCP[2], name: 'M'),
          CardRomaneio(controller: textControllersCP[3], name: 'P'),
          CardRomaneio(controller: textControllersCP[4], name: 'PP'),
          CardRomaneio(controller: textControllersCP[5], name: 'Cat2'),
          const SizedBox(height: defaultPadding),
        ]);
  }

  //Parte que lida com o palete de Ameixa e Pêssego
  Column paleteAmeixaPessego() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisSize: MainAxisSize.min, children: [
            Expanded(
              flex: 1,
              child: FutureDropFruta(
                client: client,
                onFrutaSelected: handleFrutaSelectedPA,
                fruta1: 'Ameixa',
                fruta2: 'Pêssego',
              ),
            ),
            const SizedBox(
              width: defaultPadding * 2,
            ),
            Expanded(
              flex: 1,
              child: FutureDropEmbalagem(
                client: client,
                onEmbalagemSelected: handleEmbalSelectedPA,
              ),
            ),
          ]),
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
                      text: _frutaSelecionadaPA?.nomeVariedade),
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
                      text: _embalagemSelecionadaPA?.nomePeso),
                  label: 'Embalagem',
                ),
              ),
            ],
          ),
          const SizedBox(height: defaultPadding),
          CardRomaneio(controller: textControllersPA[0], name: 'Granel'),
          CardRomaneio(controller: textControllersPA[1], name: '40'),
          CardRomaneio(controller: textControllersPA[2], name: '36'),
          CardRomaneio(controller: textControllersPA[3], name: '32'),
          CardRomaneio(controller: textControllersPA[4], name: '30'),
          CardRomaneio(controller: textControllersPA[5], name: '28'),
          CardRomaneio(controller: textControllersPA[6], name: '24'),
          CardRomaneio(controller: textControllersPA[7], name: '22'),
          CardRomaneio(controller: textControllersPA[8], name: '20'),
          CardRomaneio(controller: textControllersPA[9], name: '18'),
          CardRomaneio(controller: textControllersPA[10], name: '14'),
          CardRomaneio(controller: textControllersPA[11], name: '12'),
          CardRomaneio(controller: textControllersPA[12], name: 'Cat2'),
          const SizedBox(height: defaultPadding),
        ]);
  }

  //Parte que lida com o palete de Maçã
  Column paleteMaca() {
    return Column(children: [
      Row(mainAxisSize: MainAxisSize.min, children: [
        Expanded(
          flex: 1,
          child: FutureDropFruta(
            client: client,
            onFrutaSelected: handleFrutaSelectedM,
            fruta1: 'Maçã',
          ),
        ),
        const SizedBox(
          width: defaultPadding * 2,
        ),
        Expanded(
          flex: 1,
          child: FutureDropEmbalagem(
            client: client,
            onEmbalagemSelected: handleEmbalSelectedM,
          ),
        ),
      ]),
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
                  text: _frutaSelecionadaM?.nomeVariedade),
              label: 'Fruta',
            ),
          ),
          const SizedBox(
            width: defaultPadding * 2,
          ),
          Expanded(
            flex: 1,
            child: CampoRetorno(
              controller:
                  TextEditingController(text: _embalagemSelecionadaM?.nomePeso),
              label: 'Embalagem',
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
                CardRomaneio(controller: textControllersM[0], name: '220'),
                CardRomaneio(controller: textControllersM[1], name: '198'),
                CardRomaneio(controller: textControllersM[2], name: '180'),
                CardRomaneio(controller: textControllersM[3], name: '165'),
                CardRomaneio(controller: textControllersM[4], name: '150'),
                CardRomaneio(controller: textControllersM[5], name: '135'),
                CardRomaneio(controller: textControllersM[6], name: '120'),
                CardRomaneio(controller: textControllersM[7], name: '110'),
                CardRomaneio(controller: textControllersM[8], name: '100'),
                CardRomaneio(controller: textControllersM[9], name: '90'),
                CardRomaneio(controller: textControllersM[10], name: '80'),
                CardRomaneio(controller: textControllersM[11], name: '70'),
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
                CardRomaneio(controller: textControllersM[12], name: '180'),
                CardRomaneio(controller: textControllersM[13], name: '165'),
                CardRomaneio(controller: textControllersM[14], name: '150'),
                CardRomaneio(controller: textControllersM[15], name: '135'),
                CardRomaneio(controller: textControllersM[16], name: '120'),
                CardRomaneio(controller: textControllersM[17], name: '110'),
                CardRomaneio(controller: textControllersM[18], name: '100'),
                CardRomaneio(controller: textControllersM[19], name: '90'),
                CardRomaneio(controller: textControllersM[20], name: '80'),
                CardRomaneio(controller: textControllersM[21], name: '70'),
                CardRomaneio(controller: textControllersM[22], name: 'Com'),
              ],
            ),
          ),
        ],
      ),
    ]);
  }

  //Parte dedicada a salvar os dados
  Future<void> _salvar() async {
    setState(() {
      _isLoading = true;
    });

    Palete palete =
        Palete(id: 0, carga: 0, data: DateTime.now(), carregado: false);
    try {
      final paleteData = await client
          .from('Palete')
          .insert(palete.toMap())
          .select('id, Carga, Data, Carregado');
      List<bool> checks = [_maca, _ameipesse, _peracaqui, _outro, _outro2];
      List<String> frutas = [
        _frutaM,
        _frutaPA,
        _frutaCP,
        _nameController1.text,
        _nameController2.text
      ];
      List<String> embalagens = [
        _embalagemM,
        _embalagemPA,
        _embalagemCP,
        _embalController1.text,
        _embalController2.text
      ];
      for (var i = 0; i < 4; i++) {
        if (checks[i] == true) {
          if (frutas[i].isEmpty || embalagens[i].isEmpty) {
            await client.from('Palete').delete().eq('id', paleteData[0]['id']);
            ScaffoldMessenger.of(context).showSnackBar(
              messFieldNull(),
            );
            setState(() {
              _isLoading = false;
            });
            return;
          }
        }
      }

      try {
        if (_maca == true) {
          _cadPaleteM(paleteData[0]['id']);
        }

        if (_ameipesse == true) {
          _cadPaletePA(paleteData[0]['id']);
        }

        if (_peracaqui == true) {
          _cadPaleteCP(paleteData[0]['id']);
        }

        if (_outro == true) {
          _cadPaleteO1(paleteData[0]['id']);
        }

        if (_outro2 == true) {
          _cadPaleteO2(paleteData[0]['id']);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              "Palete cadastrado com sucesso",
              style: TextStyle(color: textColor),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
        setState(() {
          _isLoading = false;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  PaleteTabela(palete: Palete.fromJson(paleteData[0]))),
        );
      } catch (e) {
        await client.from('Palete').delete().eq('id', paleteData[0]['id']);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString(),
              style: const TextStyle(color: textColor),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
            style: const TextStyle(color: textColor),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );

      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _cadPaleteM(int paleteId) async {
    try {
      PaleteM paletem = PaleteM(
          id: 0,
          frutaId: _frutaSelecionadaM!.id,
          embalagemId: _embalagemSelecionadaM!.id,
          paleteId: paleteId,
          c2201: int.tryParse(textControllersM[0].text) ?? 0,
          c1981: int.tryParse(textControllersM[1].text) ?? 0,
          c1801: int.tryParse(textControllersM[2].text) ?? 0,
          c1651: int.tryParse(textControllersM[3].text) ?? 0,
          c1501: int.tryParse(textControllersM[4].text) ?? 0,
          c1351: int.tryParse(textControllersM[5].text) ?? 0,
          c1201: int.tryParse(textControllersM[6].text) ?? 0,
          c1101: int.tryParse(textControllersM[7].text) ?? 0,
          c1001: int.tryParse(textControllersM[8].text) ?? 0,
          c901: int.tryParse(textControllersM[9].text) ?? 0,
          c801: int.tryParse(textControllersM[10].text) ?? 0,
          c701: int.tryParse(textControllersM[11].text) ?? 0,
          c1802: int.tryParse(textControllersM[12].text) ?? 0,
          c1652: int.tryParse(textControllersM[13].text) ?? 0,
          c1502: int.tryParse(textControllersM[14].text) ?? 0,
          c1352: int.tryParse(textControllersM[15].text) ?? 0,
          c1202: int.tryParse(textControllersM[16].text) ?? 0,
          c1102: int.tryParse(textControllersM[17].text) ?? 0,
          c1002: int.tryParse(textControllersM[18].text) ?? 0,
          c902: int.tryParse(textControllersM[19].text) ?? 0,
          c802: int.tryParse(textControllersM[20].text) ?? 0,
          c702: int.tryParse(textControllersM[21].text) ?? 0,
          comercial: int.tryParse(textControllersM[22].text) ?? 0);

      await cadastroPaleteM(client, paletem, context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
            style: const TextStyle(color: textColor),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Future<void> _cadPaletePA(int paleteId) async {
    try {
      PaletePA paletepa = PaletePA(
          id: 0,
          frutaId: _frutaSelecionadaPA!.id,
          embalagemId: _embalagemSelecionadaPA!.id,
          paleteId: paleteId,
          c45: int.tryParse(textControllersPA[0].text) ?? 0,
          c40: int.tryParse(textControllersPA[1].text) ?? 0,
          c36: int.tryParse(textControllersPA[2].text) ?? 0,
          c32: int.tryParse(textControllersPA[3].text) ?? 0,
          c30: int.tryParse(textControllersPA[4].text) ?? 0,
          c28: int.tryParse(textControllersPA[5].text) ?? 0,
          c24: int.tryParse(textControllersPA[6].text) ?? 0,
          c22: int.tryParse(textControllersPA[7].text) ?? 0,
          c20: int.tryParse(textControllersPA[8].text) ?? 0,
          c18: int.tryParse(textControllersPA[9].text) ?? 0,
          c14: int.tryParse(textControllersPA[10].text) ?? 0,
          c12: int.tryParse(textControllersPA[11].text) ?? 0,
          cat2: int.tryParse(textControllersPA[12].text) ?? 0);

      await cadastroPaletePA(client, paletepa, context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
            style: const TextStyle(color: textColor),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Future<void> _cadPaleteCP(int paleteId) async {
    try {
      PaleteCP paletecp = PaleteCP(
          id: 0,
          frutaId: _frutaSelecionadaCP!.id,
          embalagemId: _embalagemSelecionadaCP!.id,
          paleteId: paleteId,
          gg: int.tryParse(textControllersCP[0].text) ?? 0,
          g: int.tryParse(textControllersCP[1].text) ?? 0,
          m: int.tryParse(textControllersCP[2].text) ?? 0,
          p: int.tryParse(textControllersCP[3].text) ?? 0,
          pp: int.tryParse(textControllersCP[4].text) ?? 0,
          cat2: int.tryParse(textControllersCP[5].text) ?? 0);

      await cadastroPaleteCP(client, paletecp, context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
            style: const TextStyle(color: textColor),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Future<void> _cadPaleteO1(int paleteId) async {
    try {
      PaleteO paleteo1 = PaleteO(
          id: 0,
          embalagem: _embalController1.text,
          paleteId: paleteId,
          nome: _nameController1.text,
          quant: int.tryParse(_quantController1.text) ?? 0);

      await cadastroPaleteO(client, paleteo1, context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
            style: const TextStyle(color: textColor),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Future<void> _cadPaleteO2(int paleteId) async {
    try {
      PaleteO paleteo2 = PaleteO(
          id: 0,
          embalagem: _embalController2.text,
          paleteId: paleteId,
          nome: _nameController2.text,
          quant: int.tryParse(_quantController2.text) ?? 0);

      await cadastroPaleteO(client, paleteo2, context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
            style: const TextStyle(color: textColor),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  SnackBar messFieldNull() {
    return SnackBar(
      content: const Text(
        'Preencha todos os campos das áreas selecionadas',
        style: TextStyle(color: textColor),
      ),
      backgroundColor: Theme.of(context).colorScheme.error,
    );
  }
}
