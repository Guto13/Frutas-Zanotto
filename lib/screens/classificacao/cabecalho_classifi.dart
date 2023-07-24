import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/botao_padrao.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/screens/classificacao/tabela_classifi.dart';

class CabecalhoClassifi extends StatelessWidget {
  final Function(String) onSearch;

  const CabecalhoClassifi({Key? key, required this.onSearch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          const Spacer(),
          BotaoPadrao(
            context: context,
            title: 'Lista',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TabelaClassifi()),
            ),
          ),
        ],
      ),
    );
  }
}
