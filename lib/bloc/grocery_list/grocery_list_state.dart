// Dart imports:

// Flutter imports:

// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import 'package:stow/models/grocery_lists.dart';

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
