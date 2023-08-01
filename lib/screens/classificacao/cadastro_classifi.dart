// ignore_for_file: use_build_context_synchronously

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maca_ipe/componetes_gerais/campo_retorno.dart';
import 'package:maca_ipe/componetes_gerais/title_medium.dart';
import 'package:maca_ipe/datas/classificacao.dart';
import 'package:maca_ipe/datas/estoque_lista.dart';
import 'package:maca_ipe/funcoes/banco_de_dados.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../componetes_gerais/botao_padrao.dart';
import '../../componetes_gerais/constants.dart';

class CadastroClassifi extends StatefulWidget {
  final String pesquisa;
  const CadastroClassifi({
    Key? key,
    required this.pesquisa,
  }) : super(key: key);

  @override
  State<CadastroClassifi> createState() => _CadastroClassifiState();
}

class _CadastroClassifiState extends State<CadastroClassifi> {
  final client = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();
  List<EstoqueLista> estoqueSC = [];
  final ScrollController _controllerOne = ScrollController();
  final _quant = TextEditingController();
  final _romaneio = TextEditingController();
  final _refugoController = TextEditingController();
  late int _idEstoque;
  late int _idFruta;
  late int _idEmbalagem;
  late int _idProdutor;
  late double _quantAtual;
  late double _quantRestante;
  String _fruta = '';
  String _embalagem = '';
  String _produtor = '';
  bool _isLoading = false;
  var refugoMaskFormatter =
      MaskTextInputFormatter(mask: '##.##', filter: {"#": RegExp(r'[0-9]')});

  Future<List<EstoqueLista>> buscarEstoqueSC(SupabaseClient client) async {
    final estoqueJson = await client
        .from('EstoqueSC')
        .select(
            'id, Fruta(id, Nome, Variedade), Embalagem(id, Nome), Quantidade, Produtor(id, Nome, Sobrenome)')
        .order('Quantidade');
    return parseEstoqueSC(estoqueJson);
  }

