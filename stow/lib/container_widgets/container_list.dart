import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:stow/bloc/containers/containers_bloc.dart';
import 'package:stow/bloc/containers/containers_state.dart';
import 'package:stow/utils/firebase_storage.dart';
import '../models/container.dart' as customContainer;
import 'package:stow/fooditem_widgets/horizontal_fooditem_list.dart';

class ContainerList extends StatefulWidget {
  const ContainerList({Key? key}) : super(key: key);
  @override
  _ContainerListState createState() => _ContainerListState();
}

class _ContainerListState extends State<ContainerList> {
  @override
  Widget build(BuildContext context) {
    final stateBloc = BlocProvider.of<ContainersBloc>(context);

    return BlocBuilder<ContainersBloc, ContainersState>(
        bloc: stateBloc,
        builder: (context, state) {
          return state.containers == null
              ? Container()
              : Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: SizedBox(
                    height: 275,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      //shrinkWrap: true,
                      //physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.containers.length,
                      itemBuilder: (context, index) {
                        return HorizontalContainerDisplay(
                            container: state.containers[index]);
                      },
                    ),
                  ),
                );
        });
  }
}

class HorizontalContainerDisplay extends StatelessWidget {
  HorizontalContainerDisplay({Key? key, required this.container})
      : super(key: key);

  final customContainer.Container container;

  @override
  Widget build(BuildContext context) {
    // final storage = Provider.of<Storage>(context);
    // var image = storage.getFoodItemImage(container.name);
    return Padding(
        padding: EdgeInsets.only(right: 8.0),
        child: GestureDetector(
          onTap: () => {
            Navigator.of(context).pushNamed(
              '/edit-container',
              arguments: container,
            )
          },
          child: Card(
              clipBehavior: Clip.antiAlias,
              margin: EdgeInsets.fromLTRB(10, 6, 10, 0),
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 250,
                    height: 175,
                    child: HorizontalMiniFoodItemDisplay.getFoodImage(
                        container.name),
                  ),
                  Container(
                    width: 250,
                    height: 50,
                    child: ListTile(
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            '/edit-container',
                            arguments: container,
                          );
                        },
                      ),
                      leading: CircularProgressIndicator(
                        value: container.size == 'Small'
                            ? ((165 - container.value) / 165)
                            : ((273 - container.value) / 273),
                        color: getColor(container.size == 'Small'
                            ? 1 - ((165 - container.value) / 165)
                            : 1 - ((273 - container.value) / 273)),
                        backgroundColor: Colors.grey[350],
                        strokeWidth: 8.0,
                      ),
                      title: Text(container.name.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: container.size == 'Small'
                          ? Text(calculateVolume(true, container))
                          : Text(calculateVolume(false,
                              container)), //Text(container.value.toString())),
                    ),
                  )
                ],
              )),
        ));
  }

  MaterialColor getColor(double value) {
    if (value > 0.50) {
      return Colors.red;
    } else if (value <= 0.50 && value >= 0.25) {
      return Colors.yellow;
    } else {
      return Colors.green;
    }
  }

  String calculateVolume(bool small, customContainer.Container container) {
    if (small) {
      double valueFull = ((165 - container.value) / 165) * 100;
      int value = valueFull.round();
      if (value >= 0 && value <= 100) {
        return value.toString() + "% [" + container.size + "]";
      } else if (value < 0) {
        return "0% [" + container.size + "]";
      } else {
        return "100% [" + container.size + "]";
      }
    } else {
      double valueFull = ((273 - container.value) / 273) * 100;
      int value = valueFull.round();
      if (value >= 0 && value <= 100) {
        return value.toString() + "% [" + container.size + "]";
      } else if (value < 0) {
        return "0% [" + container.size + "]";
      } else {
        return "100% [" + container.size + "]";
      }
    }
  }
}

class ContainerDisplay extends StatelessWidget {
  final customContainer.Container container;

  ContainerDisplay(this.container);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Card(
            margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
            child: ListTile(
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    '/edit-container',
                    arguments: container,
                  );
                },
              ),
              leading: CircularProgressIndicator(
                value: container.size == 'Small'
                    ? 1 - ((165 - container.value) / 165)
                    : 1 - ((273 - container.value) / 273),
                color: Colors.green,
                backgroundColor: Colors.grey[350],
                strokeWidth: 8.0,
              ),
              title: Text(container.name.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: container.size == 'Small'
                  ? Text(calculateVolume(true, container))
                  : Text(calculateVolume(
                      false, container)), //Text(container.value.toString())),
            )));
  }

  String calculateVolume(bool small, customContainer.Container container) {
    if (small) {
      double valueFull = ((165 - container.value) / 165) * 100;
      int value = valueFull.round();
      if (value >= 0 && value <= 100) {
        return value.toString() + "% [" + container.size + "]";
      } else if (value < 0) {
        return "0% [" + container.size + "]";
      } else {
        return "100% [" + container.size + "]";
      }
    } else {
      double valueFull = ((273 - container.value) / 273) * 100;
      int value = valueFull.round();
      if (value >= 0 && value <= 100) {
        return value.toString() + "% [" + container.size + "]";
      } else if (value < 0) {
        return "0% [" + container.size + "]";
      } else {
        return "100% [" + container.size + "]";
      }
    }
  }
}
