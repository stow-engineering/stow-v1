import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

import '../models/container_series.dart';
import '../../utils/firebase.dart';

class ContainerChart extends StatelessWidget {
  final List<ContainerSeries>? data;

  ContainerChart({required this.data});
  @override
  Widget build(BuildContext context) {
    List<charts.Series<ContainerSeries, String>> series = [
      charts.Series(
          id: "containers",
          data: data!,
          domainFn: (ContainerSeries series, _) => series.almostEmpty,
          measureFn: (ContainerSeries series, _) => series.number,
          colorFn: (ContainerSeries series, _) => series.barColor)
    ];

    return charts.BarChart(series, animate: true, vertical: false);
  }
}

class NumFull {
  static Future<List<ContainerSeries>> getData(FirebaseService service) async {
    List<String> addresses = await service.getAddresses();
    int numFull = 0;
    int numEmpty = 0;
    for (int i = 0; i < addresses.length; i++) {
      bool full = await service.getFull(addresses[i]);
      if (full) {
        numFull++;
      } else {
        numEmpty++;
      }
    }
    return [
      ContainerSeries(
          barColor: charts.ColorUtil.fromDartColor(Colors.green),
          almostEmpty: "Full",
          number: numFull),
      ContainerSeries(
          barColor: charts.ColorUtil.fromDartColor(Colors.red),
          almostEmpty: "Low",
          number: numEmpty)
    ];
  }
}
