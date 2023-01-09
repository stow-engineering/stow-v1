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
