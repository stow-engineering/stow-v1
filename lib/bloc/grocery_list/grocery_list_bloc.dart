// Dart imports:
import 'dart:developer';

// Package imports:
import 'package:bloc/bloc.dart';

// Project imports:
import 'package:stow/bloc/grocery_list/grocery_list_events.dart';
import 'package:stow/bloc/grocery_list/grocery_list_state.dart';
import 'package:stow/models/grocery_item.dart';
import 'package:stow/models/grocery_lists.dart';
import 'package:stow/utils/firebase.dart';

class GroceryListBloc extends Bloc<GroceryListEvents, GroceryListState> {
  GroceryListBloc({
    required this.service,
  }) : super(const GroceryListState()) {
    on<LoadGroceryList>(_mapLoadEventToState);
    on<AddNewGroceryList>(_mapNewGroceryListEventToState);
    on<AddToGroceryList>(_mapAddEventToState);
    on<DeleteFoodItemGroceryList>(_mapDeleteFoodItemEventToState);
    on<DeleteGroceryList>(_mapDeleteEventToState);
    on<CheckGroceryItem>(_mapCheckEventToState);
  }
  final FirebaseService service;

  void _mapLoadEventToState(
      LoadGroceryList event, Emitter<GroceryListState> emit) async {
    emit(state.copyWith(status: GroceryListStatus.loading));
    try {
      //get low containers
      List<GroceryItem> lowContainers = [];
      final containers = await service.getContainerList();
      if (containers != null) {
        if (containers.isNotEmpty) {
          for (int i = 0; i < containers.length; i++) {
            double percentFull;
            if (containers[i].size == "Small") {
              percentFull = ((165 - containers[i].value) / 165);
              if (percentFull < 0.25) {
                GroceryItem groceryItem = GroceryItem(name: containers[i].name);
                lowContainers.add(groceryItem);
              }
            } else {
              percentFull = ((273 - containers[i].value) / 273);
              if (percentFull < 0.25) {
                GroceryItem groceryItem = GroceryItem(name: containers[i].name);
                lowContainers.add(groceryItem);
              }
            }
          }

          GroceryList containerGroceryList = GroceryList(
              creationDate: DateTime.now(),
              foodItems: lowContainers,
              name: 'Low Containers',
              containerGroceryList: true);

          bool containerGLExists = await service.checkLowContainerGroceryList();
          if (!containerGLExists) {
            await service.createGroceryList(containerGroceryList);
          }
        }

        //get existing grocery lists from database
        List<GroceryList>? userGroceryLists = await service.getGroceryLists();

        //update container grocery list
        for (int i = 0; i < userGroceryLists!.length; i++) {
          if (userGroceryLists[i].containerGroceryList ?? false) {
            for (int j = 0; j < userGroceryLists[i].foodItems!.length; j++) {
              if (userGroceryLists[i].foodItems![j].checked) {
                for (int k = 0; k < lowContainers.length; k++) {
                  if (userGroceryLists[i].foodItems![j].name ==
                      lowContainers[k].name) {
                    lowContainers[k].checked = true;
                  }
                }
              }
            }
            userGroceryLists[i].foodItems = lowContainers;
            GroceryList newContainerGroceryList =
                userGroceryLists[i].copyWith(foodItems: lowContainers);
            service.updateGroceryList(
                userGroceryLists[i].id ?? "", newContainerGroceryList);
          }
        }
        emit(state.copyWith(groceryLists: userGroceryLists));
      }
    } catch (error, stacktrace) {
      log(stacktrace.toString());
      emit(state.copyWith(status: GroceryListStatus.error));
    }
  }

  void _mapNewGroceryListEventToState(
      AddNewGroceryList event, Emitter<GroceryListState> emit) async {
    emit(state.copyWith(status: GroceryListStatus.loading));
    try {
      GroceryList newGroceryList = GroceryList(
          containerGroceryList: event.containerGroceryList,
          creationDate: DateTime.now(),
          foodItems: event.foodItems,
          name: event.name);
      await service.createGroceryList(newGroceryList);
      List<GroceryList>? userGroceryLists = await service.getGroceryLists();
      emit(state.copyWith(
          status: GroceryListStatus.success, groceryLists: userGroceryLists));
    } catch (error, stacktrace) {
      log(stacktrace.toString());
    }
  }

