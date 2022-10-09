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

class Recipe {
final String uid;
String name;
String instructions;
final String user;

  Recipe({
    this.uid = '',
    this.name = '',
    this.instructions = '',
    this.user = ''
  }); 

  Recipe copyWith({
      String? uid,
      String? name,
      String? instructions,
      String? user}) {
    return Recipe(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      instructions: instructions ?? this.instructions,
      user: user ?? this.user,
    );
  }
}