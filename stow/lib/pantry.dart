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

class Pantry extends StatefulWidget {
  final StowUser user;

  const Pantry({Key? key, required this.user}) : super(key: key);

  @override
  State<Pantry> createState() => _PantryState();
}

class _PantryState extends State<Pantry> {
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
    DatabaseService service = DatabaseService(widget.user.uid);
    return FutureBuilder<Stream<List<customContainer.Container>>>(
        future: DatabaseService(widget.user.uid).containers,
        builder: (_,
            AsyncSnapshot<Stream<List<customContainer.Container>>> snapshot) {
          //if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            return StreamProvider<List<customContainer.Container>>.value(
              value: snapshot.data,
              child: Scaffold(
                floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        '/provision',
                        arguments: 'provision',
                      );
                    },
                    child: const Icon(Icons.add)),
                appBar: AppBar(),
                body: ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 0, bottom: 15),
                      child: Card(
                        elevation: 0.0,
                        color: const Color.fromARGB(255, 237, 248, 255),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 5, top: 0, bottom: 5),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    NumberContainers(user: widget.user),
                                    const Text(
                                      "Containers",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 175,
                                  padding: const EdgeInsets.all(25),
                                  child: FutureBuilder(
                                    future: NumFull.getData(service),
                                    builder: (_,
                                        AsyncSnapshot<List<ContainerSeries>>
                                            snapshot) {
                                      if (snapshot.hasData) {
                                        return ContainerChart(
                                            data: snapshot.data);
                                      } else {
                                        return const SizedBox(
                                          width: 60,
                                          height: 60,
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Center(
                      child: Text(
                        "Your Pantry",
                        style: TextStyle(color: Colors.black, fontSize: 35),
                      ),
                    ),
                    ContainerList(),
                  ],
                ),
              ),
            );
          } else {
            return const SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(),
            );
          }

          //} else {
          //  return const CircularProgressIndicator();
          //}
        });
  }
}
