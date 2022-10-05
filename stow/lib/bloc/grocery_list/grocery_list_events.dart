import 'package:flutter/material.dart';
import '../../models/food_item.dart';

@immutable
abstract class GroceryListEvents {
  const GroceryListEvents([List props = const []]);
}

class LoadGroceryList extends GroceryListEvents {
  final String uid;

  LoadGroceryList(this.uid) : super([uid]);

  @override
  String toString() => 'LoadGroceryList';
}

class AddToGroceryList extends GroceryListEvents {
  final List<FoodItem> foodItems;

  AddToGroceryList(this.foodItems) : super([foodItems]);

  @override
  String toString() => 'AddToGroceryList { foodItem: $foodItems }';
}

class UpdateGroceryList extends GroceryListEvents {
  final FoodItem foodItem;

  UpdateGroceryList(this.foodItem) : super([foodItem]);

  @override
  String toString() => 'UpdateGroceryList { foodItem: $foodItem }';
}

class DeleteFromGroceryList extends GroceryListEvents {
  final FoodItem foodItem;

  DeleteFromGroceryList(this.foodItem) : super([foodItem]);

  @override
  String toString() => 'DeleteFromGroceryList { foodItem: $foodItem }';
}

class AddLowContainers extends GroceryListEvents {
  @override
  String toString() => 'AddLowContainers';
}
