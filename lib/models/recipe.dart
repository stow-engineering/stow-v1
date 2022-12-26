// class Recipe {
//   int id = -1;
//   String title = "";
//   int usedIngredient = 0;
//   String imageUrl = "";

//   Recipe(
//       {required this.id,
//       required this.title,
//       required this.usedIngredient,
//       required this.imageUrl});

//   Recipe.fromJson(Map<String, dynamic> json) {
//     id = -1;
//     id = json['id'];
//     title = json['title'];
//     imageUrl = json['image'];
//    usedIngredient = json['usedIngredient'];
//   }
// }

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';

class Recipe {
  String recipeId;
  String name;
  List<String> instructions;
  String userId;
  List<String> ingredients;
  int cookTimeMin;
  int prepTimeMin;

  Recipe({
    this.recipeId = '',
    this.name = '',
    this.instructions = const <String>[],
    this.userId = '',
    this.ingredients = const <String>[],
    this.cookTimeMin = 0,
    this.prepTimeMin = 0,
  });

  Recipe copyWith(
      {String? recipeId,
      String? name,
      List<String>? instructions,
      String? userId,
      List<String>? ingredients,
      int? cookTimeMin,
      int? prepTimeMin}) {
    return Recipe(
        recipeId: recipeId ?? this.recipeId,
        name: name ?? this.name,
        instructions: instructions ?? this.instructions,
        userId: userId ?? this.userId,
        ingredients: ingredients ?? this.ingredients,
        cookTimeMin: cookTimeMin ?? this.cookTimeMin,
        prepTimeMin: prepTimeMin ?? this.cookTimeMin);
  }
}
