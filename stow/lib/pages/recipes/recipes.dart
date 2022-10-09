import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stow/bloc/recipes_events.dart';
import 'package:stow/models/recipe.dart';
import 'package:stow/models/user.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:stow/pages/recipes/recipe_detail.dart';
import 'package:stow/utils/firebase.dart';
import 'package:stow/utils/http_service.dart';
import 'package:stow/models/container.dart' as customContainer;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:stow/bloc/food_bloc.dart';
import '../../bloc/containers_state.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:stow/bloc/food_bloc.dart';
import 'package:stow/container_widgets/food_item_list.dart';
import 'package:stow/expandable_fab/action_button.dart';
import 'package:stow/utils/authentication.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/containers_bloc.dart';
import '../../container_widgets/container_chart.dart';
import '../../container_widgets/container_list.dart';
import '../../container_widgets/user_containers.dart';
import '../../models/container.dart' as customContainer;
import '../../models/container_series.dart';
import '../../models/user.dart';
import '../../bloc/containers_state.dart';
import '../../bloc/recipes_state.dart';
import '../../bloc/recipes_bloc.dart';
import '../../utils/firebase.dart';
import '../login/login.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({Key? key}) : super(key: key);
  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  //final HttpService httpService = HttpService();

  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration.zero, () async {
    //   getContainerStream();
    // });
  }

  @override
  Widget build(BuildContext context) {
    final recipeBloc = BlocProvider.of<RecipesBloc>(context);
    final authBloc = BlocProvider.of<AuthBloc>(context);
    FirebaseService service = Provider.of<FirebaseService>(context);
    return BlocBuilder<RecipesBloc, RecipesState>(
      bloc: recipeBloc,
      builder: (context, state) {
        return Scaffold(
            floatingActionButton: 
              //  ExpandableFab(initialOpen: false, distance: 80.0, children: [
              ActionButton(
                onPressed: () => {
                  Navigator.of(context)
                      .pushNamed(
                        '/add_recipe',
                        arguments: authBloc.state.user,
                      )
                      .then((_) => setState(() {}))
                },
                icon: const Icon(Icons.add_rounded),
              ),
            //]),
          appBar: AppBar(
            title: const Text("Recipes"),//const Text("Recipes"),
          ),
          body: ListView.builder(//body: FutureBuilder(
            // Let the ListView know how many items it needs to build.
            itemCount: state.numRecipes,
            // Provide a builder function. This is where the magic happens.
            // Convert each item into a widget based on the type of item it is.
            itemBuilder: ( BuildContext context, index) {
              final recipe = state.recipes[index];
              //buildRecipeCard(recipe);
              return BuildRecipeCard(recipe: recipe);
            },
      ),
    );
    return const Center(child: CircularProgressIndicator());
    });
  }
}

class BuildRecipeCard extends StatefulWidget {
  
  const BuildRecipeCard({Key? key, required this.recipe}) : super(key: key);
  
  final Recipe recipe;
  
  @override
  State<BuildRecipeCard> createState() => _BuildRecipeCardState();
}

class _BuildRecipeCardState extends State<BuildRecipeCard> {
  //final HttpService httpService = HttpService();

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Card(
        child: Column(
          children: [
            ListTile(
              title: Text(
                widget.recipe.name,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24.0),
              ),
              leading: Icon(
                Icons.restaurant_menu,
                color: Theme.of(context).colorScheme.secondary,
              ),
              trailing: TextButton(
                  onPressed: () {
                    _showMyDialog(
                      context,
                      'Are you sure you want to delete this recipe?',
                      widget.recipe); 
                  },
                  child: const Icon(Icons.clear, color: Colors.black, ),
                ),
            ),
            const Divider(thickness: 1, color: Color.fromARGB(255, 135, 156, 142)),
            ListTile(
              title: Text(
                "Prep Time: "
                + widget.recipe.prepTimeMin.toString()
                + " Mins"
                + ", Cook Time: "
                + widget.recipe.cookTimeMin.toString()
                + " Mins ",
                style: const TextStyle(
                  fontWeight: FontWeight.w400),
              ),
            ),
            ListTile(
              title: Text("View",
                style: TextStyle(fontWeight: FontWeight.w400,
                color: Color.fromARGB(179, 109, 122, 133)
                ),
              ),
              contentPadding: EdgeInsets.fromLTRB(170, 0, 0, 0),
              hoverColor: Color.fromARGB(255, 201, 138, 22),
              onTap: () => {
                Navigator.of(context)
                    .pushNamed(
                      '/view_recipe',
                      arguments: widget.recipe,
                    )
                    .then((_) => setState(() {}))
              },
            ),
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(300, 0, 0, 0),
            //   child: ActionButton(
            //       onPressed: () {
            //         //recipeBloc.add(recipe);
            //         //context.read<RecipesBloc>().add(DeleteRecipe(recipe));
            //         _showMyDialog(
            //           context,
            //           'Are you sure you want to delete this recipe?',
            //           recipe); 
            //       },
            //       icon: const Icon(Icons.delete_outlined),
            //     ),
            // ),
            //const Divider(),
            //   Container(
            //     height: 200,
            //     width: double.infinity,
            //     decoration: BoxDecoration(
            //       image: DecorationImage(
            //         image: Image(),
            //         //image: NetworkImage(recipe.imageUrl),
            //         fit: BoxFit.fitWidth,
            //         alignment: Alignment.topCenter,
            //     ),
            //   ),
            // ),
            // ListTile(
            //   title: const Text(
            //     "Instructions",
            //     style: TextStyle(fontWeight: FontWeight.w500),
            //   ),
            //   subtitle: Text(recipe.instructions),
            // ),
            // ListTile(
            //   title: const Text(
            //     "Cook Time",
            //     style: TextStyle(fontWeight: FontWeight.w500),
            //   ),
            //   subtitle: Text(recipe.instructions),
            // ),
          ],
        ),
      ),
    );
  }
}

  Future<void> _showMyDialog(BuildContext context, String message, Recipe recipe) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Recipe'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                context.read<RecipesBloc>().add(DeleteRecipe(recipe));
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
