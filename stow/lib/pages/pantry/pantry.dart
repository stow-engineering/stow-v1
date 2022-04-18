import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../container_widgets/container_chart.dart';
import '../../container_widgets/container_list.dart';
import '../../container_widgets/user_containers.dart';
import '../../models/container.dart' as customContainer;
import '../../models/container_series.dart';
import '../../models/user.dart';
import '../../utils/firebase.dart';
import '../login/login.dart';

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
    FirebaseService service = FirebaseService(widget.user.uid);
    return FutureBuilder<Stream<List<customContainer.Container>>>(
        future: FirebaseService(widget.user.uid).containers,
        builder: (_,
            AsyncSnapshot<Stream<List<customContainer.Container>>> snapshot) {
          //if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            return StreamProvider<List<customContainer.Container>>.value(
              value: snapshot.data,
              child: Scaffold(
                floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      // Navigator.of(context).pushNamed(
                      //   '/add_container',
                      //   arguments: widget.user,
                      // );
                      Navigator.of(context)
                          .pushNamed(
                            '/provision',
                            arguments: widget.user,
                          )
                          .then((_) => setState(() {}));
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
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator()),
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
                    ContainerList(uid: widget.user.uid),
                  ],
                ),
              ),
            );
          } else {
            // return const SizedBox(
            //   width: 60,
            //   height: 60,
            //   child: CircularProgressIndicator(),
            // );
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    // Navigator.of(context).pushNamed(
                    //   '/add_container',
                    //   arguments: widget.user,
                    // );
                    Navigator.of(context).pushNamed(
                      '/provision',
                      arguments: widget.user,
                    );
                  },
                  child: const Icon(Icons.add)),
              appBar: AppBar(),
              body: const Center(
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 15),
                  child: Text(
                    'Add Containers to View Pantry!',
                    style: TextStyle(color: Colors.black, fontSize: 35),
                  ),
                ),
              ),
            );
          }

          //} else {
          //  return const CircularProgressIndicator();
          //}
        });
  }
}
