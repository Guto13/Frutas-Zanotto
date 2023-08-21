// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maca_ipe/componetes_gerais/app_bar.dart';
import 'package:maca_ipe/componetes_gerais/botao_padrao.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/datas/produtor.dart';
import 'package:maca_ipe/funcoes/responsive.dart';
import 'package:maca_ipe/screens/produtores/edit_produtores.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddProdutores extends StatefulWidget {
  const AddProdutores({Key? key}) : super(key: key);

  @override
  State<AddProdutores> createState() => _AddProdutoresState();
}

class _AddProdutoresState extends State<AddProdutores> {
  final _formKey = GlobalKey<FormState>();
  late String _nome;
  late String _sobrenome;
  late String _endereco;
  late String _contaBancaria;
  late String _telefone;
  final client = Supabase.instance.client;
  bool _isLoading = false;
  var phoneMaskFormatter = MaskTextInputFormatter(
      mask: '(##) # ####-####', filter: {"#": RegExp(r'[0-9]')});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Cadastro de Produtores"),
      body: Container(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(defaultPadding * 4),
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
                                  child: Responsive.isDesktop(context)
                                      ? Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: TextFormField(
                                                enabled: false,
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: <
                                                    TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .allow(RegExp(r'[0-9]')),
                                                ],
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: 'Identificador',
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                                width: defaultPadding),
                                            Expanded(
                                              flex: 4,
                                              child: fieldName(),
                                            ),
                                          ],
                                        )
                                      : fieldName(),
                                ),
                                const SizedBox(height: 10.0),
                                TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Sobrenome',
                                  ),
                                  validator: (value) {
                                    if (value?.isEmpty ?? true) {
                                      return 'Por favor, preencha este campo';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) => _sobrenome = value!,
                                ),
                                const SizedBox(height: 10.0),
                                TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Endereço',
                                  ),
                                  validator: (value) {
                                    if (value?.isEmpty ?? true) {
                                      return 'Por favor, preencha este campo';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) => _endereco = value!,
                                ),
                                const SizedBox(height: 10.0),
                                TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Telefone',
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [phoneMaskFormatter],
                                  validator: (value) {
                                    if (value?.isEmpty ?? true) {
                                      return 'Por favor, preencha este campo';
                                    } else if (removeNonDigits(value.toString())
                                            .length !=
                                        11) {
                                      return 'O número de telefone precisa conter 11 dígitos';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) => _telefone = value!,
                                ),
                                const SizedBox(height: 10.0),
                                TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Conta Bancaria',
                                  ),
                                  onSaved: (value) => _contaBancaria = value!,
                                  onFieldSubmitted: (_) => _cadastro(),
                                ),
                                const SizedBox(height: 20.0),
                                BotaoPadrao(
                                    context: context,
                                    title: "Cadastrar",
                                    onPressed: _cadastro)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
    );
  }

  TextFormField fieldName() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Nome',
      ),
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return 'Por favor, preencha este campo';
        }
        return null;
      },
      onSaved: (value) => _nome = value!,
    );
  }

  String removeNonDigits(String text) {
    return text.replaceAll(RegExp(r'\D'), '');
  }

  Produtor parseProdutorJson(List<dynamic> responseBody) {
    List<Produtor> produtores =
        responseBody.map((e) => Produtor.fromJson(e)).toList();
    return produtores[0];
  }

  Future<void> _cadastro() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      Produtor produtor = Produtor(
          id: 1,
          nome: _nome,
          sobrenome: _sobrenome,
          endereco: _endereco,
          telefone: _telefone,
          contaB: _contaBancaria);
      try {
        final produtorCad =
            await client.from('Produtor').insert(produtor.toMap()).select();
        
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text(
            "Produtor cadastrado com sucesso",
            style: TextStyle(color: textColor),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ));
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EditProdutores(
                    produtor: parseProdutorJson(produtorCad),
                  )),
        );
      } on PostgrestException catch (error) {
        if (error.message ==
            'duplicate key value violates unique constraint "Produtor_pkey"') {
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
}
