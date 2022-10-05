import 'package:stow/bloc/containers_bloc.dart';
import 'package:stow/models/food_item.dart';
import 'package:stow/models/container.dart' as customContainer;

class GroceryList {
  DateTime? creationDate;
  List<FoodItem>? foodItems;

  GroceryList({
    this.creationDate,
    this.foodItems,
  });

  GroceryList copyWith({DateTime? creationDate, List<FoodItem>? foodItems}) {
    return GroceryList(
        creationDate: creationDate ?? this.creationDate,
        foodItems: foodItems ?? this.foodItems);
  }

  void addLowContainers(ContainersBloc bloc) {
    List<customContainer.Container> containerList = bloc.state.containers;
    List<FoodItem> newFoodItems = [];
    for (int i = 0; i < containerList.length; i++) {
      if (!containerList[i].full) {
        newFoodItems.add(FoodItem(name: containerList[i].name));
      }
    }
  }
}
