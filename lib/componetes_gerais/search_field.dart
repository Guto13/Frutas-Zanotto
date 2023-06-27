import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    Key? key,
    required this.press,
  }) : super(key: key);

  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        fillColor: bgColor.withOpacity(0.5),
        filled: true,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        suffixIcon: InkWell(
          onTap: press,
          child: Container(
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
    );
  }
}
