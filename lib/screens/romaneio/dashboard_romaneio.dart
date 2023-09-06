import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/button_text_default.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/funcoes/responsive.dart';
import 'package:maca_ipe/screens/romaneio/romaneio_cp/romaneio_cp_screen.dart';
import 'package:maca_ipe/screens/romaneio/romaneio_m/romaneio_m_screen.dart';
import 'package:maca_ipe/screens/romaneio/romaneio_pa/romaneio_pa_screen.dart';

class DashboardRomaneio extends StatefulWidget {
  const DashboardRomaneio({
    Key? key,
  }) : super(key: key);

  @override
  State<DashboardRomaneio> createState() => _DashboardRomaneioState();
}

class _DashboardRomaneioState extends State<DashboardRomaneio> {
  List<Map<String, Widget>> buttons = [
    {
      'Maçã': const RomaneioMScreen(),
    },
    {
      'Pêssego': const RomaneioPAScreen(frutaR: "Pêssego"),
    },
    {
      'Ameixa': const RomaneioPAScreen(frutaR: "Ameixa"),
    },
    {
      'Caqui': const RomaneioCPScreen(frutaR: "Caqui"),
    },
    {
      'Pêra': const RomaneioCPScreen(frutaR: "Pêra"),
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        childAspectRatio: 2.5,
        crossAxisCount: Responsive.isMobile(context) ? 1 : 3,
        crossAxisSpacing:
            Responsive.isMobile(context) ? defaultPadding : defaultPadding * 2,
        mainAxisSpacing:
            Responsive.isMobile(context) ? defaultPadding : defaultPadding * 2,
        children: [
          ...buttons
              .map((e) => ButtonTextDefault(
                    title: e.keys.first,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => e.values.first),
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }
}
