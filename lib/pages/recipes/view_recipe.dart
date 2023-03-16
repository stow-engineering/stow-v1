import 'package:flutter/material.dart';
import 'package:stow/models/recipe.dart';

class ViewRecipePage extends StatefulWidget {
  const ViewRecipePage({Key? key, required this.recipe}) : super(key: key);

  final Recipe recipe;

  @override
  State<ViewRecipePage> createState() => _ViewRecipePageState();
}

class _ViewRecipePageState extends State<ViewRecipePage> {
  static List<String> instructionsList = [""];
  static List<String> ingredientsList = [""];


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  instructionsList = widget.recipe.instructions;//["step1", "step2","I need to check if line overfill works and hopefully it does because it could be a pain to fix if it does not." , "step3"];
  ingredientsList = widget.recipe.ingredients;//["ing1", "ing2", "ing3", "I need to check if line overfill works and hopefully it does because it could be a pain to fix if it does not."];
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text(widget.recipe.name),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // name textfield
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Name of Recipe',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 32.0),
                  child: Text(
                    widget.recipe.name
                  ),
                ),
                Divider(thickness: 3, color: Theme.of(context).colorScheme.secondary,),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Ready Time',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 32.0),
                  child: Text(
                    (widget.recipe.prepTimeMin + widget.recipe.cookTimeMin).toString() + " mins"
                  ),
                ),
                Divider(thickness: 3, color: Theme.of(context).colorScheme.secondary,),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Ingredients',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                ..._getIngredients(),
                SizedBox(
                  height: 20,
                ),
                Divider(thickness: 3, color: Theme.of(context).colorScheme.secondary,),
                Text(
                  'Instructions',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                ..._getInstructions(),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      );
  }

  // get instructions text-fields
  List<Widget> _getInstructions() {
    List<Widget> instructionsTextFields = [];
    for (int i = 0; i < instructionsList.length; i++) {
      instructionsTextFields.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Step " + (i+1).toString() + ": " + instructionsList[i]),
            SizedBox(
               width: 16,
             ),
            Divider(thickness: 1, color: Theme.of(context).colorScheme.secondary,),
          ],
        ),
      ));
    }
    return instructionsTextFields;
  }

  // get firends text-fields
  List<Widget> _getIngredients() {
    List<Widget> ingredientsTextFields = [];
    for (int i = 0; i < ingredientsList.length; i++) {
      ingredientsTextFields.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(ingredientsList[i]),
            SizedBox(
               width: 16,
             ),
            Divider(thickness: 1, color: Theme.of(context).colorScheme.secondary,),
          ],
        ),
      ));
    }
    return ingredientsTextFields;
  }

}


