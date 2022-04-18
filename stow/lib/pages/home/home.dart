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
import '../../utils/authentication.dart';
import '../../utils/firebase.dart';
import '../login/login.dart';
import 'get_name.dart';

class Home extends StatefulWidget {
  final StowUser user;

  const Home({Key? key, required this.user}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<ContainerSeries> data = [
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
    final FirebaseService service = FirebaseService(widget.user.uid);
    final GetName firstName = GetName(widget.user.uid, false);
    final GetName fullName = GetName(widget.user.uid, true);
    final authService = Provider.of<AuthenticationService>(context);
    final GlobalKey<ScaffoldState> _key = GlobalKey();

    return Scaffold(
      key: _key,
      drawer: Drawer(
          child: ListView(
              children: [
            const Icon(Icons.person_rounded,
                size: 200, color: Color.fromARGB(255, 0, 176, 80)),
            Center(child: fullName),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    '/account',
                    arguments: widget.user,
                  );
                },
                child: Row(children: const [
                  Icon(Icons.settings, color: Colors.black),
                  Text(
                    'Profile & Settings',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w300),
                  ),
                ]),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  '/pantry',
                  arguments: widget.user,
                );
              },
              child: Row(children: const [
                Icon(Icons.kitchen, color: Colors.black),
                Text(
                  'Check your pantry',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w300),
                ),
              ]),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  '/recipes',
                  arguments: widget.user,
                );
              },
              child: Row(children: const [
                Icon(Icons.blender, color: Colors.black),
                Text(
                  'Browse recipes',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w300),
                ),
              ]),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  '/groceries',
                  arguments: widget.user,
                );
              },
              child: Row(children: const [
                Icon(Icons.settings, color: Colors.black),
                Text(
                  'Update grocery lists',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w300),
                ),
              ]),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed('/barcode', arguments: widget.user);
              },
              child: Row(children: const [
                Icon(Icons.scanner, color: Colors.black),
                Text(
                  'Scan barcode',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w300),
                ),
              ]),
            ),
            Padding(
              padding: EdgeInsets.only(top: 50),
              child: OutlinedButton(
                  onPressed: () {
                    authService.signOut();
                  },
                  // style: const ButtonStyle(side: BorderSide(color: Colors.red, width: 2),)
                  child: const Text(
                    "Sign Out",
                    style: TextStyle(color: Colors.red),
                  )),
            )
          ],
              padding: const EdgeInsets.only(
                  top: 40, bottom: 40, left: 20, right: 20))),
      backgroundColor: Colors.white,
      // floatingActionButton: FloatingActionButton(
      //     onPressed: () {},
      //     backgroundColor: Colors.green,
      //     child: const Icon(Icons.add)),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int selected) => {
          if (selected == 0)
            {
              Navigator.of(context).pushNamed(
                '/home',
                arguments: widget.user,
              )
            }
          else if (selected == 1)
            {
              Navigator.of(context).pushNamed(
                '/pantry',
                arguments: widget.user,
              )
            }
          else if (selected == 2)
            {
              Navigator.of(context).pushNamed(
                '/recipes',
                arguments: widget.user,
              )
            }
          else if (selected == 3)
            {
              Navigator.of(context).pushNamed(
                '/groceries',
                arguments: widget.user,
              )
            }
        },
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          // BottomNavigationBarItem(
          //     icon: Icon(Icons.local_grocery_store), label: 'Groceries'),
          BottomNavigationBarItem(icon: Icon(Icons.kitchen), label: 'Pantry'),
          BottomNavigationBarItem(icon: Icon(Icons.blender), label: 'Recipes'),
        ],
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          color: Color.fromARGB(255, 211, 220, 230),
          onPressed: () => {_key.currentState!.openDrawer()},
          iconSize: 45,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      // body: ContainerList(),
      body: ListView(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Container(
                width: 300,
                height: 250,
                child: Image.asset('assets/hat.png'),
              )),
          Padding(
            padding:
                const EdgeInsets.only(left: 0, right: 0, top: 30, bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "Hi there, ",
                  style: TextStyle(color: Colors.black, fontSize: 35),
                ),
                firstName,
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 0, right: 220, top: 30, bottom: 0),
            child: TextButton.icon(
              onPressed: () => {
                Navigator.of(context)
                    .pushNamed(
                      '/pantry',
                      arguments: widget.user,
                    )
                    .then((_) => setState(() {}))
              },
              icon: const Icon(Icons.arrow_forward_ios,
                  size: 15, color: Colors.grey),
              label: const Text(
                "Your Pantry",
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 15),
            child: Card(
              elevation: 0.0,
              color: Color.fromARGB(255, 237, 248, 255),
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 5, top: 0, bottom: 5),
                child: Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        NumberContainers(user: widget.user),
                        const Text(
                          "Containers",
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        height: 175,
                        padding: EdgeInsets.all(25),
                        //child: ContainerChart(data: data),
                        child: FutureBuilder(
                          future: NumFull.getData(service),
                          builder: (_,
                              AsyncSnapshot<List<ContainerSeries>> snapshot) {
                            if (snapshot.hasData) {
                              return ContainerChart(data: snapshot.data);
                            } else {
                              return const SizedBox(
                                width: 60,
                                height: 60,
                                child:
                                    Center(child: CircularProgressIndicator()),
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
        ],
      ),
    );
  }
}
