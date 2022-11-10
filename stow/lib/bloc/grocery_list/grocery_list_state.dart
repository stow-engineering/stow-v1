import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stow/models/grocery_lists.dart';
import 'package:stow/utils/firebase.dart';
import '../../models/food_item.dart';
import '../../models/user.dart';
import 'package:equatable/equatable.dart';

enum GroceryListStatus { initial, success, error, loading }

extension GroceryListsStatusX on GroceryListStatus {
  bool get isInitial => this == GroceryListStatus.initial;
  bool get isSuccess => this == GroceryListStatus.success;
  bool get isError => this == GroceryListStatus.error;
  bool get isLoading => this == GroceryListStatus.loading;
}

class GroceryListState extends Equatable {
  const GroceryListState(
      {this.status = GroceryListStatus.initial,
      List<GroceryList>? groceryLists})
      : groceryLists = groceryLists ?? const [];

  final List<GroceryList> groceryLists;
  final GroceryListStatus status;

  @override
  List<Object?> get props => [status, groceryLists];

  GroceryListState copyWith({
    GroceryListStatus? status,
    List<GroceryList>? groceryLists,
  }) {
    return GroceryListState(
        groceryLists: groceryLists ?? this.groceryLists,
        status: status ?? this.status);
  }
}
