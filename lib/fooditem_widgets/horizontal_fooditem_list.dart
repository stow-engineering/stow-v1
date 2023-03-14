// Flutter imports:
// ignore_for_file: constant_identifier_names, sized_box_for_whitespace

// Flutter imports:
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:stow/bloc/food/food_bloc.dart';
import 'package:stow/bloc/food/food_events.dart';
import 'package:stow/models/food_item.dart';

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
  HorizontalFoodItemList(
      {Key? key, required this.category, required this.keyWord})
      : super(key: key);

  final FoodItemCategory category;
  final String keyWord;
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
    var foodList = [];
    String title = "";
    switch (category) {
      case FoodItemCategory.FruitsAndVegtables:
        {
          foodList = fruitsAndVegtables;
          title = "Fruits and Vegetables";
        }
        break;
      case FoodItemCategory.BakedGoods:
        {
          foodList = bakedGoods;
          title = "Baked Goods";
        }
        break;
      case FoodItemCategory.Baking:
        {
          foodList = baking;
          title = "Baking";
        }
        break;
      case FoodItemCategory.Dairy:
        {
          foodList = dairy;
          title = "Dairy";
        }
        break;
      case FoodItemCategory.DryGoods:
        {
          foodList = dryGoods;
          title = "Dry Goods";
        }
        break;
      case FoodItemCategory.MeatAndSeafood:
        {
          foodList = meatAndSeafood;
          title = "Meat and Seafood";
        }
        break;
      case FoodItemCategory.PastaAndSauces:
        {
          foodList = pastaAndSauces;
          title = "Pasta and Sauces";
        }
        break;
      case FoodItemCategory.Snacks:
        {
          foodList = snacks;
          title = "Snacks";
        }
        break;
      case FoodItemCategory.SpicesAndCondiments:
        {
          foodList = spicesAndCondiments;
          title = "Spices and Condiments";
        }
        break;
    }
    var searchedFoodList = [];
    for (int i = 0; i < foodList.length; i++) {
      if ((foodList[i] as String).contains(keyWord) || keyWord == "") {
        searchedFoodList.add(foodList[i]);
      }
    }
    if (searchedFoodList.isEmpty) {
      return Container();
    }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
              child: Text(
                title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: SizedBox(
              height: 245,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: searchedFoodList.length,
                itemBuilder: (context, index) {
                  return HorizontalMiniFoodItemDisplay(
                      foodItem: searchedFoodList[index]);
                },
              ),
            ),
          ),
        ]);
  }
}

class HorizontalMiniFoodItemDisplay extends StatelessWidget {
  const HorizontalMiniFoodItemDisplay({Key? key, required this.foodItem})
      : super(key: key);

  final String foodItem;

  static ExtendedImage getFoodImage(String name) {
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
        'zuccini',
        'cornstarch',
        'cream cheese',
        'sour cream'
      ];
      List<String> jpegs = [];
      if (jpgs.contains(name)) {
        String imagePath = 'assets/food_items_comp/' + name + '.jpg';
        return ExtendedImage.asset(
          imagePath,
          fit: BoxFit.contain,
          cacheHeight: 150,
          cacheWidth: 200,
        );
        // return Image(
        //     image: AssetImage('assets/' + name + '.jpg'), fit: BoxFit.contain);
      }
      if (jpegs.contains(name)) {
        String imagePath = 'assets/food_items_comp/' + name + '.jpeg';
        return ExtendedImage.asset(
          imagePath,
          fit: BoxFit.contain,
          cacheHeight: 150,
          cacheWidth: 200,
        );
        // return Image(
        //     image: AssetImage('assets/' + name + '.jpeg'), fit: BoxFit.contain);
      } else {
        String imagePath = 'assets/food_items_comp/stock_food.png';
        return ExtendedImage.asset(
          imagePath,
          fit: BoxFit.fill,
          cacheHeight: 150,
          cacheWidth: 200,
        );
        // return const Image(
        //     image: AssetImage('assets/stock_food.png'), fit: BoxFit.contain);
      }
    } catch (e) {
      String imagePath = 'assets/food_items_comp/stock_food.png';
      return ExtendedImage.asset(
        imagePath,
        fit: BoxFit.fill,
        cacheHeight: 150,
        cacheWidth: 200,
      );
      // return const Image(
      //     image: AssetImage('assets/stock_food.png'), fit: BoxFit.contain);
    }
  }

  @override
  Widget build(BuildContext context) {
    // final storage = Provider.of<Storage>(context);
    // var image = storage.getFoodItemImage(this.foodItem);
    return Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Card(
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.fromLTRB(10, 6, 10, 0),
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
                      icon: const Icon(Icons.add),
                      onPressed: () {
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
