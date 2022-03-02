import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/foundation.dart';

class ContainerSeries {
  final charts.Color barColor;
  final String almostEmpty;
  final int number;

  ContainerSeries(
      {required this.barColor,
      required this.almostEmpty,
      required this.number});
}
