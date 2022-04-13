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
  int usedIngredient = 0;

Recipe({required this.id, required this.title, required this.usedIngredient});

Recipe.fromJson(Map<String, dynamic> json) {
    id = -1;
    id = json['id'];
    title = json['title'];
    usedIngredient = json['usedIngredient'];
  }
}