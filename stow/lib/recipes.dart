import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stow/container_chart.dart';
import 'package:stow/database.dart';
import 'package:stow/http_service.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recipes"),
      ),  
      body: FutureBuilder(
        future: httpService.getRecipes(<String>['apple', 'onion', 'cheese'], 3),
        builder: (BuildContext context, AsyncSnapshot<List<Recipe>> snapshot) {
          if(snapshot.hasData){
            print(snapshot.data);
            List<Recipe> recipes = snapshot.data ?? <Recipe>[];
            
            return ListView(
              children: recipes
                .map((Recipe recipe) => ListTile(
                      title: Text(recipe.title),
                    )
                ).toList(),
            ); 
          }
          return const Center(child: CircularProgressIndicator());
        },
      )
    );
  }
}