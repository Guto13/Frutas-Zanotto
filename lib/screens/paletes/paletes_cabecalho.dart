import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/botao_padrao.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/componetes_gerais/title_medium.dart';
import 'package:maca_ipe/funcoes/responsive.dart';
import 'package:maca_ipe/screens/paletes/palete_novo.dart';

class PaletesCabecalho extends StatelessWidget {
  final Function(bool) onCarga;
  final Function(String) onSearch;
  final GlobalKey<ScaffoldState> keyPaletes;

  const PaletesCabecalho(
      {Key? key,
      required this.onCarga,
      required this.onSearch,
      required this.keyPaletes})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!Responsive.isDesktop(context))
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                keyPaletes.currentState!.openDrawer();
              },
            ),
          TitleMedium(title: 'Paletes', context: context),
          const SizedBox(
            width: defaultPadding,
          ),
          InkWell(
            onTap: () {
              onCarga(false);
            },
            child: TitleMedium(context: context, title: "P/ Carregar"),
          ),
          const SizedBox(
            width: defaultPadding * 2,
          ),
          InkWell(
            onTap: () {
              onCarga(true);
            },
            child: TitleMedium(context: context, title: "Carregados"),
          ),
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
            title: 'Novo',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PaleteNovo()),
            ),
          ),
        ],
      ),
    );
  }
}
