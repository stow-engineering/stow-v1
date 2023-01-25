// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:charts_flutter/flutter.dart' as charts;

// Project imports:
import '../../utils/firebase.dart';
import '../models/container.dart' as custom_container;
import '../models/container_series.dart';

class ContainerChart extends StatelessWidget {
  final List<ContainerSeries>? data;

  const ContainerChart({super.key, required this.data});
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
    int percent = 0;
    for (int i = 0; i < addresses.length; i++) {
      int val = await service.getVal(addresses[i]);
      String size = await service.getSize(addresses[i]);
      if (size == 'Small') {
        percent = (((165 - val) / 165) * 100).round();
      } else {
        percent = (((273 - val) / 273) * 100).round();
      }
      if (percent > 30) {
        numFull++;
      } else {
        numEmpty++;
      }
    }
    return [
      ContainerSeries(
          barColor: charts.ColorUtil.fromDartColor(Colors.greenAccent),
          almostEmpty: "Full",
          number: numFull),
      ContainerSeries(
          barColor: charts.ColorUtil.fromDartColor(Colors.red),
          almostEmpty: "Low",
          number: numEmpty)
    ];
  }

  static List<ContainerSeries> getSeries(
      List<custom_container.Container> containers) {
    int numFull = 0;
    int numEmpty = 0;
    int percent = 0;
    for (int i = 0; i < containers.length; i++) {
      int val = containers[i].value;
      String size = containers[i].size;
      if (size == 'Small') {
        percent = (((165 - val) / 165) * 100).round();
      } else {
        percent = (((273 - val) / 273) * 100).round();
      }
      if (percent > 30) {
        numFull++;
      } else {
        numEmpty++;
      }
    }
    return [
      ContainerSeries(
          barColor: charts.ColorUtil.fromDartColor(Colors.greenAccent),
          almostEmpty: "Full",
          number: numFull),
      ContainerSeries(
          barColor: charts.ColorUtil.fromDartColor(Colors.red),
          almostEmpty: "Low",
          number: numEmpty)
    ];
  }

  static List<ContainerSeries> createContainerSeries(
      List<custom_container.Container> containers) {
    int numFull = 0;
    int numEmpty = 0;
    int percent = 0;
    for (int i = 0; i < containers.length; i++) {
      if (containers[i].size == 'Small') {
        percent = (((165 - containers[i].value) / 165) * 100).round();
      } else {
        percent = (((273 - containers[i].value) / 273) * 100).round();
      }
      if (percent > 30) {
        numFull++;
      } else {
        numEmpty++;
      }
    }
    return [
      ContainerSeries(
          barColor: charts.ColorUtil.fromDartColor(Colors.greenAccent),
          almostEmpty: "Full",
          number: numFull),
      ContainerSeries(
          barColor: charts.ColorUtil.fromDartColor(Colors.red),
          almostEmpty: "Low",
          number: numEmpty)
    ];
  }
}
