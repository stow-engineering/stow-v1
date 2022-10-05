import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stow/bloc/food/food_events.dart';
import 'package:stow/bloc/food/food_state.dart';
import 'package:stow/bloc/grocery_list/grocery_list_events.dart';
import 'package:stow/bloc/grocery_list/grocery_list_state.dart';
import 'package:stow/utils/firebase.dart';
import '../../models/food_item.dart';

class GroceryListBloc extends Bloc<GroceryListEvents, GroceryListState> {
  GroceryListBloc({
    required this.service,
  }) : super(const GroceryListState()) {
    on<LoadGroceryList>(_mapLoadEventToState);
    on<AddToGroceryList>(_mapAddEventToState);
  }
  final FirebaseService service;

  void _mapLoadEventToState(
      LoadGroceryList event, Emitter<GroceryListState> emit) async {
    emit(state.copyWith(status: GroceryListStatus.loading));
    try {
      //get low containers
      var lowContainers = [];
      final containers = await service.getContainerList();
      if (containers != null) {
        for (int i = 0; i < containers.length; i++) {
          var percentFull;
          if (containers[i].size == "Small") {
            percentFull = 1 - ((165 - containers[i].value) / 165);
            if (percentFull < 0.25) {
              lowContainers.add(FoodItem(name: containers[i].name));
            }
          } else {
            percentFull = 1 - ((273 - containers[i].value) / 273);
            if (percentFull < 0.25) {
              lowContainers.add(FoodItem(name: containers[i].name));
            }
          }
        }
      }

      //get grocery list

      // emit(
      //   state.copyWith(
      //     status: GroceryListStatus.success,
      //     foodItems: foodItems,
      //     numItems: foodItems!.length,
      //   ),
      // );
    } catch (error, stacktrace) {
      print(stacktrace);
      emit(state.copyWith(status: GroceryListStatus.error));
    }
  }

  void _mapAddEventToState(
      AddToGroceryList event, Emitter<GroceryListState> emit) async {
    // emit(state.copyWith(status: GroceryListStatus.loading));
    // try {
    //   List<FoodItem> newFoodItemsList = state.foodItems;
    //   DocumentReference food_uid = await service.updateFoodItemData(
    //       event.foodItem.name, event.foodItem.expDate);
    //   service.updateFoodItems(food_uid.id);
    //   FoodItem newFoodItem = FoodItem(
    //       uid: food_uid.id,
    //       barcode: event.foodItem.barcode,
    //       name: event.foodItem.name,
    //       value: event.foodItem.value,
    //       expDate: event.foodItem.expDate);
    //   newFoodItemsList.add(newFoodItem);
    //   emit(
    //     state.copyWith(
    //         status: GroceryListStatus.success,
    //         foodItems: newFoodItemsList,
    //         numItems: newFoodItemsList.length),
    //   );
    // } catch (error, stacktrace) {
    //   print(stacktrace);
    //   emit(state.copyWith(status: GroceryListStatus.error));
    // }
  }

  void _mapDeleteEventToState(
      DeleteFoodItems event, Emitter<GroceryListState> emit) async {
    emit(state.copyWith(status: GroceryListStatus.loading));
    try {
      List<FoodItem> newFoodItemsList = state.foodItems;
      newFoodItemsList.remove(event.foodItem);
      service.deleteFoodItems(event.foodItem.uid);
      emit(
        state.copyWith(
            status: GroceryListStatus.success,
            foodItems: newFoodItemsList,
            numItems: newFoodItemsList.length),
      );
    } catch (error, stacktrace) {
      print(stacktrace);
      emit(state.copyWith(status: GroceryListStatus.error));
    }
  }

  void _mapUpdateEventToState(
      UpdateFoodItems event, Emitter<GroceryListState> emit) async {
    emit(state.copyWith(status: GroceryListStatus.loading));
    try {
      List<FoodItem> newFoodItemsList = state.foodItems;
      for (int i = 0; i < newFoodItemsList.length; i++) {
        if (newFoodItemsList[i].uid == event.foodItem.uid) {
          newFoodItemsList[i].name = event.foodItem.name;
          newFoodItemsList[i].expDate = event.foodItem.expDate;
        }
      }
      var food_id = service.updateExistingFoodItem(event.foodItem);
      service.updateFoodItems(food_id.toString());
      emit(
        state.copyWith(
            status: GroceryListStatus.success,
            foodItems: newFoodItemsList,
            numItems: newFoodItemsList.length),
      );
    } catch (error, stacktrace) {
      print(stacktrace);
      emit(state.copyWith(status: GroceryListStatus.error));
    }
  }
}
