// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/app_bar.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/datas/produtor.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../componetes_gerais/botao_padrao.dart';

class EditProdutores extends StatefulWidget {
  const EditProdutores({Key? key, required this.produtor}) : super(key: key);

  final Produtor produtor;

  @override
  State<EditProdutores> createState() => _EditProdutoresState();
}

class _EditProdutoresState extends State<EditProdutores> {
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
      appBar: CustomAppBar(title: "Edição de Produtores"),
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
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: TextFormField(
                                          initialValue:
                                              widget.produtor.id.toString(),
                                          enabled: false,
                                          decoration: const InputDecoration(
                                            labelText: 'Identificador',
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: defaultPadding),
                                      Expanded(
                                        flex: 4,
                                        child: TextFormField(
                                          initialValue: widget.produtor.nome,
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
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                TextFormField(
                                  initialValue:widget.produtor.sobrenome,
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
                                  initialValue: widget.produtor.endereco,
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
                                  initialValue: widget.produtor.telefone,
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
                                  initialValue: widget.produtor.contaB,
                                  decoration: const InputDecoration(
                                    labelText: 'Conta Bancaria',
                                  ),
                                  onSaved: (value) => _contaBancaria = value!,
                                  onFieldSubmitted: (_) => () {},
                                ),
                                const SizedBox(height: 20.0),
                                BotaoPadrao(
                                    context: context,
                                    title: "Salvar",
                                    onPressed: _salvar)
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

  String removeNonDigits(String text) {
    return text.replaceAll(RegExp(r'\D'), '');
  }

  Future<void> _salvar() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      Produtor produtor = Produtor(
          id: widget.produtor.id,
          nome: _nome,
          sobrenome: _sobrenome,
          endereco: _endereco,
          telefone: _telefone,
          contaB: _contaBancaria);

      try {
        await client
            .from('Produtor')
            .update(produtor.toMap())
            .eq('id', produtor.id);
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text(
            "Produtor editado com sucesso",
            style: TextStyle(color: textColor),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ));
        Navigator.of(context).pop();
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
