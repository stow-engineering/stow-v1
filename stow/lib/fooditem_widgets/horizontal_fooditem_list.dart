import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stow/bloc/food/food_bloc.dart';
import 'package:stow/bloc/food/food_events.dart';
import 'package:stow/models/food_item.dart';
import 'package:stow/utils/firebase_storage.dart';

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
                Container(
                  width: 250,
                  height: 175,
                  child: getFoodImage(foodItem),
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
