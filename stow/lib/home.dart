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
import 'database.dart';
import 'first_name.dart';
import 'user_containers.dart';

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
    final DatabaseService service = DatabaseService(widget.user.uid);
    final GetFirstName firstName = GetFirstName(widget.user.uid);
    final authService = Provider.of<AuthService>(context);
    final GlobalKey<ScaffoldState> _key = GlobalKey();

    return Scaffold(
      key: _key,
      drawer: Drawer(
        child: ListView(
          children: [
            // ListTile(
            //     title: const Text('Sign Out'),
            //     onTap: () {
            //       authService.signOut();
            //     }),
            OutlinedButton(
                onPressed: () {
                  authService.signOut();
                },
                // style: const ButtonStyle(side: BorderSide(color: Colors.red, width: 2),)
                child: const Text(
                  "Sign Out",
                  style: TextStyle(color: Colors.red),
                )),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      // floatingActionButton: FloatingActionButton(
      //     onPressed: () {},
      //     backgroundColor: Colors.green,
      //     child: const Icon(Icons.add)),
      bottomNavigationBar: BottomNavigationBar(
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
        onPressed: () => {_key.currentState!.openDrawer()},
      )),
      // body: ContainerList(),
      body: ListView(
        children: <Widget>[
          Container(
            width: 300,
            height: 250,
            child: Image.asset('assets/hat.png'),
          ),
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
                // Text(
                //   "Andrew",
                //   style: TextStyle(
                //       color: Colors.green,
                //       fontSize: 35,
                //       fontWeight: FontWeight.bold),
                // ),
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
        ],
      ),
    );
  }
}
