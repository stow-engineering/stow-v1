import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:stow/bloc/food_bloc.dart';
import 'package:stow/bloc/food_state.dart';
import 'package:stow/models/food_item.dart';

import '../bloc/containers_bloc.dart';
import '../bloc/containers_state.dart';
import '../utils/firebase_storage.dart';

class FoodItemList extends StatefulWidget {
  const FoodItemList({Key? key}) : super(key: key);
  @override
  _FoodItemListState createState() => _FoodItemListState();
}

class _FoodItemListState extends State<FoodItemList> {
  @override
  Widget build(BuildContext context) {
    final stateBloc = BlocProvider.of<FoodItemsBloc>(context);

    return BlocBuilder<FoodItemsBloc, FoodItemsState>(
        bloc: stateBloc,
        builder: (context, state) {
          return state.foodItems == null
              ? Container()
              : Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: SizedBox(
                    height: 245,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      //shrinkWrap: true,
                      //physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.foodItems.length,
                      itemBuilder: (context, index) {
                        return HorizontalFoodItemDisplay(
                            foodItem: state.foodItems[index]);
                      },
                    ),
                  ),
                );
        });
  }
}

class FoodItemDisplay extends StatelessWidget {
  final FoodItem foodItem;

  FoodItemDisplay(this.foodItem);

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
                    '/edit_food_item',
                    arguments: foodItem,
                  );
                },
              ),
              title: Text(foodItem.name.toString(),
                  style: const TextStyle(
                      fontWeight:
                          FontWeight.bold)), //Text(foodItem.value.toString())),
            )));
  }
}

class HorizontalFoodItemDisplay extends StatelessWidget {
  HorizontalFoodItemDisplay({Key? key, required this.foodItem})
      : super(key: key);

  final FoodItem foodItem;

  MaterialColor getDaysLeftColor(int daysLeft) {
    if (daysLeft <= 3) {
      return Colors.red;
    } else if (daysLeft <= 6) {
      return Colors.yellow;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final storage = Provider.of<Storage>(context);
    var image = storage.getFoodItemImage(foodItem.name);
    String daysLeftString;
    int daysLeft = 0;
    if (foodItem.expDate == null) {
      daysLeftString = "";
    } else {
      final months = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ];
      // var year = foodItem.expDate?.year.toString();
      // var month = months[foodItem.expDate!.month];
      // var day = foodItem.expDate?.month.toString();
      // date = "$month $day, $year";
      DateTime today = DateTime.now();
      daysLeft = foodItem.expDate!.difference(today).inDays;
      if (daysLeft < 1) {
        daysLeftString = "";
      } else {
        daysLeftString = daysLeft.toString();
      }
    }
    return Padding(
        padding: EdgeInsets.only(right: 8.0),
        child: Card(
            clipBehavior: Clip.antiAlias,
            margin: EdgeInsets.fromLTRB(10, 6, 10, 0),
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FutureBuilder<String>(
                  future: image,
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data != null) {
                        if (snapshot.data == "HTTP_ERROR") {
                          return const SizedBox(
                            height: 175,
                            child: CircularProgressIndicator.adaptive(),
                          );
                        }
                        return Container(
                          width: 250,
                          height: 175,
                          child: Image.network(snapshot.data as String,
                              fit: BoxFit.contain),
                        );
                      } else {
                        return const SizedBox(
                          height: 175,
                          child: CircularProgressIndicator.adaptive(),
                        );
                      }
                    } else {
                      return const SizedBox(
                        height: 175,
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }
                  },
                ),
                Container(
                  width: 250,
                  height: 50,
                  child: ListTile(
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            '/edit_food_item',
                            arguments: foodItem,
                          );
                        },
                      ),
                      title: Text(foodItem.name.toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight
                                  .bold)), //Text(foodItem.value.toString())),
                      subtitle: daysLeftString == ""
                          ? const Text("EXPIRED",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold))
                          : Row(
                              children: <Widget>[
                                Text(daysLeftString,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: getDaysLeftColor(daysLeft))),
                                const Text(" days until expired",
                                    style: TextStyle(
                                      color: Colors.grey,
                                    )),
                              ],
                            )),
                )
              ],
            )));
  }
}
