// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import '../models/recipe.dart';

enum RecipesStatus { initial, success, error, loading }

extension RecipesStatusX on RecipesStatus {
  bool get isInitial => this == RecipesStatus.initial;
  bool get isSuccess => this == RecipesStatus.success;
  bool get isError => this == RecipesStatus.error;
  bool get isLoading => this == RecipesStatus.loading;
}

class RecipesState extends Equatable {
  const RecipesState(
      {this.status = RecipesStatus.initial,
      List<Recipe>? recipes,
      this.numRecipes = 0})
      : recipes = recipes ?? const [];

  final List<Recipe> recipes;
  final int numRecipes;
  final RecipesStatus status;

  @override
  List<Object?> get props => [status, recipes, numRecipes];

  RecipesState copyWith({
    RecipesStatus? status,
    List<Recipe>? recipes,
    int? numRecipes,
  }) {
    return RecipesState(
        recipes: recipes ?? this.recipes,
        numRecipes: numRecipes ?? this.numRecipes,
        status: status ?? this.status);
  }
}
