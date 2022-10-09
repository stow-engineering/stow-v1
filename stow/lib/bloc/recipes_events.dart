import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stow/bloc/containers_state.dart';
import 'package:stow/utils/firebase.dart';
import '../models/container.dart' as customContainer;
import '../models/recipe.dart';
import '../models/user.dart';

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
  final String uid;
  final String name;
  final String instructions;
  //final String user;

  UpdateRecipe(this.name, this.instructions, this.uid)
      : super([name, instructions, uid]);

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
