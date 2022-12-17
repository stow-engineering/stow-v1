import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:stow/bloc/auth/auth_bloc.dart';
import 'package:stow/bloc/containers/containers_bloc.dart';
import 'package:stow/bloc/containers/containers_events.dart';
import 'package:stow/bloc/containers/containers_state.dart';
import 'package:stow/bloc/food/food_bloc.dart';
import 'package:stow/bloc/food/food_state.dart';
import 'package:stow/container_widgets/food_item_list.dart';
import 'package:stow/expandable_fab/action_button.dart';
import 'package:stow/expandable_fab/expandable_fab.dart';
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
    final authBloc = BlocProvider.of<AuthBloc>(context);
    FirebaseService service = Provider.of<FirebaseService>(context);

    return BlocBuilder<ContainersBloc, ContainersState>(
        bloc: stateBloc,
        builder: (context, state) {
          return Scaffold(
            floatingActionButton: ExpandableFab(
                initialOpen: false,
                distance: 80.0,
                children: [
                  ActionButton(
                    onPressed: () => {
                      Navigator.of(context)
                          .pushNamed(
                            '/provision',
                            arguments: authBloc.state.user,
                          )
                          .then((_) => setState(() {}))
                    },
                    icon: const Icon(Icons.delete_outlined),
                  ),
                  ActionButton(
                    onPressed: () => {
                      Navigator.of(context)
                          .pushNamed(
                            '/add-food-item',
                          )
                          .then((_) => setState(() {}))
                    },
                    icon: const Icon(Icons.breakfast_dining_outlined),
                  ),
                ],
                key: const Key("ExpandableFab")),
            appBar: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
            ),
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
                              key: const Key("ContainerChart"),
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
                ContainerListWrapper(),
                FoodItemListWrapper(),
              ],
            ),
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
