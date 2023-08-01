// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/app_bar.dart';
import 'package:maca_ipe/componetes_gerais/botao_padrao.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/datas/embalagem.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditEmbalagens extends StatefulWidget {
  const EditEmbalagens({Key? key, required this.embalagem}) : super(key: key);

  final Embalagem embalagem;

  @override
  State<EditEmbalagens> createState() => _EditEmbalagensState();
}

class _EditEmbalagensState extends State<EditEmbalagens> {
  final _formKey = GlobalKey<FormState>();
  late String _nome;
  late String _peso;
  final client = Supabase.instance.client;
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Edição de Frutas"),
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
                                              widget.embalagem.id.toString(),
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
                                          initialValue: widget.embalagem.nome,
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
                                  initialValue: widget.embalagem.pesoAprox,
                                  decoration: const InputDecoration(
                                    labelText: 'Peso Aprox',
                                  ),
                                  validator: (value) {
                                    if (value?.isEmpty ?? true) {
                                      return 'Por favor, preencha este campo';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) => _peso = value!,
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

  Future<void> _salvar() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      Embalagem embalagem =
          Embalagem(id: widget.embalagem.id, nome: _nome, pesoAprox: _peso);

      try {
        await client
            .from('Embalagem')
            .update(embalagem.toMap())
            .eq('id', embalagem.id);
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text(
            "Fruta editada com sucesso",
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
