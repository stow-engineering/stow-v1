import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:stow/utils/authentication.dart';

import '../../bloc/auth_bloc.dart';
import '../../bloc/containers_bloc.dart';
import '../../container_widgets/container_chart.dart';
import '../../container_widgets/container_list.dart';
import '../../container_widgets/user_containers.dart';
import '../../models/container.dart' as customContainer;
import '../../models/container_series.dart';
import '../../models/user.dart';
import '../../bloc/containers_state.dart';
import '../../utils/firebase.dart';
import '../login/login.dart';

class Pantry extends StatefulWidget {
  const Pantry({Key? key}) : super(key: key);

  @override
  State<Pantry> createState() => _PantryState();
}

class _PantryState extends State<Pantry> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final stateBloc = BlocProvider.of<ContainersBloc>(context);
    final authBloc = BlocProvider.of<AuthBloc>(context);
    FirebaseService service = Provider.of<FirebaseService>(context);
    return BlocBuilder<ContainersBloc, ContainersState>(
        bloc: stateBloc,
        builder: (context, state) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(
                        '/provision',
                        arguments: authBloc.state.user,
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
                                Text(
                                  state.numContainers.toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 45,
                                      fontWeight: FontWeight.bold),
                                ),
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
                              child: ContainerChart(
                                  data: NumFull.getSeries(state.containers)),
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
          );

          // } else {
          //   return Scaffold(
          //     floatingActionButton: FloatingActionButton(
          //         onPressed: () {
          //           // Navigator.of(context).pushNamed(
          //           //   '/add_container',
          //           //   arguments: widget.user,
          //           // );
          //           Navigator.of(context).pushNamed(
          //             '/provision',
          //             arguments: user,
          //           );
          //         },
          //         child: const Icon(Icons.add)),
          //     appBar: AppBar(),
          //     body: const Center(
          //       child: Padding(
          //         padding:
          //             EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 15),
          //         child: Text(
          //           'Add Containers to View Pantry!',
          //           style: TextStyle(color: Colors.black, fontSize: 35),
          //         ),
          //       ),
          //     ),
          //   );
          // }

          //} else {
          //  return const CircularProgressIndicator();
          //}
        });
  }
}