  void _mapAddEventToState(
      AddToGroceryList event, Emitter<GroceryListState> emit) async {
    emit(state.copyWith(status: GroceryListStatus.loading));
    try {
      List<GroceryList> newGroceryLists = state.groceryLists;
      GroceryList newGroceryList;
      for (int i = 0; i < state.groceryLists.length; i++) {
        if (state.groceryLists[i].id == event.id) {
          List<GroceryItem>? foodItemList = state.groceryLists[i].foodItems;
          foodItemList!.addAll(event.foodItems);
          newGroceryList = GroceryList(
              creationDate: state.groceryLists[i].creationDate,
              foodItems: foodItemList,
              id: state.groceryLists[i].id,
              name: state.groceryLists[i].name,
              containerGroceryList: state.groceryLists[i].containerGroceryList);
          newGroceryLists.removeAt(i);
          newGroceryLists.add(newGroceryList);
          service.updateGroceryList(newGroceryList.id ?? "", newGroceryList);
          break;
        }
      }
      emit(state.copyWith(
          status: GroceryListStatus.success, groceryLists: newGroceryLists));
    } catch (error, stacktrace) {
      log(stacktrace.toString());
    }
  }

  void _mapDeleteFoodItemEventToState(
      DeleteFoodItemGroceryList event, Emitter<GroceryListState> emit) async {
    emit(state.copyWith(status: GroceryListStatus.loading));
    try {
      List<GroceryList> newGroceryLists = state.groceryLists;
      GroceryList newGroceryList;
      for (int i = 0; i < state.groceryLists.length; i++) {
        if (state.groceryLists[i].id == event.id) {
          List<GroceryItem>? foodItemList = state.groceryLists[i].foodItems;
          for (int j = 0; j < state.groceryLists[i].foodItems!.length; j++) {
            if (state.groceryLists[i].foodItems![j].name == event.foodItem) {
              foodItemList!.removeAt(j);
              break;
            }
          }
          newGroceryList = GroceryList(
              creationDate: state.groceryLists[i].creationDate,
              foodItems: foodItemList,
              id: state.groceryLists[i].id,
              name: state.groceryLists[i].name,
              containerGroceryList: state.groceryLists[i].containerGroceryList);
          newGroceryLists.removeAt(i);
          newGroceryLists.add(newGroceryList);
          await service.updateGroceryList(
              newGroceryList.id ?? "", newGroceryList);
          break;
        }
      }
      emit(state.copyWith(
          status: GroceryListStatus.success, groceryLists: newGroceryLists));
    } catch (error, stacktrace) {
      log(stacktrace.toString());
      emit(state.copyWith(status: GroceryListStatus.error));
    }
  }

  void _mapDeleteEventToState(
      DeleteGroceryList event, Emitter<GroceryListState> emit) async {
    emit(state.copyWith(status: GroceryListStatus.loading));
    try {
      List<GroceryList> newGroceryLists = state.groceryLists;
      for (int i = 0; i < newGroceryLists.length; i++) {
        if (newGroceryLists[i].id == event.id) {
          if (newGroceryLists[i].containerGroceryList == false) {
            service.deleteGroceryList(event.id);
            newGroceryLists.removeAt(i);
          }
          break;
        }
      }
      emit(state.copyWith(
          status: GroceryListStatus.success, groceryLists: newGroceryLists));
    } catch (error, stacktrace) {
      log(stacktrace.toString());
      emit(state.copyWith(status: GroceryListStatus.error));
    }
  }

  void _mapCheckEventToState(
      CheckGroceryItem event, Emitter<GroceryListState> emit) async {
    emit(state.copyWith(status: GroceryListStatus.loading));
    try {
      List<GroceryList> newGroceryLists = state.groceryLists;
      for (int i = 0; i < newGroceryLists.length; i++) {
        if (newGroceryLists[i].id == event.id) {
          if (newGroceryLists[i].foodItems?.length != null) {
            if (event.index < newGroceryLists[i].foodItems!.length) {
              newGroceryLists[i].foodItems![event.index].checked =
                  event.checked;
              service.updateGroceryList(event.id, newGroceryLists[i]);
            }
          }
          break;
        }
      }
      emit(state.copyWith(
          status: GroceryListStatus.success, groceryLists: newGroceryLists));
    } catch (error, stacktrace) {
      log(stacktrace.toString());
      emit(state.copyWith(status: GroceryListStatus.error));
    }
  }
}
