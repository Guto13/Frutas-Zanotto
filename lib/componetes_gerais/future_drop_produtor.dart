import 'package:flutter/material.dart';
import 'package:maca_ipe/datas/produtor.dart';
import 'package:maca_ipe/funcoes/banco_de_dados.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

typedef ProdutorSelectionCallback = void Function(Produtor produtor);

class FutureDropProdutor extends StatelessWidget {
  const FutureDropProdutor({
    Key? key,
    required this.client,
    required this.onProdutorSelect,
  }) : super(key: key);

  final SupabaseClient client;
  final ProdutorSelectionCallback onProdutorSelect;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Produtor>>(
        future: fetchProdutores(client),
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
            List<Produtor> produtores = snapshot.data!;
            return DropdownButton<Produtor>(
              hint: const Text("Selecione um Produtor"),
              items: produtores.map((Produtor produtor) {
                return DropdownMenuItem<Produtor>(
                  value: produtor,
                  child: Text(produtor.nomeCompleto),
                );
              }).toList(),
              onChanged: (Produtor? value) {
                onProdutorSelect(value!);
              },
            );
          }
        });
  }
}