// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/app_bar.dart';
import 'package:maca_ipe/datas/embalagem.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../componetes_gerais/botao_padrao.dart';
import '../../../componetes_gerais/constants.dart';

class AddEmbalagens extends StatefulWidget {
  const AddEmbalagens({Key? key}) : super(key: key);

  @override
  State<AddEmbalagens> createState() => _AddEmbalagensState();
}

class _AddEmbalagensState extends State<AddEmbalagens> {
  final _formKey = GlobalKey<FormState>();
  late String _nome;
  late String _pesoAprox;
  final client = Supabase.instance.client;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Nova embalagem"),
      body: Container(
          child: _isLoading
              ? const CircularProgressIndicator()
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
                                        flex: 4,
                                        child: TextFormField(
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
                                      const SizedBox(width: defaultPadding),
                                      Expanded(
                                        flex: 1,
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                            labelText: 'Peso Aproximado',
                                          ),
                                          
                                          onSaved: (value) =>
                                              _pesoAprox = value!,
                                          onFieldSubmitted: (_) => _cadastro(),
                                        ),
                                      ),
                                    ],
                                  ),
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

  Future<void> _cadastro() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      Embalagem fruta = Embalagem(id: 45, nome: _nome, pesoAprox: _pesoAprox);
      try {
        await client.from('Embalagem').insert(fruta.toMap());
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text(
            "Embalagem cadastrada com sucesso",
            style: TextStyle(color: textColor),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ));
      } on PostgrestException catch (error) {
        if (error.message ==
            'duplicate key value violates unique constraint "Embalagem_pkey"') {
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
