import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/alert.dart';
import 'package:maca_ipe/componetes_gerais/botao_padrao.dart';
import 'package:maca_ipe/screens/estoque/entrada/estoque_c_entrada.dart';
import '../../componetes_gerais/constants.dart';
import '../../componetes_gerais/title_medium.dart';
import '../../funcoes/responsive.dart';
import 'entrada/estoque_sc_entrada.dart';

class CabecalhoEstoque extends StatelessWidget {
  final Function(String) onSearch;
  final GlobalKey<ScaffoldState> keyEstoque;
  final String title;

  const CabecalhoEstoque(
      {Key? key,
      required this.onSearch,
      required this.keyEstoque,
      required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            if (!Responsive.isDesktop(context))
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  keyEstoque.currentState!.openDrawer();
                },
              ),
            TitleMedium(title: title, context: context),
            Spacer(
              flex: Responsive.isDesktop(context) ? 2 : 1,
            ),
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
              const SizedBox(
                width: defaultPadding,
              ),
            if (!Responsive.isMobile(context))
              BotaoPadrao(
                context: context,
                title: 'Entrada',
                onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Alert(
                        content:
                            'Selecione se a entrada já está classificada ou não',
                        title: 'Qual estoque é a entrada?',
                        onCancel: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EntradaEstoqueC()),
                        ),
                        onConfirm: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EntradaEstoqueSC()),
                        ),
                        textOnCancel: "Classificado",
                        textOnConfirm: "N Classificado",
                      );
                    }),
              ),
            if (!Responsive.isMobile(context))
              const SizedBox(
                width: defaultPadding,
              ),
            if (!Responsive.isMobile(context))
              BotaoPadrao(context: context, title: 'Saída', onPressed: () {}),
          ],
        ),
        if (Responsive.isMobile(context))
          const SizedBox(
            height: defaultPadding / 2,
          ),
        if (Responsive.isMobile(context))
          Row(
            children: [
              BotaoPadrao(
                context: context,
                title: 'Entrada',
                onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Alert(
                        content:
                            'Selecione se a entrada já está classificada ou não',
                        title: 'Qual estoque é a entrada?',
                        onCancel: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EntradaEstoqueC()),
                        ),
                        onConfirm: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EntradaEstoqueSC()),
                        ),
                        textOnCancel: "Classificado",
                        textOnConfirm: "N Classificado",
                      );
                    }),
              ),
              const SizedBox(
                width: defaultPadding,
              ),
            ],
          ),
      ],
    );
  }
}
