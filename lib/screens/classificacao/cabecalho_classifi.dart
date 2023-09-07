import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/botao_padrao.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/componetes_gerais/title_medium.dart';
import 'package:maca_ipe/funcoes/responsive.dart';
import 'package:maca_ipe/screens/classificacao/tabela_classifi.dart';

class CabecalhoClassifi extends StatelessWidget {
  final Function(String) onSearch;
  final GlobalKey<ScaffoldState> keyClassifi;

  const CabecalhoClassifi(
      {Key? key, required this.onSearch, required this.keyClassifi})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    keyClassifi.currentState!.openDrawer();
                  }),
              TitleMedium(title: 'Classificação', context: context),
              SizedBox(
                  width: Responsive.isDesktop(context)
                      ? defaultPadding
                      : defaultPadding / 2),
              Expanded(
                child: TextField(
                  onSubmitted: (value) {
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
              if (!Responsive.isMobile(context))
                Spacer(
                  flex: Responsive.isDesktop(context) ? 2 : 1,
                ),
              BotaoPadrao(
                context: context,
                title: 'Lista',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TabelaClassifi()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