  List<EstoqueLista> parseEstoqueSC(List<dynamic> responseBody) {
    List<EstoqueLista> estoque =
        responseBody.map((e) => EstoqueLista.fromJson(e)).toList();
    return estoque;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(defaultPadding),
                decoration: const BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: FutureBuilder<List<EstoqueLista>>(
                    future: buscarEstoqueSC(client),
                    builder: ((context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasData) {
                        estoqueSC = snapshot.data!;
                        estoqueSC = estoqueSC
                            .where((est) =>
                                est.fruta.nome
                                    .toLowerCase()
                                    .contains(widget.pesquisa.toLowerCase()) ||
                                est.produtor.nome
                                    .toLowerCase()
                                    .contains(widget.pesquisa.toLowerCase()) ||
                                est.produtor.sobrenome
                                    .toLowerCase()
                                    .contains(widget.pesquisa.toLowerCase()) ||
                                est.embalagem.nome
                                    .toLowerCase()
                                    .contains(widget.pesquisa.toLowerCase()) ||
                                est.fruta.variedade
                                    .toLowerCase()
                                    .contains(widget.pesquisa.toLowerCase()))
                            .toList();

                        estoqueSC = estoqueSC
                            .where((element) => element.quantidade > 0)
                            .toList();

                        return SingleChildScrollView(
                          controller: _controllerOne,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TitleMedium(
                                context: context,
                                title: "Estoque Sem classificação",
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: DataTable(
                                  columnSpacing: 16.0,
                                  dataRowHeight: 60.0,
                                  headingRowHeight:
                                      70.0, // Altura da linha de cabeçalho
                                  dividerThickness:
                                      1.0, // Espessura da borda entre células
                                  horizontalMargin: 20.0,
                                  columns: [
                                    columnTable('Fruta'),
                                    columnTable('Produtor'),
                                    columnTable('Embalagem'),
                                    columnTable('Quantidade'),
                                  ],
                                  rows: estoqueSC.map((e) {
                                    return DataRow(
                                        onLongPress: () {
                                          setState(() {
                                            _fruta =
                                                '${e.fruta.nome} ${e.fruta.variedade}';
                                            _embalagem = e.embalagem.nome;
                                            _produtor =
                                                '${e.produtor.nome} ${e.produtor.sobrenome}';
                                            _idEmbalagem = e.embalagem.id;
                                            _idFruta = e.fruta.id;
                                            _idProdutor = e.produtor.id;
                                            _idEstoque = e.id;
                                            _quantAtual = e.quantidade;
                                          });
                                        },
                                        cells: [
                                          columnData(
                                              '${e.fruta.nome} ${e.fruta.variedade}'),
                                          columnData(
                                              '${e.produtor.nome} ${e.produtor.sobrenome}'),
                                          columnData(e.embalagem.nome),
                                          columnData(e.quantidade.toString()),
                                        ]);
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return const Center(
                            child: Text('Erro ao carregar dados'));
                      }
                    }),
                  ),
                ),
              ),
              const SizedBox(
                height: defaultPadding,
              ),
              Container(
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
                    : Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: TitleMedium(
                                context: context,
                                title: "Cadastro Classificação",
                              )),
                              const Spacer(),
                              Expanded(
                                  child: TitleMedium(
                                context: context,
                                title: "Selecione acima a fruta e o produtor",
                              )),
                            ],
                          ),
                          const SizedBox(
                            height: defaultPadding,
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: defaultPadding * 1.5,
                              ),
                              Expanded(
                                flex: 1,
                                child: CampoRetorno(
                                  controller:
                                      TextEditingController(text: _fruta),
                                  label: 'Fruta',
                                ),
                              ),
                              const SizedBox(
                                width: defaultPadding * 1.5,
                              ),
                              Expanded(
                                flex: 1,
                                child: CampoRetorno(
                                  controller:
                                      TextEditingController(text: _embalagem),
                                  label: 'Embalagem',
                                ),
                              ),
                              const SizedBox(
                                width: defaultPadding * 1.5,
                              ),
                              Expanded(
                                flex: 1,
                                child: CampoRetorno(
                                  controller:
                                      TextEditingController(text: _produtor),
                                  label: 'Produtor',
                                ),
                              ),
                              const SizedBox(
                                width: defaultPadding * 1.5,
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
                                      DateTime.now(), [dd, '-', mm, '-', yyyy]),
                                  decoration: const InputDecoration(
                                    labelText: 'Data',
                                  ),
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
                                child: TextFormField(
                                  controller: _romaneio,
                                  decoration: const InputDecoration(
                                    labelText: 'Romaneio',
                                  ),
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
                                  controller: _refugoController,
                                  decoration: const InputDecoration(
                                    labelText: 'Refugo em bins',
                                  ),
                                  validator: (value) {
                                    if (value?.isEmpty ?? true) {
                                      return 'Por favor, preencha este campo';
                                    } else if (removeNonDigits(value.toString())
                                            .length !=
                                        4) {
                                      return 'O refugo precisa conter 4 dígitos';
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [refugoMaskFormatter],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: defaultPadding * 3,
                          ),
                          Center(
                            child: BotaoPadrao(
                              context: context,
                              title: 'Salvar',
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  _quantRestante = _quantAtual -
                                      (double.tryParse(_quant.text) ?? 0.0);
                                  if (_quantRestante < 0) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: const Text(
                                        "Estoque negativo",
                                        style: TextStyle(color: textColor),
                                      ),
                                      backgroundColor:
                                          Theme.of(context).colorScheme.error,
                                    ));
                                  } else {
                                    _salvar();
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          )),
    );
  }

  String removeNonDigits(String text) {
    return text.replaceAll(RegExp(r'\D'), '');
  }

  DataCell columnData(String data) {
    return DataCell(Text(data, style: const TextStyle(fontSize: 16)));
  }

  DataColumn columnTable(String title) {
    return DataColumn(
      label: Text(
        title,
        style: const TextStyle(color: textColor),
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

    Classificacao classifi = Classificacao(
      id: 1,
      frutaId: _idFruta,
      embalagemId: _idEmbalagem,
      quantidade: (double.tryParse(_quant.text) ?? 0.0),
      produtorId: _idProdutor,
      data: DateTime.now(),
      romaneioId: (int.tryParse(_romaneio.text) ?? 0),
      refugo: double.tryParse(_refugoController.text) ?? 0.0,
    );

    try {
      await client.from('Classificacao').insert(classifi.toMap());

      await atualizaEstoqueSCPorID(client, _idEstoque, _quantRestante);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "Classificação cadastrada com sucesso",
            style: TextStyle(color: textColor),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } on PostgrestException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.message),
        backgroundColor: Theme.of(context).colorScheme.error,
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
