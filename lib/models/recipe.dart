import 'package:firebase_auth/firebase_auth.dart';

/*Fields to add
  Image
  Ingredient
    name
    amount
    unittype

*/

class Recipe {
  late String recipeId;
  late String name;
  late List<String> instructions;
  late String userId = "";
  late List<String> ingredients;
  late int cookTimeMin;
  late int prepTimeMin;
  late String imageUrl = "";

  Recipe({
    this.recipeId = '',
    this.name = '',
    this.instructions = const <String>[],
    this.userId = '',
    this.ingredients = const <String>[],
    this.cookTimeMin = 0,
    this.prepTimeMin = 0,
    this.imageUrl = "",
  }); 

  Recipe copyWith({
      String? recipeId,
      String? name,
      List<String>? instructions,
      String? userId,
      List<String>? ingredients,
      int? cookTimeMin,
      int? prepTimeMin,
      String? imageUrl}) {
    return Recipe(
      recipeId: recipeId ?? this.recipeId,
      name: name ?? this.name,
      instructions: instructions ?? this.instructions,
      userId: userId ?? this.userId,
      ingredients: ingredients ?? this.ingredients,
      cookTimeMin: cookTimeMin ?? this.cookTimeMin,
      prepTimeMin: prepTimeMin ?? this.cookTimeMin,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Recipe.fromJson(Map<String, dynamic> json) {
    recipeId = json['id'].toString();
    name = json['title'];
    instructions = const <String>[];
    userId = '';
    ingredients = const <String>[];
    cookTimeMin = json['readyInMinutes'];
    prepTimeMin = 0;
    imageUrl = "";

    // if (json.containsKey('steps')) {
    //   for(int i = 0; i < json['steps']; i++){
    //     instructions.add(json['steps']['step']);
    //   }
    // }
    print(json.containsKey('missedIngredients'));
    // if (json.containsKey('missedIngredients')) {
    //     print("HDHFDSFSF" + json['missedIngredients']);
    // }
    // if (json['missedIngredients'] != null) {
    //   for(int i = 0; i < json['missedIngredients']; i++){
    //     ingredients.add(json['missedIngredients']['originalName']);
    //   }
    // }

    // if (json['usedIngredients'] != null) {
    //   for(int i = 0; i < json['usedIngredients']; i++){
    //     ingredients.add(json['usedIngredients']['originalName']);
    //   }
    // }


  //   //Gets ingredients from response from used ingredients
  //   var tempIngredients = json['usedIngredients'].toList();

  //   for (var item in tempIngredients) {
  //     ingredients.add(Ingredient(item['amount'], item['unit'], item['name']));
  //   }

  //   // //Gets ingredients from response from missing ingredients
  //   tempIngredients = json['missedIngredients'].toList();

  //   for (var item in tempIngredients) {
  //     ingredients.add(Ingredient(item['amount'], item['unit'], item['name']));
  //   }
  }

}
