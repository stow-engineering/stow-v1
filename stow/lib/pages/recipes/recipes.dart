import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../container_widgets/container_chart.dart';
import '../../container_widgets/container_list.dart';
import '../../container_widgets/user_containers.dart';
import '../../models/container.dart' as customContainer;
import '../../models/container_series.dart';
import '../../models/recipe_model.dart';
import '../../models/user.dart';
import '../../utils/firebase.dart';
import '../../utils/http_service.dart';
import '../login/login.dart';
import '../recipes/recipe_detail.dart';

class RecipesPage extends StatefulWidget {
  final StowUser user;

  const RecipesPage({Key? key, required this.user}) : super(key: key);

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
    const int displayNum = 3;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Recipes"),
        ),
        body: FutureBuilder(
          future: httpService
              .getRecipes(<String>['apple', 'onion', 'cheese'], displayNum),
          builder:
              (BuildContext context, AsyncSnapshot<List<Recipe>> snapshot) {
            if (snapshot.hasData) {
              print(snapshot.data);
              print("DISPLAYING DATA");
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
              // body: SafeArea(
              //   // 3
              //   child: Column(
              //   children: <Widget>[
              //   // 4
              //   SizedBox(
              //   height: 300,
              //   width: double.infinity,
              //   child: Image(
              //   image: AssetImage(widget.recipe.imageUrl),
              //   ),
              //   ),
              //   // 5
              //   const SizedBox(
              //   height: 4,
              //   ),
              //   // 6
              //   Text(
              //   widget.recipe.label,
              //   style: const TextStyle(fontSize: 18),
              //   ),
              //   // TODO: Add Expande
            }
            return const Center(child: CircularProgressIndicator());
          },
        ));
  }
}

Widget buildRecipeCard(Recipe recipe) {
  // 1
  return Card(
    color: Colors.grey[100],
    // 2
    child: Column(
      // 3
      children: <Widget>[
        // 4
        Image.network(recipe.imageUrl, width: 200, height: 200),
        // 5
        Text(recipe.title,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.green,
            )),
      ],
    ),
  );
}
