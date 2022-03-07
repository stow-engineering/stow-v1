import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stow/container_chart.dart';
import 'user_auth.dart';
import 'login.dart';
import 'container_series.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'container_chart.dart';

class Pantry extends StatelessWidget {
  Pantry({Key? key, required this.data}) : super(key: key);
  final String data;
  final List<ContainerSeries> myData = [
    ContainerSeries(
        barColor: charts.ColorUtil.fromDartColor(Colors.green),
        almostEmpty: "Full",
        number: 15),
    ContainerSeries(
        barColor: charts.ColorUtil.fromDartColor(Colors.red),
        almostEmpty: "Low",
        number: 5)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 15),
            child: Card(
              elevation: 0.0,
              color: const Color.fromARGB(255, 237, 248, 255),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 5, top: 0, bottom: 5),
                child: Row(
                  children: <Widget>[
                    Column(
                      children: const <Widget>[
                        Text(
                          "23",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 60,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Containers",
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        height: 175,
                        padding: const EdgeInsets.all(25),
                        child: ContainerChart(data: myData),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
