// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../models/recipe.dart';

@immutable
abstract class RecipesEvent {
  const RecipesEvent([List props = const []]);
}

class LoadRecipes extends RecipesEvent {
  @override
  String toString() => 'LoadRecipes';
}

class AddRecipe extends RecipesEvent {
  final Recipe recipe;

  AddRecipe(this.recipe) : super([recipe]);

  @override
  String toString() => 'AddRecipe { recipe: $recipe }';
}

class UpdateRecipe extends RecipesEvent {
  final String recipeId;
  final String name;
  final List<String> instructions;
  final String userId;
  final List<String> ingredients;
  final int cookTimeMin;
  final int prepTimeMin;

  UpdateRecipe(this.recipeId, this.name, this.instructions, this.userId,
      this.ingredients, this.cookTimeMin, this.prepTimeMin)
      : super([
          recipeId,
          name,
          instructions,
          userId,
          ingredients,
          cookTimeMin,
          prepTimeMin
        ]);

  @override
  String toString() =>
      'UpdateRecipe { name: $name, instructions:$instructions }';
}

class DeleteRecipe extends RecipesEvent {
  final Recipe recipe;

  DeleteRecipe(this.recipe) : super([recipe]);

  @override
  String toString() => 'DeleteRecipe { recipe: $recipe }';
}
