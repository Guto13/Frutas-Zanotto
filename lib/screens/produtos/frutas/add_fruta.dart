// ignore_for_file: unnecessary_cast, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maca_ipe/componetes_gerais/app_bar.dart';
import 'package:maca_ipe/componetes_gerais/botao_padrao.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/datas/fruta.dart';
import 'package:maca_ipe/funcoes/responsive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddFrutas extends StatefulWidget {
  const AddFrutas({Key? key}) : super(key: key);

  @override
  State<AddFrutas> createState() => _AddFrutasState();
}

class _AddFrutasState extends State<AddFrutas> {
  final _formKey = GlobalKey<FormState>();
  late String _id;
  late String _nome;
  late String _variedade;
  final client = Supabase.instance.client;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Nova Fruta"),
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
                                    child: Responsive.isDesktop(context)
                                        ? Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: fieldId(),
                                              ),
                                              const SizedBox(
                                                  width: defaultPadding),
                                              Expanded(
                                                flex: 4,
                                                child: fieldName(),
                                              ),
                                            ],
                                          )
                                        : Column(
                                            children: [
                                              fieldId(),
                                              const SizedBox(
                                                  height: defaultPadding),
                                              fieldName(),
                                            ],
                                          )),
                                const SizedBox(height: 10.0),
                                TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Variedade',
                                  ),
                                  validator: (value) {
                                    if (value?.isEmpty ?? true) {
                                      return 'Por favor, preencha este campo';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) => _variedade = value!,
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

  TextFormField fieldId() {
    return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      ],
      decoration: const InputDecoration(
        labelText: 'Identificador',
      ),
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return 'Por favor, preencha este campo';
        }
        return null;
      },
      onSaved: (value) => _id = value!,
    );
  }

  Future<void> _cadastro() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      Fruta fruta =
          Fruta(id: int.parse(_id), nome: _nome, variedade: _variedade);
      try {
        await client.from('Fruta').insert(fruta.toMap());
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text(
            "Fruta cadastrada com sucesso",
            style: TextStyle(color: textColor),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ));
      } on PostgrestException catch (error) {
        if (error.message ==
            'duplicate key value violates unique constraint "Fruta_pkey"') {
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
