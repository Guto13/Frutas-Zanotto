import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/app_bar.dart';
import 'package:maca_ipe/componetes_gerais/text_bold_normal.dart';
import 'package:maca_ipe/datas/carga.dart';
import 'package:maca_ipe/datas/palete.dart';
import 'package:maca_ipe/funcoes/banco_de_dados.dart';
import 'package:maca_ipe/screens/carga/palete_demonstracao.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../componetes_gerais/constants.dart';

class CargaCompleta extends StatefulWidget {
  const CargaCompleta({Key? key, required this.carga}) : super(key: key);

  final Carga carga;

  @override
  State<CargaCompleta> createState() => _CargaCompletaState();
}

class _CargaCompletaState extends State<CargaCompleta> {
  final client = Supabase.instance.client;
  List<Palete> paletes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Carga: ${widget.carga.id}'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextBoldNormal(
                    bold: 'Carga: ',
                    normal: widget.carga.id.toString(),
                  )),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextBoldNormal(
                    bold: "Data: ",
                    normal: formatDate(
                      widget.carga.data,
                      [dd, '-', mm, '-', yyyy],
                    ),
                  )),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextBoldNormal(
                    bold: "Motorista: ",
                    normal: widget.carga.motorista,
                  )),
              const SizedBox(
                height: defaultPadding * 3,
              ),
              FutureBuilder<List<Palete>>(
                  future: buscarPaletesPelaCarga(client, widget.carga.id),
                  builder: ((context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasData) {
                      paletes = snapshot.data!;
                      return Column(
                        children: [
                          ...paletes
                              .map(
                                (e) => PaleteDemonstracao(palete: e),
                              )
                              .toList()
                        ],
                      );
                    } else {
                      return const Center(
                        child: Text('Erro ao carregar os dados'),
                      );
                    }
                  }))
            ],
          ),
        ),
      ),
    );
  }
}
