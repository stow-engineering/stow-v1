// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:stow/models/recipe.dart';

class ViewRecipePage extends StatefulWidget {
  const ViewRecipePage({Key? key, required this.recipe}) : super(key: key);

  final Recipe recipe;

  @override
  State<ViewRecipePage> createState() => _ViewRecipePageState();
}

class _ViewRecipePageState extends State<ViewRecipePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text(widget.recipe.name),
        ),
        body: Card(
          child: Column(children: [
            ListTile(
              title: Text(
                "Ingredients List:", //widget.recipe.name,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 24.0),
              ),
            ),
            //Divider(thickness: 1, color: Theme.of(context).colorScheme.secondary),
            ListTile(
              title: Text(
                widget.recipe.ingredients
                    .toString()
                    .replaceAll(RegExp(r']'), "")
                    .replaceAll(RegExp(r'\['), ""),
                style: const TextStyle(
                    fontWeight: FontWeight.w400, fontSize: 20.0),
              ),
            ),
            Divider(
                thickness: 2, color: Theme.of(context).colorScheme.secondary),
            ListTile(
              title: Text(
                "Recipe Instructions:", //widget.recipe.name,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24.0),
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                itemCount: widget.recipe.instructions.length,
                itemBuilder: (BuildContext context, index) {
                  return
                      //Divider(thickness: 2, color: Theme.of(context).colorScheme.secondary),
                      ListTile(
                    title: Text(
                      "Step " +
                          (index + 1).toString() +
                          ": " +
                          widget.recipe.instructions[index],
                      style: const TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 20.0),
                    ),
                  );
                }),
          ]),
        ));
  }
}
