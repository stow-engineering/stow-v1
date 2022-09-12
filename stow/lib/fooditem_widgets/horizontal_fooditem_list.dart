import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stow/bloc/food_bloc.dart';
import 'package:stow/bloc/food_events.dart';
import 'package:stow/models/food_item.dart';

import '../container_widgets/food_item_list.dart';
import '../utils/firebase_storage.dart';

enum FoodItemCategory {
  FruitsAndVegtables,
  MeatAndSeafood,
  Dairy,
  PastaAndSauces,
  Snacks,
  Baking,
  BakedGoods,
  SpicesAndCondiments,
  DryGoods
}

class HorizontalFoodItemList extends StatelessWidget {
  HorizontalFoodItemList({Key? key, required this.category}) : super(key: key);

  final FoodItemCategory category;
  final fruitsAndVegtables = [
    'apple',
    'avocado',
    'bell peppers',
    'blackberries',
    'blueberries',
    'broccoli',
    'brussel sprouts',
    'cabbage',
    'carrot',
    'celery',
    'corn',
    'eggplant',
    'garlic',
    'grape',
    'grapefruit',
    'green bean',
    'lettuce',
    'mushroom',
    'onion',
    'orange',
    'peaches',
    'pear',
    'peppers',
    'potatoes',
    'strawberries',
    'tomato',
    'watermelon',
    'zuccini'
  ];
  final dryGoods = ['beans', 'cereal', 'coffee', 'oats', 'rice'];
  final meatAndSeafood = [
    'bacon',
    'chicken',
    'crab',
    'fish',
    'ground beef',
    'hotdog',
    'pork',
    'salmon',
    'sausage',
    'shrimp',
    'steak'
  ];
  final dairy = [
    'butter',
    'cheese',
    'cream cheese',
    'eggs',
    'milk',
    'sour cream'
  ];
  final pastaAndSauces = ['pasta'];
  final snacks = [
    'almonds',
    'candy',
    'chips',
    'marshmello',
    'nuts',
    'oreos',
    'peanuts',
    'pecans',
    'pickles',
    'popcorn',
    'snacks'
  ];
  final baking = [
    'baking powder',
    'baking soda',
    'cornstarch',
    'flour',
    'sugar'
  ];
  final bakedGoods = ['bread', 'brownies', 'cookies', 'croissant', 'tortilla'];
  final spicesAndCondiments = ['cilantro'];

  @override
  Widget build(BuildContext context) {
    var food_list = [];
    switch (category) {
      case FoodItemCategory.FruitsAndVegtables:
        {
          food_list = fruitsAndVegtables;
        }
        break;
      case FoodItemCategory.BakedGoods:
        {
          food_list = bakedGoods;
        }
        break;
      case FoodItemCategory.Baking:
        {
          food_list = baking;
        }
        break;
      case FoodItemCategory.Dairy:
        {
          food_list = dairy;
        }
        break;
      case FoodItemCategory.DryGoods:
        {
          food_list = dryGoods;
        }
        break;
      case FoodItemCategory.MeatAndSeafood:
        {
          food_list = meatAndSeafood;
        }
        break;
      case FoodItemCategory.PastaAndSauces:
        {
          food_list = pastaAndSauces;
        }
        break;
      case FoodItemCategory.Snacks:
        {
          food_list = snacks;
        }
        break;
      case FoodItemCategory.SpicesAndCondiments:
        {
          food_list = spicesAndCondiments;
        }
        break;
    }
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: SizedBox(
        height: 245,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: food_list.length,
          itemBuilder: (context, index) {
            return HorizontalMiniFoodItemDisplay(foodItem: food_list[index]);
          },
        ),
      ),
    );
  }
}

class HorizontalMiniFoodItemDisplay extends StatelessWidget {
  HorizontalMiniFoodItemDisplay({Key? key, required this.foodItem})
      : super(key: key);

  final String foodItem;

  @override
  Widget build(BuildContext context) {
    final storage = Provider.of<Storage>(context);
    var image = storage.getFoodItemImage(this.foodItem);
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
                        return Container(
                          width: 250,
                          height: 175,
                          child: Image.network(snapshot.data as String,
                              fit: BoxFit.contain),
                        );
                      } else {
                        return const SizedBox(
                          child: CircularProgressIndicator(),
                        );
                      }
                    } else {
                      return const SizedBox(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
                Container(
                  width: 250,
                  height: 50,
                  child: ListTile(
                    trailing: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        final name = foodItem;
                        DateTime today = DateTime.now();
                        showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: today,
                                lastDate: DateTime(
                                    today.year + 2, today.month, today.day))
                            .then((date) => {
                                  context.read<FoodItemsBloc>().add(AddFoodItem(
                                      FoodItem(
                                          name: foodItem,
                                          value: 0,
                                          barcode: "",
                                          expDate: date)))
                                });
                      },
                    ),
                    title: Text(foodItem,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            )));
  }
}
