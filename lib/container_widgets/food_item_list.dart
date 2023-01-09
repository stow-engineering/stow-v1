// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:stow/bloc/food/food_bloc.dart';
import 'package:stow/bloc/food/food_state.dart';
import 'package:stow/models/food_item.dart';

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
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: SizedBox(
              height: 245,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
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

  const FoodItemDisplay(this.foodItem, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Card(
            margin: const EdgeInsets.fromLTRB(20, 6, 20, 0),
            child: ListTile(
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    '/edit-food-item',
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
  const HorizontalFoodItemDisplay({Key? key, required this.foodItem})
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

  Image getFoodImage(String name) {
    try {
      List<String> jpgs = [
        'almonds',
        'apple',
        'avocado',
        'bacon',
        'baking powder',
        'baking soda',
        'beans',
        'bell peppers',
        'blackberries',
        'blueberries',
        'bread',
        'broccoli',
        'brownies',
        'brussel sprouts',
        'butter',
        'cabbage',
        'candy',
        'carrot',
        'celery',
        'cereal',
        'cheese',
        'chicken',
        'chips',
        'cilantro',
        'coffee',
        'cookies',
        'corn',
        'crab',
        'croissant',
        'eggplant',
        'eggs',
        'fish',
        'flour',
        'garlic',
        'grape',
        'grapefruit',
        'green bean',
        'ground beef',
        'hotdog',
        'lettuce',
        'marshmello',
        'milk',
        'mushroom',
        'nuts',
        'oats',
        'onion',
        'orange',
        'oreos',
        'pasta',
        'peaches',
        'peanuts',
        'pear',
        'pears',
        'pecans',
        'peppers',
        'pickles',
        'popcorn',
        'pork',
        'potatoes',
        'rice',
        'salmon',
        'sausage',
        'shrimp',
        'snacks',
        'steak',
        'strawberries',
        'sugar',
        'tomato',
        'tortilla',
        'watermelon',
        'zuccini'
      ];
      List<String> jpegs = ['cornstarch', 'cream cheese', 'sour cream'];
      if (jpgs.contains(name)) {
        return Image(
            image: AssetImage('assets/' + name + '.jpg'), fit: BoxFit.contain);
      }
      if (jpegs.contains(name)) {
        return Image(
            image: AssetImage('assets/' + name + '.jpeg'), fit: BoxFit.contain);
      } else {
        return const Image(
            image: AssetImage('assets/stock_food.png'), fit: BoxFit.contain);
      }
    } catch (e) {
      return const Image(
          image: AssetImage('assets/stock_food.png'), fit: BoxFit.contain);
    }
  }

  @override
  Widget build(BuildContext context) {
    //final storage = Provider.of<Storage>(context);
    //var image = storage.getFoodItemImage(foodItem.name);
    String daysLeftString;
    int daysLeft = 0;
    if (foodItem.expDate == null) {
      daysLeftString = "";
    } else {
      // final months = [
      //   'January',
      //   'February',
      //   'March',
      //   'April',
      //   'May',
      //   'June',
      //   'July',
      //   'August',
      //   'September',
      //   'October',
      //   'November',
      //   'December'
      // ];
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
        padding: const EdgeInsets.only(right: 8.0),
        child: GestureDetector(
          onTap: () => {
            Navigator.of(context).pushNamed(
              '/edit-food-item',
              arguments: foodItem,
            )
          },
          child: Card(
              clipBehavior: Clip.antiAlias,
              margin: const EdgeInsets.fromLTRB(10, 6, 10, 0),
              child: Column(
                children: [
                  // ignore: sized_box_for_whitespace
                  Container(
                    width: 250,
                    height: 175,
                    child: getFoodImage(foodItem.name),
                  ),
                  // ignore: sized_box_for_whitespace
                  Container(
                    width: 250,
                    height: 50,
                    child: ListTile(
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              '/edit-food-item',
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
              )),
        ));
  }
}
