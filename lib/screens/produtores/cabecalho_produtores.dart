import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/botao_padrao.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/componetes_gerais/title_medium.dart';
import 'package:maca_ipe/funcoes/responsive.dart';
import 'package:maca_ipe/screens/produtores/add_produtores.dart';

class CabecalhoProdutores extends StatelessWidget {
  final Function(String) onSearch;
  final GlobalKey<ScaffoldState> keyProdutores;
  const CabecalhoProdutores(
      {Key? key, required this.onSearch, required this.keyProdutores})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Row(
              children: [
                if (!Responsive.isDesktop(context))
                  IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        keyProdutores.currentState!.openDrawer();
                      }),
                TitleMedium(title: 'Produtores', context: context),
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
                        margin:
                            const EdgeInsets.only(right: defaultPadding / 3),
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
                        MaterialPageRoute(
                            builder: (context) => const AddProdutores()),
                      );
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
