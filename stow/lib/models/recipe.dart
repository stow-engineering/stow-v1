class Recipe {
  int id = -1;
  String title = "";
  int usedIngredient = 0;
  String imageUrl = "";

  Recipe(
      {required this.id,
      required this.title,
      required this.usedIngredient,
      required this.imageUrl});

  Recipe.fromJson(Map<String, dynamic> json) {
    id = -1;
    id = json['id'];
    title = json['title'];
    imageUrl = json['image'];
    usedIngredient = json['usedIngredient'];
  }
}
