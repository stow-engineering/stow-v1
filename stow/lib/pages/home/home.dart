import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:stow/bloc/containers_events.dart';
import 'package:stow/bloc/food_bloc.dart';
import 'package:stow/bloc/food_events.dart';
import 'package:stow/bloc/recipes_events.dart';
import 'package:stow/pages/recipes/recipes_overview.dart';
import 'package:stow/bloc/containers_state.dart';

import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_events.dart';
import '../../bloc/auth_state.dart';
import '../../bloc/containers_bloc.dart';
import '../../bloc/recipes_bloc.dart';
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
import 'package:charts_flutter/flutter.dart' as charts;
import '../../bloc/containers_state.dart';
import '../../bloc/recipes_state.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseService service = Provider.of<FirebaseService>(context);
    final stateBloc = BlocProvider.of<ContainersBloc>(context);
    final recipeBloc = BlocProvider.of<RecipesBloc>(context);
    context.read<ContainersBloc>().add(LoadContainers());
    context.read<RecipesBloc>().add(LoadRecipes());
    context.read<FoodItemsBloc>().add(LoadFoodItems());
    //context.read<RecipesBloc>().add(LoadRecipes());
    final userBloc = BlocProvider.of<AuthBloc>(context);
    bool loadedContainerData = false;
    final GlobalKey<ScaffoldState> _key = GlobalKey();
    List<customContainer.Container> containerData =
        <customContainer.Container>[];

    return Scaffold(
      key: _key,
      drawer: Drawer(
          child: ListView(
              children: [
            const Icon(Icons.person_rounded,
                size: 200, color: Color.fromARGB(255, 0, 176, 80)),
            BlocBuilder<AuthBloc, AuthState>(
                bloc: userBloc,
                builder: (context, state) {
                  String? fullname = state.firstname! + state.lastname!;
                  return Center(child: Text(fullname));
                }),
            // BlocBuilder<RecipesBloc, RecipesState>(
            //     bloc: recipeBloc,
            //     builder: (context, state) {
            //       return null;
            //     }),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    '/account',
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
                Navigator.of(context).pushNamed('/barcode');
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
                    context.read<AuthBloc>().add(LogoutEvent());
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
              )
            }
          else if (selected == 1)
            {
              Navigator.of(context).pushNamed(
                '/pantry', 
              )
            }
          else if (selected == 2)
            {
              Navigator.of(context).pushNamed(
                '/recipes',
              )
            }
          else if (selected == 3)
            {
              Navigator.of(context).pushNamed(
                '/groceries',
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
                BlocBuilder<AuthBloc, AuthState>(
                    bloc: userBloc,
                    builder: (context, state) {
                      String? fullname = state.firstname!;
                      return Text(fullname,
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 35,
                              fontWeight: FontWeight.bold));
                    }),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 0, right: 220, top: 30, bottom: 0),
            child: TextButton.icon(
              onPressed: () => {
                Navigator.of(context).pushNamed(
                  '/pantry',
                )
                // .then((_) => setState(() {}))
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
                        BlocBuilder<ContainersBloc, ContainersState>(
                            bloc: stateBloc,
                            builder: (context, state) {
                              return Text(
                                state.numContainers.toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 45,
                                    fontWeight: FontWeight.bold),
                              );
                            }),
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
                        child: BlocBuilder<ContainersBloc, ContainersState>(
                            bloc: stateBloc,
                            builder: (context, state) {
                              return ContainerChart(
                                  data: NumFull.getSeries(state.containers));
                            }),
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

class RecipeArguments {
  StowUser user;
  List<customContainer.Container> containerData;

  RecipeArguments(this.user, this.containerData);
}
