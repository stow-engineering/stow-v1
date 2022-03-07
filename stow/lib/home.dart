import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stow/container_chart.dart';
import 'package:stow/database.dart';
import 'container_list.dart';
import 'user_auth.dart';
import 'login.dart';
import 'container_series.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'container_chart.dart';
import 'container.dart' as customContainer;

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

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
    final authService = Provider.of<AuthService>(context);
    final GlobalKey<ScaffoldState> _key = GlobalKey();

    return StreamProvider<List<customContainer.Container>>.value(
      value: DatabaseService('').containers,
      child: Scaffold(
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
        appBar: AppBar(
            leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => {_key.currentState!.openDrawer()},
        )),
        body: ContainerList(),
        // body: ListView(
        //   children: <Widget>[
        //     Container(
        //       width: 300,
        //       height: 250,
        //       child: Image.asset('assets/hat.png'),
        //     ),
        //     Padding(
        //       padding:
        //           const EdgeInsets.only(left: 0, right: 0, top: 30, bottom: 15),
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: const <Widget>[
        //           Text(
        //             "Hi there, ",
        //             style: TextStyle(color: Colors.black, fontSize: 35),
        //           ),
        //           Text(
        //             "Andrew",
        //             style: TextStyle(
        //                 color: Colors.green,
        //                 fontSize: 35,
        //                 fontWeight: FontWeight.bold),
        //           ),
        //         ],
        //       ),
        //     ),
        //     Padding(
        //       padding:
        //           const EdgeInsets.only(left: 0, right: 220, top: 30, bottom: 0),
        //       child: TextButton.icon(
        //         onPressed: () => {},
        //         icon: const Icon(Icons.arrow_forward_ios,
        //             size: 15, color: Colors.grey),
        //         label: const Text(
        //           "Your Pantry",
        //           style: TextStyle(color: Colors.grey, fontSize: 15),
        //         ),
        //       ),
        //     ),
        //     Padding(
        //       padding: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 15),
        //       child: Card(
        //         elevation: 0.0,
        //         color: Color.fromARGB(255, 237, 248, 255),
        //         child: Padding(
        //           padding: EdgeInsets.only(left: 20, right: 5, top: 0, bottom: 5),
        //           child: Row(
        //             children: <Widget>[
        //               Column(
        //                 children: const <Widget>[
        //                   Text(
        //                     "23",
        //                     style: TextStyle(
        //                         color: Colors.black,
        //                         fontSize: 60,
        //                         fontWeight: FontWeight.bold),
        //                   ),
        //                   Text(
        //                     "Containers",
        //                     style: TextStyle(color: Colors.black, fontSize: 15),
        //                   ),
        //                 ],
        //               ),
        //               Expanded(
        //                 child: Container(
        //                   height: 175,
        //                   padding: EdgeInsets.all(25),
        //                   child: ContainerChart(data: data),
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
