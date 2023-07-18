import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/botao_padrao.dart';
import '../../componetes_gerais/constants.dart';
import 'entrada/estoque_entrada.dart';

class CabecalhoEstoque extends StatelessWidget {
  final Function(String) onSearch;

  const CabecalhoEstoque({Key? key, required this.onSearch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
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
          title: 'Entrada',
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EntradaEstoque()),
          ),
        ),
        const SizedBox(
          width: defaultPadding,
        ),
        BotaoPadrao(context: context, title: 'Saída', onPressed: () {}),
      ],
    );
  }
}
