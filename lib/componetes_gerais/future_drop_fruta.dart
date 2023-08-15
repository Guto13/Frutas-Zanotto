import 'package:flutter/material.dart';
import 'package:maca_ipe/datas/fruta.dart';
import 'package:maca_ipe/funcoes/banco_de_dados.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

typedef FrutaSelectionCallback = void Function(Fruta fruta);

class FutureDropFruta extends StatefulWidget {
  const FutureDropFruta({
    Key? key,
    required this.client,
    required this.onFrutaSelected,
    this.fruta1 = '',
    this.fruta2 = '',
  }) : super(key: key);

  final SupabaseClient client;
  final FrutaSelectionCallback onFrutaSelected;
  final String fruta1;
  final String fruta2;

  @override
  State<FutureDropFruta> createState() => _FutureDropFrutaState();
}

class _FutureDropFrutaState extends State<FutureDropFruta> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Fruta>>(
        future: fetchFrutas(widget.client,widget.fruta1,widget.fruta2),
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
            List<Fruta> frutas = snapshot.data!;
            return DropdownButton<Fruta>(
              hint: const Text("Selecione uma Fruta"),
              items: frutas.map((Fruta fruta) {
                return DropdownMenuItem<Fruta>(
                  value: fruta,
                  child: Text(fruta.nomeVariedade),
                );
              }).toList(),
              onChanged: (Fruta? value) {
                widget.onFrutaSelected(value!);
              },
            );
          }
        });
  }
}
