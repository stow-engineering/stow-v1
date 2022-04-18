import 'package:flutter/services.dart';
import 'ingredient_model.dart';

class RecipeResponse {
  List<Recipe> results = <Recipe>[];

RecipeResponse(this.results);

RecipeResponse.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <Recipe>[];
      json['results'].forEach((v) {
        results.add(Recipe.fromJson(v));
      });
    }
  }
}

class Recipe {
  int id = -1;
  String title = "";
  int usedIngredientCount = 0;
  String imageUrl = "";
  List<Ingredient> ingredients = <Ingredient>[];

Recipe({
    required this.id,
    required this.title,
    required this.usedIngredientCount,
    required this.imageUrl,
    required this.ingredients
  });

Recipe.fromJson(Map<String, dynamic> json) {
    id = -1;
    id = json['id'];
    title = json['title'];
    imageUrl = json['image'];
    usedIngredientCount = json['usedIngredientConnt'];

    //Gets ingredients from response from used ingredients
    var tempIngredients = json['usedIngredients'].toList();

    for (var item in tempIngredients){
      ingredients.add(Ingredient(item['amount'], item['unit'], item['name']));
    }

    // //Gets ingredients from response from missing ingredients
    tempIngredients = json['missedIngredients'].toList();

    for (var item in tempIngredients){
      ingredients.add(Ingredient(item['amount'], item['unit'], item['name']));
    }
  }
}