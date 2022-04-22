import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stow/container_chart.dart';
import 'package:stow/database.dart';
import 'package:stow/http_service.dart';
import 'package:stow/recipe.detail.dart';
import 'package:stow/user.dart';
import 'container_list.dart';
import 'recipe_model.dart';
import 'user_auth.dart';
import 'login.dart';
import 'container_series.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'container_chart.dart';
import 'container.dart' as customContainer;
import 'user_containers.dart';

class RecipesPage extends StatefulWidget {
  final StowUser user;
  final List<customContainer.Container> containerData;

  const RecipesPage({Key? key, required this.user, required this.containerData}) : super(key: key);

   @override
   State<RecipesPage> createState() => _RecipesPageState();
}

 class _RecipesPageState extends State<RecipesPage> {
  final HttpService httpService = HttpService();
  
  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration.zero, () async {
    //   getContainerStream();
    // });
  }

  @override
  Widget build(BuildContext context) {
    DatabaseService service = DatabaseService(widget.user.uid);
    const int displayNum = 3;

    List<String> containerNames = <String>[];
    for(var item in widget.containerData){
      containerNames.add(item.name);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Recipes"),
      ),  
      body: FutureBuilder(
        future: httpService.getRecipes(containerNames, displayNum),
        builder: (BuildContext context, AsyncSnapshot<List<Recipe>> snapshot) {
          if(snapshot.hasData){
            List<Recipe> recipes = snapshot.data ?? <Recipe>[];
            
            // return ListView(
            //   children: recipes
            //     .map((Recipe recipe) => ListTile(
            //           title: Text(recipe.title),
            //         )
            //     ).toList(),
            // );
            return SafeArea(
              child: ListView.builder(
                itemCount: displayNum,
                itemBuilder: (BuildContext context, int index){
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return RecipeDetail(recipe: recipes[index]);
                          }
                        )
                      );
                    },
                    child: buildRecipeCard(recipes[index]),
                  );
                },
              )
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}


Widget buildRecipeCard(Recipe recipe) {
  return Card(
    elevation: 0,
    child: Column(
      children: <Widget>[
        Image.network(recipe.imageUrl, width: 200, height: 200),
        Text(recipe.title,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.green,
          )
        ),
      ],
    ),
  );
}