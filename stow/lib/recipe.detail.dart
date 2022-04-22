import 'package:flutter/material.dart';
import 'recipe_model.dart';

class RecipeDetail extends StatefulWidget{
  final Recipe recipe;
  const RecipeDetail({
    Key? key,
    required this.recipe,
  }) : super(key: key);

  @override
  _RecipeDetailState createState(){
    return _RecipeDetailState();
  }
}

class _RecipeDetailState extends State<RecipeDetail>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.title),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              Image.network(widget.recipe.imageUrl, width: 200, height: 200),
              Text(widget.recipe.title,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.green,
                )
              ),
              const Padding(
                padding: EdgeInsets.all(7.0),
                child: Text('Ingredients',
                  style: TextStyle(
                     fontSize: 20,
                  ) 
                ),          
              ),   
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(7.0),
                  itemCount: widget.recipe.ingredients.length,
                  itemBuilder: (BuildContext context, int index){
                    final ingredient = widget.recipe.ingredients[index];

                    return Text(
                      '${ingredient.amount} ${ingredient.unit.toCapitalized()} ${ingredient.name.toTitleCase()}',
                      style: const TextStyle(
                        fontSize: 15,
                      )
                    );
                  }
                ),
              ),
            ],
          ),
        )
      )
    );
  }
}

//Used to edit case of strings
extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ?'${this[0].toUpperCase()}${substring(1).toLowerCase()}':'';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}