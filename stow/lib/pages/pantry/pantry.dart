import 'package:charts_flutter/flutter.dart' as charts;
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
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
import 'package:stow/bloc/food/food_state.dart';
import 'package:stow/bloc/recipes_bloc.dart';
import 'package:stow/bloc/recipes_events.dart';
import 'package:stow/container_widgets/food_item_list.dart';
import 'package:stow/expandable_fab/action_button.dart';
import 'package:stow/expandable_fab/expandable_fab.dart';
import 'package:stow/widgets/custom_navbar.dart';
import 'package:stow/widgets/greeting_widget.dart';
import 'package:stow/widgets/modal_sheet_button.dart';
import 'package:stow/widgets/splash_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../container_widgets/container_chart.dart';
import '../../container_widgets/container_list.dart';
import '../../models/container.dart' as customContainer;
import '../../utils/firebase.dart';

class Pantry extends StatefulWidget {
  const Pantry({Key? key}) : super(key: key);

  @override
  State<Pantry> createState() => _PantryState();
}

class _PantryState extends State<Pantry> {
  @override
  void initState() {
    super.initState();
    getIncomingContainers();
  }

  List<customContainer.Container>? incomingContainers;

  void getIncomingContainers() async {
    final stateBloc = BlocProvider.of<ContainersBloc>(context);
    var containerStream = await context.read<FirebaseService>().containers;
    containerStream.listen((event) {
      incomingContainers = event;
      if (incomingContainers != null) {
        List<customContainer.Container> currentContainers =
            stateBloc.state.containers;
        currentContainers.sort();
        incomingContainers!.sort();
        bool updatedContainers = false;
        if (incomingContainers!.length != currentContainers.length) {
          updatedContainers = true;
        } else {
          for (int i = 0; i < incomingContainers!.length; i++) {
            if (incomingContainers![i].value != currentContainers[i].value) {
              updatedContainers = true;
              break;
            }
          }
        }
        if (updatedContainers) {
          stateBloc.add(LoadContainers());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final stateBloc = BlocProvider.of<ContainersBloc>(context);
    context.read<ContainersBloc>().add(LoadContainers());
    context.read<RecipesBloc>().add(LoadRecipes());
    context.read<FoodItemsBloc>().add(LoadFoodItems());
    //context.read<RecipesBloc>().add(LoadRecipes());
    final userBloc = BlocProvider.of<AuthBloc>(context);
    if (userBloc.state.firstname == null || userBloc.state.lastname == null) {
      userBloc.add(GetNameEvent());
    }
    final GlobalKey<ScaffoldState> _key = GlobalKey();
    final authBloc = BlocProvider.of<AuthBloc>(context);
    FirebaseService service = Provider.of<FirebaseService>(context);

    return BlocBuilder<ContainersBloc, ContainersState>(
        bloc: stateBloc,
        builder: (context, containersState) {
          return BlocBuilder<AuthBloc, AuthState>(
              bloc: authBloc,
              builder: (context, state) {
                if (state.firstname == null || state.lastname == null) {
                  return StowSplashScreen();
                }
                return Scaffold(
                  key: _key,
                  floatingActionButton: HomeActionButton(
                    onPressed: () => {showBottomButtons(context)},
                    icon: const Icon(Icons.add),
                  ),
                  drawer: Drawer(
                      child: ListView(
                          children: [
                        const Icon(Icons.person_rounded,
                            size: 200, color: Color.fromARGB(255, 0, 176, 80)),
                        BlocBuilder<AuthBloc, AuthState>(
                            bloc: authBloc,
                            builder: (context, state) {
                              String? fullname =
                                  state.firstname! + state.lastname!;
                              return Center(child: Text(fullname));
                            }),
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                '/account',
                                arguments: authBloc.state.user,
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
                        // TextButton(
                        //   onPressed: () {
                        //     Navigator.of(context).pushNamed(
                        //       '/pantry',
                        //     );
                        //   },
                        //   child: Row(children: const [
                        //     Icon(Icons.kitchen, color: Colors.black),
                        //     Text(
                        //       'Check your pantry',
                        //       style: TextStyle(
                        //           color: Colors.black,
                        //           fontSize: 20,
                        //           fontWeight: FontWeight.w300),
                        //     ),
                        //   ]),
                        // ),
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
                            List<String> items =
                                List<String>.empty(growable: true);
                            final foodItemBloc =
                                BlocProvider.of<FoodItemsBloc>(context);
                            foodItemBloc.state.foodItems.forEach(
                              (element) {
                                items.add(element.name);
                              },
                            );
                            _launchUrl(items);
                          },
                          child: Row(children: const [
                            Icon(Icons.delivery_dining_outlined,
                                color: Colors.black),
                            Text(
                              'Order from Instacart',
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300),
                            ),
                          ]),
                        ),
                        // TextButton(
                        //   onPressed: () {
                        //     Navigator.of(context).pushNamed('/barcode');
                        //   },
                        //   child: Row(children: const [
                        //     Icon(Icons.scanner, color: Colors.black),
                        //     Text(
                        //       'Scan barcode',
                        //       style: TextStyle(
                        //           color: Colors.black,
                        //           fontSize: 20,
                        //           fontWeight: FontWeight.w300),
                        //     ),
                        //   ]),
                        // ),
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
                  //bottomNavigationBar: CustomNavBar(),
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
                    backgroundColor: Colors.white,
                    elevation: 0,
                  ),
                  body: ListView(
                    children: <Widget>[
                      GreetingWidget(),
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
                                        containersState.numContainers
                                            .toString(),
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
                                    key: const Key("ContainerChart"),
                                    height: 175,
                                    padding: const EdgeInsets.all(25),
                                    child: ContainerChart(
                                        data: NumFull.getSeries(
                                            containersState.containers)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      ContainerListWrapper(),
                      FoodItemListWrapper(),
                    ],
                  ),
                );
              }
              // child: Scaffold(
              //   floatingActionButton: ExpandableFab(
              //       initialOpen: false,
              //       distance: 80.0,
              //       children: [
              //         CustomTextButton(
              //           onPressed: () => {
              //             Navigator.of(context)
              //                 .pushNamed(
              //                   '/provision',
              //                   arguments: authBloc.state.user,
              //                 )
              //                 .then((_) => setState(() {}))
              //           },
              //           text: const Text('Add Stow Container',
              //               style: TextStyle(
              //                   color: Colors.white, fontWeight: FontWeight.bold)),
              //         ),
              //         CustomTextButton(
              //           onPressed: () => {
              //             Navigator.of(context)
              //                 .pushNamed(
              //                   '/add-food-item',
              //                 )
              //                 .then((_) => setState(() {}))
              //           },
              //           text: const Text('Add Food Item',
              //               style: TextStyle(
              //                   color: Colors.white, fontWeight: FontWeight.bold)),
              //         ),
              //       ],
              //       key: const Key("ExpandableFab")),
              //   appBar: AppBar(
              //     backgroundColor: Theme.of(context).primaryColor,
              //   ),
              //   body: ListView(
              //     children: <Widget>[
              //       Padding(
              //         padding: const EdgeInsets.only(
              //             left: 20, right: 20, top: 0, bottom: 15),
              //         child: Card(
              //           elevation: 0.0,
              //           color: const Color.fromARGB(255, 237, 248, 255),
              //           child: Padding(
              //             padding: const EdgeInsets.only(
              //                 left: 20, right: 5, top: 0, bottom: 5),
              //             child: Row(
              //               children: <Widget>[
              //                 Expanded(
              //                   child: Column(
              //                     children: <Widget>[
              //                       Text(
              //                         state.numContainers.toString(),
              //                         style: TextStyle(
              //                             color: Colors.black,
              //                             fontSize: 45,
              //                             fontWeight: FontWeight.bold),
              //                       ),
              //                       const Text(
              //                         "Containers",
              //                         style: TextStyle(
              //                             color: Colors.black, fontSize: 15),
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //                 Expanded(
              //                   child: Container(
              //                     key: const Key("ContainerChart"),
              //                     height: 175,
              //                     padding: const EdgeInsets.all(25),
              //                     child: ContainerChart(
              //                         data: NumFull.getSeries(state.containers)),
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ),
              //       ),
              //       ContainerListWrapper(),
              //       FoodItemListWrapper(),
              //     ],
              //   ),
              // ),
              );
        });
  }

  Widget ContainerListWrapper() {
    final containerBloc = BlocProvider.of<ContainersBloc>(context);
    if (containerBloc.state.numContainers > 0) {
      return Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          key: const Key("ContainerListWrapper"),
          initiallyExpanded: true,
          title: const Text(
            "Containers",
            style: TextStyle(
                color: Colors.black, fontSize: 35, fontWeight: FontWeight.bold),
          ),
          children: <Widget>[
            Column(
              children: const <Widget>[ContainerList()],
            ),
          ],
        ),
      );
    }
    return SizedBox.shrink();
  }

  Widget FoodItemListWrapper() {
    final foodItemBloc = BlocProvider.of<FoodItemsBloc>(context);
    return BlocBuilder<FoodItemsBloc, FoodItemsState>(
        bloc: foodItemBloc,
        builder: (context, state) {
          if (foodItemBloc.state.numItems > 0) {
            return Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                key: const Key("FoodItemListWrapper"),
                initiallyExpanded: true,
                title: const Text(
                  "Food Items",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 35,
                      fontWeight: FontWeight.bold),
                ),
                children: <Widget>[
                  Column(
                    children: const <Widget>[FoodItemList()],
                  ),
                ],
              ),
            );
          } else {
            return SizedBox.shrink();
          }
        });
  }
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

Future showBottomButtons(context) {
  return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 175,
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ModalSheetButton(
                    text: 'Add Food Item', route: '/add-food-item'),
                Container(
                  color: Colors.black,
                  height: 1,
                ),
                ModalSheetButton(
                    text: 'Add Container',
                    route: '/provision',
                    args: BlocProvider.of<AuthBloc>(context).state.user),
                Container(height: 20),
              ],
            ),
          ),
        );
      });
}
