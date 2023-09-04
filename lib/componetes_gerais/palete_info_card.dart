import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/datas/palete.dart';
import 'package:maca_ipe/datas/palete_fruta.dart';

class PaleteInfoCard extends StatelessWidget {
  const PaleteInfoCard({
    Key? key,
    required this.palete,
    required this.paleteFruta,
  }) : super(key: key);

  final Palete palete;
  final List<PaleteFrutaLista> paleteFruta;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: bgColor2,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(defaultPadding * 0.75),
                height: 40,
                width: 40,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: SvgPicture.asset(
                  'assets/icons/paletes.svg',
                ),
              ),
              Container(
                padding: const EdgeInsets.all(defaultPadding * 0.75),
                height: 40,
                width: 50,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Text(palete.id.toString()),
              ),
            ],
          ),
          ...paleteFruta
              .map(
                (e) => Column(
                  children: [
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                      "${e.fruta.nome} ${e.fruta.variedade}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                        Text(
                          e.calibre,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Colors.white70),
                        ),
                        Text(
                          e.quantidade.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}
