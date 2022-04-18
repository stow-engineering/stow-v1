import 'dart:convert';
import 'package:http/http.dart' as http;
import 'recipe_model.dart';

class HttpService {
  Future<List<Recipe>> getRecipes(List<String> ingredients, int numberOfRecipes) async {
    var queryParameters = {
      'ingredients': ingredients.toString().replaceAll('[', '').replaceAll(']', ''),
      'number': numberOfRecipes.toString(),
    };
    var uri = Uri.https('spoonacular-recipe-food-nutrition-v1.p.rapidapi.com', '/recipes/findByIngredients', queryParameters);

    var res = await http.get(uri, headers: {'X-RapidAPI-Key': '27fd16c583mshf25e75b9907dc8dp1eda47jsn0e7eb5d6e744'});
    
    if(res.statusCode == 200){
      List<dynamic> body = jsonDecode(res.body);
      // print("raw response" + res.body);
      List<Recipe> recipes = 
        body.map((dynamic item) => Recipe.fromJson(item)).toList();
      // print("Http_service results "+ recipes.toString());
      return recipes;
    }
    else {
      // print("Get recipe failed. Error code " + res.statusCode.toString());
      throw "Get recipe failed.";
    }
  }

  // Future<List<Recipe>> getRecipeInstructions(int recipeId) async {
  //   var queryParameters = {
  //     'ingredients': ingredients.toString().replaceAll('[', '').replaceAll(']', ''),
  //     'number': numberOfRecipes.toString(),
  //   };
  //   var uri = Uri.https('spoonacular-recipe-food-nutrition-v1.p.rapidapi.com', '/recipes/findByIngredients', queryParameters);

  //   var res = await http.get(uri, headers: {'X-RapidAPI-Key': '27fd16c583mshf25e75b9907dc8dp1eda47jsn0e7eb5d6e744'});
    
  //   if(res.statusCode == 200){
  //     List<dynamic> body = jsonDecode(res.body);
  //     // print("raw response" + res.body);
  //     List<Recipe> recipes = 
  //       body.map((dynamic item) => Recipe.fromJson(item)).toList();
  //     // print("Http_service results "+ recipes.toString());
  //     return recipes;
  //   }
  //   else {
  //     // print("Get recipe failed. Error code " + res.statusCode.toString());
  //     throw "Get recipe failed.";
  //   }
  // }
}