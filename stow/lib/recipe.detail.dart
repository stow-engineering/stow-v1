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
            ],
          ),
        )
      )
    );
  }
}