// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/app_bar.dart';
import 'package:maca_ipe/componetes_gerais/botao_padrao.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/datas/classifi_lista.dart';
import 'package:maca_ipe/datas/romaneio_lista.dart';
import 'package:maca_ipe/screens/romaneio/lista_romaneios.dart';
import 'package:maca_ipe/screens/romaneio/romaneio_completo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ClassifiRomaneio extends StatefulWidget {
  const ClassifiRomaneio({Key? key, required this.classifi}) : super(key: key);

  final ClassifiLista classifi;

  @override
  State<ClassifiRomaneio> createState() => _ClassifiRomaneioState();
}

class _ClassifiRomaneioState extends State<ClassifiRomaneio> {
  final client = Supabase.instance.client;
  List<RomaneioLista> romaneioLista = [];
  bool _isloading = false;
  final _formKey = GlobalKey<FormState>();
  final _romaneio = TextEditingController();

  Future<List<RomaneioLista>> buscarRomaneio(SupabaseClient client) async {
    final romaneioJson = await client
        .from('Romaneio')
        .select(
            'id, Fruta(id, Nome, Variedade), Embalagem(id, Nome), Data, Produtor(id, Nome, Sobrenome), TFruta')
        .eq('id', widget.classifi.romaneioId);

    return parseRomaneioJson(romaneioJson);
  }

  List<RomaneioLista> parseRomaneioJson(List<dynamic> responseBody) {
    List<RomaneioLista> romaneio =
        responseBody.map((e) => RomaneioLista.fromJson(e)).toList();
    return romaneio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Romaneio'),
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Container(
          padding: const EdgeInsets.all(defaultPadding),
          decoration: const BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: _isloading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SizedBox(
                  width: double.infinity,
                  child: FutureBuilder<List<RomaneioLista>>(
                      future: buscarRomaneio(client),
                      builder: ((context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasData) {
                          romaneioLista = snapshot.data!;
                          if (romaneioLista.isEmpty) {
                            return Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    BotaoPadrao(
                                        context: context,
                                        title: 'Lista Romaneios',
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const ListaRomaneios()),
                                          );
                                        }),
                                    const SizedBox(
                                      height: defaultPadding,
                                    ),
                                    TextFormField(
                                      decoration: const InputDecoration(
                                        labelText:
                                            'Informe o número do Romaneio',
                                      ),
                                      controller: _romaneio,
                                      validator: (value) {
                                        if (value?.isEmpty ?? true) {
                                          return 'Por favor, preencha este campo';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(
                                      height: defaultPadding,
                                    ),
                                    BotaoPadrao(
                                      context: context,
                                      title: 'Salvar',
                                      onPressed: () {
                                        _salvar();
                                      },
                                    )
                                  ],
                                ));
                          } else {
                            return Center(
                              child: BotaoPadrao(
                                  context: context,
                                  title: 'Ver Romaneio detalhado',
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RomaneioCompleto(
                                                romaneio: romaneioLista[0],
                                              )),
                                    );
                                  }),
                            );
                          }
                        } else {
                          return const Center(
                            child: Text("Erro ao retornar dados"),
                          );
                        }
                      })),
                ),
        ),
      ),
    );
  }

  Future<void> _salvar() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isloading = true;
      });
      try {
        await client.from('Classificacao').update(
            {'RomaneioId': _romaneio.text}).eq('id', widget.classifi.id);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              "Romaneio incluido com sucesso",
              style: TextStyle(color: textColor),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
        setState(() {
          _isloading = false;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("Ocorreu um erro, tente novamente!"),
          backgroundColor: Theme.of(context).colorScheme.error,
        ));
        setState(() {
          _isloading = false;
        });
      }
    }
  }
}
