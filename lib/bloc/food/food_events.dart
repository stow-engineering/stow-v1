// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:stow/models/food_item.dart';

@immutable
abstract class FoodItemsEvents {
  const FoodItemsEvents([List props = const []]);
}

class LoadFoodItems extends FoodItemsEvents {
  @override
  String toString() => 'LoadFoodItems';
}

class AddFoodItem extends FoodItemsEvents {
  final FoodItem foodItem;

  AddFoodItem(this.foodItem) : super([foodItem]);

  @override
  String toString() => 'AddFoodItem { foodItem: $foodItem }';
}

class UpdateFoodItems extends FoodItemsEvents {
  final FoodItem foodItem;

  UpdateFoodItems(this.foodItem) : super([foodItem]);

  @override
  String toString() => 'UpdateFoodItems { foodItem: $foodItem }';
}

class DeleteFoodItems extends FoodItemsEvents {
  final FoodItem foodItem;

  DeleteFoodItems(this.foodItem) : super([foodItem]);

  @override
  String toString() => 'DeleteFoodItems { foodItem: $foodItem }';
}
