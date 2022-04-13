import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stow/container_chart.dart';
import 'package:stow/database.dart';
import 'package:stow/user.dart';
import 'container_list.dart';
import 'user_auth.dart';
import 'login.dart';
import 'container_series.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'container_chart.dart';
import 'container.dart' as customContainer;
import 'user_containers.dart';

class Groceries extends StatefulWidget {
  final StowUser user;

  const Groceries({Key? key, required this.user}) : super(key: key);

  @override
  State<Groceries> createState() => _GroceriesState();
}

class _GroceriesState extends State<Groceries> {
  //Pantry({Key? key, required this.data}) : super(key: key);
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

  //var containerStream;

  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration.zero, () async {
    //   getContainerStream();
    // });
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Groceries"),
    ),
    body: Center(child: Text("Implement Groceries")),
  );
  }
}
