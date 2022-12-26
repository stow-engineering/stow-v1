// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import 'package:stow/models/food_item.dart';

enum FoodItemsStatus { initial, success, error, loading }

extension FoodItemsStatusX on FoodItemsStatus {
  bool get isInitial => this == FoodItemsStatus.initial;
  bool get isSuccess => this == FoodItemsStatus.success;
  bool get isError => this == FoodItemsStatus.error;
  bool get isLoading => this == FoodItemsStatus.loading;
}

class FoodItemsState extends Equatable {
  const FoodItemsState(
      {this.status = FoodItemsStatus.initial,
      List<FoodItem>? foodItems,
      int numItems = 0})
      : foodItems = foodItems ?? const [],
        numItems = numItems;

  final List<FoodItem> foodItems;
  final int numItems;
  final FoodItemsStatus status;

  @override
  List<Object?> get props => [status, foodItems, numItems];

  FoodItemsState copyWith({
    FoodItemsStatus? status,
    List<FoodItem>? foodItems,
    int? numItems,
  }) {
    return FoodItemsState(
        foodItems: foodItems ?? this.foodItems,
        numItems: numItems ?? this.numItems,
        status: status ?? this.status);
  }
}
