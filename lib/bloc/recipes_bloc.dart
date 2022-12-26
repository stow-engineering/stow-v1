// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:bloc/bloc.dart';

// Project imports:
import 'package:stow/bloc/recipes_events.dart';
import 'package:stow/bloc/recipes_state.dart';
import 'package:stow/utils/firebase.dart';
import '../models/container.dart' as customContainer;
import '../models/recipe.dart';
import '../models/user.dart';

class RecipesBloc extends Bloc<RecipesEvent, RecipesState> {
  RecipesBloc({
    required this.service,
    this.newRecipe,
  }) : super(const RecipesState()) {
    on<LoadRecipes>(_mapLoadEventToState);
    on<AddRecipe>(_mapAddEventToState);
    on<DeleteRecipe>(_mapDeleteEventToState);
    on<UpdateRecipe>(_mapUpdateEventToState);
  }
  final FirebaseService service;
  final Recipe? newRecipe;

  void _mapLoadEventToState(
      LoadRecipes event, Emitter<RecipesState> emit) async {
    emit(state.copyWith(status: RecipesStatus.loading));
    try {
      final recipes = await service.getRecipeList();
      emit(
        state.copyWith(
          status: RecipesStatus.success,
          recipes: recipes,
          numRecipes: recipes!.length,
        ),
      );
    } catch (error, stacktrace) {
      print(stacktrace);
      emit(state.copyWith(status: RecipesStatus.error));
    }
  }

  void _mapAddEventToState(AddRecipe event, Emitter<RecipesState> emit) async {
    emit(state.copyWith(status: RecipesStatus.loading));
    try {
      List<Recipe> newRecipeList = state.recipes;
      if (newRecipeList.isEmpty) {
        newRecipeList = <Recipe>[];
      }

      newRecipeList.add(event.recipe);
      service.updateRecipeData(
          event.recipe.recipeId,
          event.recipe.name,
          event.recipe.instructions,
          event.recipe.userId,
          event.recipe.ingredients,
          event.recipe.cookTimeMin,
          event.recipe.prepTimeMin);
      service.updateRecipes(event.recipe.recipeId);
      emit(
        state.copyWith(
            status: RecipesStatus.success,
            recipes: newRecipeList,
            numRecipes: newRecipeList.length),
      );
    } catch (error, stacktrace) {
      print(stacktrace);
      emit(state.copyWith(status: RecipesStatus.error));
    }
  }

  void _mapDeleteEventToState(
      DeleteRecipe event, Emitter<RecipesState> emit) async {
    emit(state.copyWith(status: RecipesStatus.loading));
    try {
      List<Recipe> newRecipeList = state.recipes;
      newRecipeList.remove(event.recipe);
      service.deleteRecipe(event.recipe.recipeId);
      emit(
        state.copyWith(
            status: RecipesStatus.success,
            recipes: newRecipeList,
            numRecipes: newRecipeList.length),
      );
    } catch (error, stacktrace) {
      print(stacktrace);
      emit(state.copyWith(status: RecipesStatus.error));
    }
  }

  void _mapUpdateEventToState(
      UpdateRecipe event, Emitter<RecipesState> emit) async {
    emit(state.copyWith(status: RecipesStatus.loading));
    try {
      List<Recipe> newRecipeList = state.recipes;
      for (int i = 0; i < newRecipeList.length; i++) {
        //if (newRecipeList[i].uid == event.uid) {
        newRecipeList[i].name = event.name;
        newRecipeList[i].instructions = event.instructions;
        //}
      }
      service.updateRecipeData(
          event.recipeId,
          event.name,
          event.instructions,
          event.userId,
          event.ingredients,
          event.cookTimeMin,
          event.prepTimeMin);
      service.updateRecipes(event.recipeId);
      emit(
        state.copyWith(
            status: RecipesStatus.success,
            recipes: newRecipeList,
            numRecipes: newRecipeList.length),
      );
    } catch (error, stacktrace) {
      print(stacktrace);
      emit(state.copyWith(status: RecipesStatus.error));
    }
  }
}
