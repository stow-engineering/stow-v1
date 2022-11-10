import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stow/bloc/food/food_events.dart';
import 'package:stow/bloc/food/food_state.dart';
import 'package:stow/utils/firebase.dart';
import '../../models/food_item.dart';

class FoodItemsBloc extends Bloc<FoodItemsEvents, FoodItemsState> {
  FoodItemsBloc({
    required this.service,
    this.newFoodItem,
  }) : super(const FoodItemsState()) {
    on<LoadFoodItems>(_mapLoadEventToState);
    on<AddFoodItem>(_mapAddEventToState);
    on<DeleteFoodItems>(_mapDeleteEventToState);
    on<UpdateFoodItems>(_mapUpdateEventToState);
  }
  final FirebaseService service;
  final FoodItem? newFoodItem;

  void _mapLoadEventToState(
      LoadFoodItems event, Emitter<FoodItemsState> emit) async {
    emit(state.copyWith(status: FoodItemsStatus.loading));
    try {
      final foodItems = await service.getFoodItemList();
      emit(
        state.copyWith(
          status: FoodItemsStatus.success,
          foodItems: foodItems,
          numItems: foodItems!.length,
        ),
      );
    } catch (error, stacktrace) {
      print(stacktrace);
      emit(state.copyWith(status: FoodItemsStatus.error));
    }
  }

  void _mapAddEventToState(
      AddFoodItem event, Emitter<FoodItemsState> emit) async {
    emit(state.copyWith(status: FoodItemsStatus.loading));
    try {
      List<FoodItem> newFoodItemsList = state.foodItems as List<FoodItem>;
      DocumentReference food_uid = await service.updateFoodItemData(
          event.foodItem.name, event.foodItem.expDate);
      service.updateFoodItems(food_uid.id);
      FoodItem newFoodItem = FoodItem(
          uid: food_uid.id,
          barcode: event.foodItem.barcode,
          name: event.foodItem.name,
          value: event.foodItem.value,
          expDate: event.foodItem.expDate);
      newFoodItemsList.add(newFoodItem);
      emit(
        state.copyWith(
            status: FoodItemsStatus.success,
            foodItems: newFoodItemsList,
            numItems: newFoodItemsList.length),
      );
    } catch (error, stacktrace) {
      print(stacktrace);
      emit(state.copyWith(status: FoodItemsStatus.error));
    }
  }

  void _mapDeleteEventToState(
      DeleteFoodItems event, Emitter<FoodItemsState> emit) async {
    emit(state.copyWith(status: FoodItemsStatus.loading));
    try {
      List<FoodItem> newFoodItemsList = state.foodItems as List<FoodItem>;
      newFoodItemsList.remove(event.foodItem);
      service.deleteFoodItems(event.foodItem.uid);
      emit(
        state.copyWith(
            status: FoodItemsStatus.success,
            foodItems: newFoodItemsList,
            numItems: newFoodItemsList.length),
      );
    } catch (error, stacktrace) {
      print(stacktrace);
      emit(state.copyWith(status: FoodItemsStatus.error));
    }
  }

  void _mapUpdateEventToState(
      UpdateFoodItems event, Emitter<FoodItemsState> emit) async {
    emit(state.copyWith(status: FoodItemsStatus.loading));
    try {
      List<FoodItem> newFoodItemsList = state.foodItems as List<FoodItem>;
      for (int i = 0; i < newFoodItemsList.length; i++) {
        if (newFoodItemsList[i].uid == event.foodItem.uid) {
          newFoodItemsList[i].name = event.foodItem.name;
          newFoodItemsList[i].expDate = event.foodItem.expDate;
        }
      }
      var food_id = service.updateExistingFoodItem(event.foodItem);
      //service.updateFoodItems(food_id.toString());
      emit(
        state.copyWith(
            status: FoodItemsStatus.success,
            foodItems: newFoodItemsList,
            numItems: newFoodItemsList.length),
      );
    } catch (error, stacktrace) {
      print(stacktrace);
      emit(state.copyWith(status: FoodItemsStatus.error));
    }
  }
}
