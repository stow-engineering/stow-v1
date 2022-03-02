import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'container_series.dart';

class ContainerChart extends StatelessWidget {
  final List<ContainerSeries> data;

  ContainerChart({required this.data});
  @override
  Widget build(BuildContext context) {
    List<charts.Series<ContainerSeries, String>> series = [
      charts.Series(
          id: "containers",
          data: data,
          domainFn: (ContainerSeries series, _) => series.almostEmpty,
          measureFn: (ContainerSeries series, _) => series.number,
          colorFn: (ContainerSeries series, _) => series.barColor)
    ];

    return charts.BarChart(series, animate: true, vertical: false);
  }
}
