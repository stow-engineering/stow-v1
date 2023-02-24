import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:stow/models/instructions_model.dart';
import 'package:stow/models/recipe.dart';
import '../api/recipe_api_key.dart';

class HttpService {
  Future<List<Recipe>> getRecipesFromIngredients(
      List<String> ingredients, int numberOfRecipes) async {
    var queryParameters = {
      'ingredients':
          ingredients.toString().replaceAll('[', '').replaceAll(']', ''),
      'number': numberOfRecipes.toString(),
    };
    var uri = Uri.https('api.spoonacular.com',
        '/recipes/findByIngredients', queryParameters);
    var res = await http.get(uri, headers: {
      'x-api-key': recipeApiKey
    });

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List<Recipe> recipes =
          body.map((dynamic item) => Recipe.fromJson(item)).toList();
          // print("Http_service results "+ recipes.toString());
      return recipes;
    } else {
      print("Get recipe failed. Error code " + res.statusCode.toString());
      List<Recipe> rec = [];
      return rec;
      //throw "Get recipe failed.";
    }
  }

  Future<Recipe> getRecipeFromIds(
      int recipeId) async {
    var queryParameters = {
      'recipeId': recipeId.toString()
    };
    var uri = Uri.https('api.spoonacular.com',
        '/recipes/' + recipeId.toString() + '/information');
    var res = await http.get(uri, headers: {
      'x-api-key': recipeApiKey
    });

    if (res.statusCode == 200) {
      dynamic body = jsonDecode(res.body);
      Recipe recipe =
          Recipe.fromJson(jsonDecode(res.body));
          // print("Http_service results "+ recipes.toString());
      return recipe;
    } else {
      print("Get recipe failed. Error code " + res.statusCode.toString());
      Recipe rec = Recipe();
      return rec;
      //throw "Get recipe failed.";
    }
  }

  Future<List<Recipe>> getRecipesFromIds(
      List<int> recipeIds) async {

    List<Recipe> recipes = <Recipe>[];

    for(int i = 0; i < recipeIds.length; i++){
      var queryParameters = {
        'recipeId': recipeIds[i].toString()
      };
      var uri = Uri.https('api.spoonacular.com',
          '/recipes/' + recipeIds[i].toString() + '/information');
      var res = await http.get(uri, headers: {
        'x-api-key': recipeApiKey
      });

      if (res.statusCode == 200) {
        dynamic body = jsonDecode(res.body);
        Recipe recipe =
            Recipe.fromJson(jsonDecode(res.body));
            // print("Http_service results "+ recipes.toString());
        recipes.add(recipe);
      } else {
        print("Get recipe failed. Error code " + res.statusCode.toString());
        Recipe rec = Recipe();
        recipes.add(rec);
        //throw "Get recipe failed.";
      }
    }

    return recipes;
  }

  Future<List<Recipe>> getFullRecipesInfoFromIds(
      List<int> recipeIds) async {

    List<Recipe> recipes = <Recipe>[];

    for(int i = 0; i < recipeIds.length; i++){
      var queryParameters = {
        'recipeId': recipeIds[i].toString()
      };
      var uri = Uri.https('api.spoonacular.com',
          '/recipes/' + recipeIds[i].toString() + '/information');
      var res = await http.get(uri, headers: {
        'x-api-key': recipeApiKey
      });

      Recipe recipe = Recipe();

      if (res.statusCode == 200) {
        dynamic body = jsonDecode(res.body);
        recipe.recipeId = body['id'].toString();
        recipe.name = body['title'];
        recipe.cookTimeMin = body['readyInMinutes'];
        recipe.imageUrl = body["image"];

        List<String> temp = <String>[];
        for(int i = 0; i < body['extendedIngredients'].length; i++) {
          temp.add(body['extendedIngredients'][i]['name']);
        }
        recipe.ingredients = temp;

      } else {
        print("Get recipe failed. Error code " + res.statusCode.toString());
        Recipe rec = Recipe();
        recipes.add(rec);
        //throw "Get recipe failed.";
      }

      queryParameters = {
        'recipeId': recipeIds[i].toString()
      };
      uri = Uri.https('api.spoonacular.com',
          '/recipes/' + recipeIds[i].toString() + '/analyzedInstructions');
      res = await http.get(uri, headers: {
        'x-api-key': recipeApiKey
      });

      if (res.statusCode == 200) {
        dynamic body = jsonDecode(res.body);

        List<String> temp = <String>[];
        for(int i = 0; i < body[0]['steps'].length; i++) {
          temp.add(body[0]['steps'][i]['step']);
        }
        recipe.instructions = temp;

        recipes.add(recipe);
      } else {
        print("Get recipe failed. Error code " + res.statusCode.toString());
        Recipe rec = Recipe();
        recipes.add(rec);
        //throw "Get recipe failed.";
      }

    }

    return recipes;
  }

}
