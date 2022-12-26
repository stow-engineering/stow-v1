// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
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

class AddNewGroceryList extends GroceryListEvents {
  final List<String> foodItems;
  final bool containerGroceryList;
  final String name;

  AddNewGroceryList(this.foodItems, this.containerGroceryList, this.name)
      : super([foodItems, containerGroceryList, name]);

  @override
  String toString() =>
      'AddToGroceryList { foodItem: $foodItems, containerGroceryList: $containerGroceryList, name: $name }';
}

class AddToGroceryList extends GroceryListEvents {
  final List<String> foodItems;
  final String id;

  AddToGroceryList(this.foodItems, this.id) : super([foodItems, id]);

  @override
  String toString() => 'AddToGroceryList { foodItem: $foodItems }';
}

class DeleteFoodItemGroceryList extends GroceryListEvents {
  final String foodItem;
  final String id;

  DeleteFoodItemGroceryList(this.foodItem, this.id) : super([foodItem, id]);

  @override
  String toString() => 'DeleteFromGroceryList { foodItem: $foodItem, id: $id }';
}

class DeleteGroceryList extends GroceryListEvents {
  final String id;

  DeleteGroceryList(this.id) : super([id]);

  @override
  String toString() => 'DeleteFromGroceryList { id: $id }';
}

class AddLowContainers extends GroceryListEvents {
  @override
  String toString() => 'AddLowContainers';
}
