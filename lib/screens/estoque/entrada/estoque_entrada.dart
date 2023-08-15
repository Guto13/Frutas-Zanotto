// ignore_for_file: prefer_final_fields, use_build_context_synchronously

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maca_ipe/componetes_gerais/app_bar.dart';
import 'package:maca_ipe/componetes_gerais/botao_padrao.dart';
import 'package:maca_ipe/componetes_gerais/campo_retorno.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/datas/embalagem.dart';
import 'package:maca_ipe/datas/entradas.dart';
import 'package:maca_ipe/datas/fruta.dart';
import 'package:maca_ipe/datas/produtor.dart';
import 'package:maca_ipe/funcoes/banco_de_dados.dart';
import 'package:maca_ipe/screens/estoque/entrada/tabela_entradas.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../componetes_gerais/future_drop_embalagem.dart';
import '../../../componetes_gerais/future_drop_fruta.dart';

class EntradaEstoque extends StatefulWidget {
  const EntradaEstoque({Key? key}) : super(key: key);

  @override
  State<EntradaEstoque> createState() => _EntradaEstoqueState();
}

class _EntradaEstoqueState extends State<EntradaEstoque> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  DateTime _data = DateTime.now();
  final _quant = TextEditingController();
  late List<Produtor> produtores;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Entrada Produtos"),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(),
              ),
              const Spacer(),
              BotaoPadrao(context: context, title: 'Editar', onPressed: () {}),
              BotaoPadrao(
                context: context,
                title: 'Entradas',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TabelaEntrada()),
                ),
              ),
            ],
          ),
          Container(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(defaultPadding),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(defaultPadding),
                              width: const BoxConstraints().maxWidth / 3,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 15.0,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: const BoxConstraints().maxWidth / 3,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: FutureDropFruta(
                                            client: client,
                                            onFrutaSelected:
                                                handleFrutaSelected,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: defaultPadding * 2,
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: FutureDropEmbalagem(
                                            client: client,
                                            onEmbalagemSelected:
                                                handleEmbalSelected,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: defaultPadding * 2,
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: FutureBuilder<List<Produtor>>(
                                              future: fetchProdutores(client),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                } else if (snapshot.hasError) {
                                                  return Center(
                                                    child: Text(
                                                        'Error: ${snapshot.error}'),
                                                  );
                                                } else {
                                                  produtores = snapshot.data!;
                                                  return DropdownButton<
                                                      Produtor>(
                                                    hint: const Text(
                                                        "Selecione um Produtor"),
                                                    items: produtores.map(
                                                        (Produtor produtor) {
                                                      return DropdownMenuItem<
                                                          Produtor>(
                                                        value: produtor,
                                                        child: Text(produtor
                                                            .nomeCompleto),
                                                      );
                                                    }).toList(),
                                                    onChanged:
                                                        (Produtor? value) {
                                                      setState(() {
                                                        _produtorSelecionado =
                                                            value;
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
                                              text: _frutaSelecionada
                                                  ?.nomeVariedade),
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
                                              text: _embalagemSelecionada
                                                  ?.nomePeso),
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
                                              text: _produtorSelecionado
                                                  ?.nomeCompleto),
                                          label: 'Produtor',
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: defaultPadding,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: TextFormField(
                                          controller: _quant,
                                          decoration: const InputDecoration(
                                            labelText: 'Quantidade',
                                          ),
                                          validator: (value) {
                                            if (value?.isEmpty ?? true) {
                                              return 'Por favor, preencha este campo';
                                            }
                                            return null;
                                          },
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9]')),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: defaultPadding * 4,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: TextFormField(
                                          readOnly: true,
                                          initialValue: formatDate(
                                              _data, [dd, '-', mm, '-', yyyy]),
                                          decoration: const InputDecoration(
                                            labelText: 'Data',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: defaultPadding * 4,
                                  ),
                                  Center(
                                    child: BotaoPadrao(
                                        context: context,
                                        title: 'Salvar',
                                        onPressed: _salvar),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        ],
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

    Entradas entrada = Entradas(
        id: 1,
        frutaId: _frutaSelecionada!.id,
        embalagemId: _embalagemSelecionada!.id,
        quantidade: double.parse(_quant.value.text),
        produtorId: _produtorSelecionado!.id,
        data: _data);

    try {
      await client.from('Entradas').insert(entrada.toMap());

      await processaEntradaSC(client, entrada.frutaId, entrada.produtorId,
          entrada.embalagemId, entrada.quantidade);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "Entrada cadastrada com sucesso",
            style: TextStyle(color: textColor),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } on PostgrestException catch (error) {
      if (error.message ==
          'duplicate key value violates unique constraint "Entradas_pkey"') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("Identificador já existente"),
          backgroundColor: Theme.of(context).colorScheme.error,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error.message),
          backgroundColor: Theme.of(context).colorScheme.error,
        ));
      }
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
