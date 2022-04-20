import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stow/models/recipe_model.dart';
import 'package:stow/models/user.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:stow/pages/recipes/recipe_detail.dart';
import 'package:stow/utils/firebase.dart';
import 'package:stow/utils/http_service.dart';
import 'package:stow/models/container.dart' as customContainer;

class RecipesPage extends StatefulWidget {
  final StowUser user;
  final List<customContainer.Container> containerData;

  const RecipesPage({Key? key, required this.user, required this.containerData})
      : super(key: key);

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
    FirebaseService service = FirebaseService(widget.user.uid);
    const int displayNum = 10;

    List<String> containerNames = <String>[];
    for (var item in widget.containerData) {
      containerNames.add(item.name);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Recipes"),
      ),
      body: FutureBuilder(
        future: httpService.getRecipes(containerNames, displayNum),
        builder: (BuildContext context, AsyncSnapshot<List<Recipe>> snapshot) {
          if (snapshot.hasData) {
            List<Recipe> recipes = snapshot.data ?? <Recipe>[];

            return SafeArea(
                child: ListView.builder(
              itemCount: displayNum,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return RecipeDetail(recipe: recipes[index]);
                    }));
                  },
                  child: buildRecipeCard(recipes[index]),
                );
              },
            ));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

Widget buildRecipeCard(Recipe recipe) {
  return Padding(
    padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 15),
    child: Card(
      elevation: 20,
      //color: Color.fromARGB(255, 193, 238, 176),
      color: Color.fromARGB(255, 237, 248, 255),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: <Widget>[
          //Image.network(recipe.imageUrl, width: 200, height: 200),
          Image.network(recipe.imageUrl, fit: BoxFit.fill),
          Center(
            child: Text(
              recipe.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
