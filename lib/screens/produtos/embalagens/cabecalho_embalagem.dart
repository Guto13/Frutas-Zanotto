import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/botao_padrao.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/componetes_gerais/title_medium.dart';
import 'package:maca_ipe/funcoes/responsive.dart';
import 'package:maca_ipe/screens/produtos/embalagens/add_embalagens.dart';

class CabecalhoEmbalagem extends StatelessWidget {
  const CabecalhoEmbalagem(
      {Key? key, required this.onSearch, required this.keyEmbalagens})
      : super(key: key);

  final Function(String) onSearch;
  final GlobalKey<ScaffoldState> keyEmbalagens;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                keyEmbalagens.currentState!.openDrawer();
              }),
        TitleMedium(title: 'Embalagens', context: context),
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
                MaterialPageRoute(builder: (context) => const AddEmbalagens()),
              );
            }),
      ],
    );
  }
}
