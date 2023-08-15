import 'package:flutter/material.dart';
import 'package:maca_ipe/datas/embalagem.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../funcoes/banco_de_dados.dart';

typedef EmbalagemSelectionCallback = void Function(Embalagem embalagem);

class FutureDropEmbalagem extends StatefulWidget {
  const FutureDropEmbalagem({
    Key? key,
    required this.client,
    required this.onEmbalagemSelected,
    this.emba1 = '',
  }) : super(key: key);

  final SupabaseClient client;
  final EmbalagemSelectionCallback onEmbalagemSelected;
  final String emba1;

  @override
  State<FutureDropEmbalagem> createState() => _FutureDropEmbalagemState();
}

class _FutureDropEmbalagemState extends State<FutureDropEmbalagem> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Embalagem>>(
        future: fetchEmbalagens(widget.client),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<Embalagem> embalagens = snapshot.data!;
            return DropdownButton<Embalagem>(
              hint: const Text("Selecione uma Embalagem"),
              items: embalagens.map((Embalagem embalagem) {
                return DropdownMenuItem<Embalagem>(
                  value: embalagem,
                  child: Text(embalagem.nomePeso),
                );
              }).toList(),
              onChanged: (Embalagem? value) {
                widget.onEmbalagemSelected(value!);
              },
            );
          }
        });
  }
}
