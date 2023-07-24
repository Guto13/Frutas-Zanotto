import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/button_text_default.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/screens/romaneio/romaneio_m/romaneio_m_screen.dart';

class DashboardRomaneio extends StatelessWidget {
  const DashboardRomaneio({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Container(
        padding: const EdgeInsets.all(defaultPadding),
        decoration: const BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ButtonTextDefault(
                      title: 'Maçã',
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RomaneioMScreen()),
                      ),
                    ),
                  ),
                  const SizedBox(width: defaultPadding),
                  Expanded(
                    flex: 2,
                    child: ButtonTextDefault(
                      title: 'Pêssego/ameixa',
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: defaultPadding * 2),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ButtonTextDefault(
                      title: 'Pêra',
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: defaultPadding),
                  Expanded(
                    flex: 2,
                    child: ButtonTextDefault(
                      title: 'Caqui',
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
