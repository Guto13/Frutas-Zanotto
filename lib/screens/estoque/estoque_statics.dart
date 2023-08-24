import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/datas/estoque_lista.dart';
import 'package:maca_ipe/funcoes/responsive.dart';
import 'package:pie_chart/pie_chart.dart';

class EstoqueStatics extends StatefulWidget {
  const EstoqueStatics(
      {Key? key,
      required this.estoque,
      this.fruta = true,
      this.produtor = true})
      : super(key: key);

  final List<EstoqueLista> estoque;
  final bool fruta;
  final bool produtor;

  @override
  State<EstoqueStatics> createState() => _EstoqueStaticsState();
}

class _EstoqueStaticsState extends State<EstoqueStatics> {
  bool frutaSN = true;
  double total = 0.0;

  Future<Map<String, double>> retornaMap(
      List<EstoqueLista> estoque, bool fruta) async {
    var mapObj = <String, double>{};
    total = 0.0;
    for (var element in estoque) {
      if (fruta) {
        if (mapObj[element.fruta.nome] == null) {
          mapObj[element.fruta.nome] = element.quantidade;
          total += element.quantidade;
        } else {
          mapObj[element.fruta.nome] =
              element.quantidade + mapObj[element.fruta.nome]!;
          total += element.quantidade;
        }
      } else {
        if (mapObj[element.produtor.nome] == null) {
          mapObj[element.produtor.nome] = element.quantidade;
          total += element.quantidade;
        } else {
          mapObj[element.produtor.nome] =
              element.quantidade + mapObj[element.produtor.nome]!;
          total += element.quantidade;
        }
      }
    }

    return mapObj;
  }

  @override
  Widget build(BuildContext context) {
    return widget.fruta && widget.produtor
        ? Container(
            padding: const EdgeInsets.all(defaultPadding),
            decoration: const BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: widget.estoque.isEmpty
                ? const Center()
                : Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => setState(() {
                                frutaSN = true;
                              }),
                              child: Container(
                                decoration: frutaSN
                                    ? const BoxDecoration(color: Colors.green)
                                    : const BoxDecoration(),
                                child: const Text('Fruta'),
                              ),
                            ),
                          ),
                          const SizedBox(width: defaultPadding),
                          Expanded(
                            child: InkWell(
                              onTap: () => setState(() {
                                frutaSN = false;
                              }),
                              child: Container(
                                decoration: frutaSN
                                    ? const BoxDecoration()
                                    : const BoxDecoration(color: Colors.green),
                                child: const Text('Produtor'),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: defaultPadding * 2,
                      ),
                      FutureBuilder<Map<String, double>>(
                          future: retornaMap(widget.estoque, frutaSN),
                          builder: ((context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasData) {
                              return Column(
                                children: [
                                  Text(
                                    total.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium!
                                        .copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          height: 0.5,
                                        ),
                                  ),
                                  const SizedBox(
                                    height: defaultPadding * 3,
                                  ),
                                  ChartEstoque(
                                    estoque: snapshot.data!,
                                  ),
                                ],
                              );
                            } else {
                              return const Center(
                                child: Text('Erro'),
                              );
                            }
                          }))
                    ],
                  ))
        : widget.fruta
            ? Container(
                padding: const EdgeInsets.all(defaultPadding),
                decoration: const BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: widget.estoque.isEmpty
                    ? const Center()
                    : Column(
                        children: [
                          FutureBuilder<Map<String, double>>(
                              future: retornaMap(widget.estoque, true),
                              builder: ((context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasData) {
                                  return Column(
                                    children: [
                                      Text(
                                        total.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium!
                                            .copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              height: 0.5,
                                            ),
                                      ),
                                      const SizedBox(
                                        height: defaultPadding * 3,
                                      ),
                                      ChartEstoque(
                                        estoque: snapshot.data!,
                                        legendPosition:
                                            Responsive.isDesktop(context)
                                                ? LegendPosition.left
                                                : LegendPosition.bottom,
                                      ),
                                    ],
                                  );
                                } else {
                                  return const Center(
                                    child: Text('Erro'),
                                  );
                                }
                              }))
                        ],
                      ))
            : Container(
                padding: const EdgeInsets.all(defaultPadding),
                decoration: const BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: widget.estoque.isEmpty
                    ? const Center()
                    : Column(
                        children: [
                          FutureBuilder<Map<String, double>>(
                              future: retornaMap(widget.estoque, false),
                              builder: ((context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasData) {
                                  return Column(
                                    children: [
                                      Text(
                                        total.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium!
                                            .copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              height: 0.5,
                                            ),
                                      ),
                                      const SizedBox(
                                        height: defaultPadding * 3,
                                      ),
                                      ChartEstoque(
                                        estoque: snapshot.data!,
                                      ),
                                    ],
                                  );
                                } else {
                                  return const Center(
                                    child: Text('Erro'),
                                  );
                                }
                              }))
                        ],
                      ));
  }
}

class ChartEstoque extends StatelessWidget {
  const ChartEstoque({
    Key? key,
    required this.estoque,
    this.legendPosition = LegendPosition.bottom,
  }) : super(key: key);

  final Map<String, double> estoque;
  final LegendPosition legendPosition;

  @override
  Widget build(BuildContext context) {
    return PieChart(
      dataMap: estoque,
      animationDuration: const Duration(milliseconds: 800),
      chartType: ChartType.disc,
      chartValuesOptions:
          const ChartValuesOptions(showChartValuesOutside: true),
      baseChartColor: Color.fromARGB(255, 240, 7, 209),
      legendOptions: LegendOptions(legendPosition: legendPosition),
    );
  }
}
