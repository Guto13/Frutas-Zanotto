// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/componetes_gerais/palete_info_card.dart';
import 'package:maca_ipe/datas/palete.dart';
import 'package:maca_ipe/datas/palete_info.dart';
import 'package:maca_ipe/funcoes/banco_de_dados.dart';
import 'package:maca_ipe/screens/paletes/palete_tabela.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FileInfoCardGridView extends StatelessWidget {
  const FileInfoCardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
    required this.paletes,
    required this.client,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;
  final List<PaleteInfo> paletes;
  final SupabaseClient client;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: paletes.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: defaultPadding,
          mainAxisSpacing: defaultPadding,
          childAspectRatio: childAspectRatio,
        ),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () async {
              List<Palete> aux = await buscarPaleteId(
                  client, int.parse(paletes[index].palete));
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PaleteTabela(
                          palete: aux[0],
                        )),
              );
            },
            child: PaleteInfoCard(
              palete: paletes[index],
            ),
          );
        });
  }
}
