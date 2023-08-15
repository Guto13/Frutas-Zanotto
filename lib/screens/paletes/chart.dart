import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/datas/statics.dart';
import 'package:pie_chart/pie_chart.dart';

class Chart extends StatefulWidget {
  const Chart({Key? key, required this.statics}) : super(key: key);

  final StaticsPaletes statics;

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  double totPaletes = 0;

  @override
  Widget build(BuildContext context) {
    totPaletes = widget.statics.maca +
        widget.statics.ameixa +
        widget.statics.pessego +
        widget.statics.pera +
        widget.statics.caqui;
    return Column(
      children: [
        Text(
          totPaletes.toStringAsFixed(2),
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                height: 0.5,
              ),
        ),
        const SizedBox(
          height: defaultPadding * 3,
        ),
        PieChart(
          dataMap: widget.statics.toMap(),
          animationDuration: const Duration(milliseconds: 800),
          chartType: ChartType.disc,
          chartValuesOptions:
              const ChartValuesOptions(showChartValuesOutside: true),
          baseChartColor: Colors.green,
          legendOptions:
              const LegendOptions(legendPosition: LegendPosition.bottom),
        ),
      ],
    );
  }
}
