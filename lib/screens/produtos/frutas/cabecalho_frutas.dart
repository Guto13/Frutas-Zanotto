import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/botao_padrao.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/componetes_gerais/title_medium.dart';
import 'package:maca_ipe/funcoes/responsive.dart';
import 'package:maca_ipe/screens/produtos/frutas/add_fruta.dart';

class CabecalhoFrutas extends StatelessWidget {
  const CabecalhoFrutas(
      {Key? key, required this.onSearch, required this.keyFrutas})
      : super(key: key);

  final Function(String) onSearch;
  final GlobalKey<ScaffoldState> keyFrutas;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Row(
        children: [
          if (!Responsive.isDesktop(context))
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                keyFrutas.currentState!.openDrawer();
              },
            ),
          TitleMedium(title: 'Frutas', context: context),
          Spacer(
            flex: Responsive.isDesktop(context) ? 2 : 1,
          ),
          Expanded(
            child: TextField(
              onChanged: (value) {
                onSearch(value);
              },
              decoration: InputDecoration(
                fillColor: bgColor.withOpacity(0.5),
                filled: true,
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                suffixIcon: Container(
                  padding: const EdgeInsets.all(defaultPadding * 0.6),
                  margin: const EdgeInsets.only(right: defaultPadding / 3),
                  decoration: const BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: const Icon(
                    Icons.search,
                    color: textColor,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: defaultPadding,
          ),
          BotaoPadrao(
              context: context,
              title: 'Add',
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const AddFrutas()),
                );
              }),
        ],
      );
    });
  }
}
