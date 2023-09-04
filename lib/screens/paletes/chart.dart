import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:pie_chart/pie_chart.dart';

class Chart extends StatefulWidget {
  const Chart({Key? key, required this.paletes}) : super(key: key);

  final Map<String, double> paletes;

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  double totPaletes = 0;

  @override
  Widget build(BuildContext context) {
    for (var value in widget.paletes.values) {
      totPaletes += value;
    }
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
          dataMap: widget.paletes,
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
