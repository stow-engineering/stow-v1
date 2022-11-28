import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/diagnostics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:stow/bloc/auth/auth_bloc.dart';
import 'package:stow/bloc/auth/auth_events.dart';
import 'package:stow/bloc/auth/auth_state.dart';
import 'package:stow/bloc/containers/containers_bloc.dart';
import 'package:stow/bloc/containers/containers_events.dart';
import 'package:stow/bloc/containers/containers_state.dart';
import 'package:stow/bloc/food/food_bloc.dart';
import 'package:stow/bloc/food/food_events.dart';
import 'package:stow/bloc/recipes_events.dart';
import 'package:stow/pages/home/navigation_buttons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../bloc/recipes_bloc.dart';
import '../../container_widgets/container_chart.dart';
import '../../models/container.dart' as customContainer;
import '../../models/user.dart';
import '../../utils/firebase.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

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
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    '/account',
                    arguments: userBloc.state.user,
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
                  '/grocery-list-home',
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
                List<String> items = List<String>.empty(growable: true);
                final foodItemBloc = BlocProvider.of<FoodItemsBloc>(context);
                foodItemBloc.state.foodItems.forEach(
                  (element) {
                    items.add(element.name);
                  },
                );
                _launchUrl(items);
              },
              child: Row(children: const [
                Icon(Icons.delivery_dining_outlined, color: Colors.black),
                Text(
                  'Order from Instacart',
                  style: TextStyle(
                      color: Colors.green,
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
      bottomNavigationBar: CurvedNavigationBar(
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
                '/grocery-list-home',
              )
            }
          else if (selected == 2)
            {
              Navigator.of(context).pushNamed(
                '/pantry',
              )
            }
          else if (selected == 3)
            {
              Navigator.of(context).pushNamed(
                '/recipes',
              )
            }
        },
        items: const <Widget>[
          Icon(CupertinoIcons.home, size: 30, color: Colors.white),
          Icon(Icons.local_grocery_store, size: 30, color: Colors.white),
          Icon(Icons.kitchen, size: 30, color: Colors.white),
          Icon(Icons.blender, size: 30, color: Colors.white),
        ],
        color: Theme.of(context).primaryColor,
        buttonBackgroundColor: Colors.green,
        backgroundColor: Colors.white,
      ),
      appBar: AppBar(
        // shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.all(Radius.circular(25))),
        leading: IconButton(
          icon: Icon(Icons.menu),
          color: Color.fromARGB(255, 211, 220, 230),
          onPressed: () => {_key.currentState!.openDrawer()},
          iconSize: 45,
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Container(
              width: 30,
              height: 30,
              child: Image.asset('assets/small-logo-v2.png'),
            ),
          ),
        ],
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 15),
            child: SizedBox(
              child: DecoratedBox(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30))),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "Hi there, ",
                        style: TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 35,
                            fontWeight: FontWeight.bold),
                      ),
                      BlocBuilder<AuthBloc, AuthState>(
                          bloc: userBloc,
                          builder: (context, state) {
                            String? fullname = state.firstname ?? "Stow User";
                            return Text(fullname,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold));
                          }),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const NavigationButton(route: '/pantry', text: "Your Pantry"),
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
                      children: <Widget>[
                        BlocBuilder<ContainersBloc, ContainersState>(
                            bloc: stateBloc,
                            builder: (context, state) {
                              return Text(
                                state.numContainers.toString(),
                                style: const TextStyle(
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
                        padding: const EdgeInsets.all(25),
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

// launch url function
Future<void> _launchUrl(List<String> items) async {
  String site =
      "https://www.instacart.com/store/partner_recipe?title=Stows+Grocery+List";
  items.forEach((element) {
    site = site + "&ingredients%5B%5D=" + element + "%20";
  });
  Uri url = Uri.parse(site);
  if (!await launchUrl(url)) {
    throw 'Could not launch $url';
  }
}
