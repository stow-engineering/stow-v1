// Project imports:
import 'package:stow/bloc/containers/containers_bloc.dart';
import 'package:stow/models/container.dart' as custom_container;
import 'package:stow/models/food_item.dart';

class GroceryList {
  DateTime? creationDate;
  List<String>? foodItems;
  String? id;
  String? name;
  bool? containerGroceryList;

  GroceryList(
      {this.creationDate,
      this.foodItems,
      this.id,
      this.name,
      this.containerGroceryList});

  GroceryList copyWith(
      {DateTime? creationDate,
      List<String>? foodItems,
      String? id,
      String? name,
      bool? containerGroceryList}) {
    return GroceryList(
        creationDate: creationDate ?? this.creationDate,
        foodItems: foodItems ?? this.foodItems,
        id: id ?? this.id,
        name: name ?? this.name,
        containerGroceryList:
            containerGroceryList ?? this.containerGroceryList);
  }

  void addLowContainers(ContainersBloc bloc) {
    List<custom_container.Container> containerList = bloc.state.containers;
    List<FoodItem> newFoodItems = [];
    for (int i = 0; i < containerList.length; i++) {
      if (!containerList[i].full) {
        newFoodItems.add(FoodItem(name: containerList[i].name));
      }
    }
  }
}
