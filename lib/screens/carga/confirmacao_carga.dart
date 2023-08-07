// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/app_bar.dart';
import 'package:maca_ipe/componetes_gerais/botao_padrao.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/datas/carga.dart';
import 'package:maca_ipe/datas/palete.dart';
import 'package:maca_ipe/screens/carga/palete_demonstracao.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ConfirmacaoCarga extends StatefulWidget {
  const ConfirmacaoCarga({Key? key, required this.paletes}) : super(key: key);

  final List<Palete> paletes;

  @override
  State<ConfirmacaoCarga> createState() => _ConfirmacaoCargaState();
}

class _ConfirmacaoCargaState extends State<ConfirmacaoCarga> {
  final client = Supabase.instance.client;
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Confirmação da Carga'),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Column(
                  children: [
                    ...widget.paletes
                        .map(
                          (e) => PaleteDemonstracao(palete: e),
                        )
                        .toList(),
                    const SizedBox(
                      height: defaultPadding * 2,
                    ),
                    BotaoPadrao(
                        context: context,
                        title: 'Confirmar',
                        onPressed: _salvar),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _salvar() async {
    setState(() {
      _isLoading = true;
    });
    Carga carga = Carga(id: 0, data: DateTime.now(), motorista: 'motorista');
    try {
      final cargaData = await client
          .from('Carga')
          .insert(carga.toMap())
          .select('id, Data, Motorista');

      widget.paletes.map(
        (e) async {
          await client.from('Palete').update(
              {'Carga': cargaData[0]['id'], 'Carregado': true}).eq('id', e.id);
        },
      ).toList();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Carga cadastrada com sucesso',
            style: TextStyle(color: textColor),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );

      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
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
}
