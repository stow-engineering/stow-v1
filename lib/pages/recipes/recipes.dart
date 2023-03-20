import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:stow/bloc/auth/auth_bloc.dart';
import 'package:stow/bloc/recipes_events.dart';
import 'package:stow/models/ingredient_model.dart';
import 'package:stow/models/recipe.dart';
import 'package:stow/utils/firebase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stow/expandable_fab/action_button.dart';
import 'package:stow/widgets/custom_navbar.dart';
import '../../bloc/food/food_bloc.dart';
import '../../bloc/recipes_state.dart';
import '../../bloc/recipes_bloc.dart';
import '../../utils/firebase.dart';
import '../../utils/http_service.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({Key? key}) : super(key: key);
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

  // Future<List<Recipe>> getRecommendedRecipes() async {
  //   final HttpService httpService = HttpService();

  //   final foodItemBloc = BlocProvider.of<FoodItemsBloc>(context);
  //   List<String> ingredientList = <String>[];
  //   foodItemBloc.state.foodItems.forEach((element) {print(element.name);});
  //   foodItemBloc.state.foodItems.forEach((element) {ingredientList.add(element.name);});

  //   List<Recipe> recipeIds = await httpService.getRecipesFromIngredients(ingredientList, 1);

  //   print(recipeIds);

  //   List<Recipe> recipes = <Recipe>[];
  //   for(int i = 0; i < recipeIds.length; i++){
  //     recipes.add(await httpService.getRecipeFromIds(int.parse((recipeIds)[i].recipeId)));
  //   }

  //   print(recipes[0].name);
  //   return recipes;
  // }

  @override
  Widget build(BuildContext context) {
    final recipeBloc = BlocProvider.of<RecipesBloc>(context);
    final authBloc = BlocProvider.of<AuthBloc>(context);
    final foodItemBloc = BlocProvider.of<FoodItemsBloc>(context);
    FirebaseService service = Provider.of<FirebaseService>(context);

    // Future<List<Recipe>> recipeList =  getRecommendedRecipes();

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
              text: const Text("Recipe"),
            ),
            //]),
            appBar: AppBar(
              title: const Text("Recipes"),
            ),
            body: ListView( 
              children: [
                Text(
                  'Recommended Recipes',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 28),
                ),
                Divider(thickness: 3, color: Theme.of(context).colorScheme.secondary,),
                _getRecommendedRecipes(context),
                //..._test(state, recipeList),
                //..._getRecommendedRecipes(context, state),
                //..._buildPosts(),
                Text(
                  'My Recipes',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 28),
                ),
                Divider(thickness: 3, color: Theme.of(context).colorScheme.secondary,),
                ..._getUserRecipes(context, state),
                // ListView.builder(
                // //body: FutureBuilder(
                // // Let the ListView know how many items it needs to build.
                // itemCount: state.numRecipes,
                // // Provide a builder function. This is where the magic happens.
                // // Convert each item into a widget based on the type of item it is.
                // itemBuilder: (BuildContext context, index) {
                //   final recipe = state.recipes[index];
                //   //buildRecipeCard(recipe);
                //   return BuildRecipeCard(recipe: recipe);
                //   },
                // ),
              ],
            ),
          );
          return const Center(child: CircularProgressIndicator());
        });
  }

  List<Widget> _test(state, recipeList) {
    List<Widget> instructionsTextFields = [];
    for (int i = 0; i < recipeList.length; i++) {
      instructionsTextFields.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BuildRecipeCard(recipe: recipeList.recipes[i]),
            // Text("Step " + i.toString() + ": " + instructionsList[i]),
            // SizedBox(
            //    width: 16,
            //  ),
            // Divider(thickness: 1, color: Theme.of(context).colorScheme.secondary,),
          ],
        ),
      ));
    }
    return instructionsTextFields;
  }

  // build list view & manage states
  FutureBuilder<List<Recipe>> _getRecommendedRecipes(BuildContext context) {
    final HttpService httpService = HttpService();

    final foodItemBloc = BlocProvider.of<FoodItemsBloc>(context);
    List<String> ingredientList = <String>[];
    foodItemBloc.state.foodItems.forEach((element) {ingredientList.add(element.name);});

    //TEST CODE
    //ingredientList = <String>['pasta','beef'];
    //

    return FutureBuilder<List<Recipe>>(

      future: httpService.getRecipesFromIngredients(ingredientList, 3),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final List<Recipe> tempRecipeIds = snapshot.data as List<Recipe>;
          List<int> recipeIds = [];
          
          for(int i = 0; i < tempRecipeIds.length; i++){
            recipeIds.add(int.parse((tempRecipeIds)[i].recipeId));
          }
          return FutureBuilder<List<Recipe>?>(
            future: httpService.getFullRecipesInfoFromIds(recipeIds),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                final List<Recipe> recipes = snapshot.data as List<Recipe>;
                return Column(
                  children: List.generate(
                    recipes.length,
                    (index) => BuildRecommendedRecipeCard(recipe: recipes[index],),
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          );
          // return ListView.builder(
          //   itemCount: recipes?.length,
          //   itemBuilder: (content, index) {
          //     return BuildRecipeCard(recipe: recipes![index]);
          //   }
          // );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }


  // get instructions text-fields
  List<Widget> _getUserRecipes(context, state) {
    List<Widget> instructionsTextFields = [];
    for (int i = 0; i < state.numRecipes; i++) {
      instructionsTextFields.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BuildRecipeCard(recipe: state.recipes[i]),
            // Text("Step " + i.toString() + ": " + instructionsList[i]),
            // SizedBox(
            //    width: 16,
            //  ),
            // Divider(thickness: 1, color: Theme.of(context).colorScheme.secondary,),
          ],
        ),
      ));
    }
    return instructionsTextFields;
  }
}

class BuildRecommendedRecipeCard extends StatefulWidget {
  const BuildRecommendedRecipeCard({Key? key, required this.recipe}) : super(key: key);

  final Recipe recipe;

  @override
  State<BuildRecommendedRecipeCard> createState() => _BuildRecommendedRecipeCardState();
}

class _BuildRecommendedRecipeCardState extends State<BuildRecommendedRecipeCard> {
  //final HttpService httpService = HttpService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return SizedBox(
    //   height: 100,
    //   child: Card(
      return Card(
        shape: const RoundedRectangleBorder(),
        surfaceTintColor: Colors.blueGrey,
        child: StaggeredGrid.count(
          crossAxisCount: 3,
          mainAxisSpacing: 3,
          children: [
            Container(   
              height: 100, //double.infinity,
              width: 100,//double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.recipe.imageUrl),
                  fit: BoxFit.fill,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),            
            StaggeredGridTile.count(
              crossAxisCellCount: 2,
              mainAxisCellCount: 1,
              //child: SizedBox(
                child: ListView(
                  children: [
                    Text(
                      widget.recipe.name,
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24.0),
                    ),
                    Divider(
                      thickness: 1.5, color: Theme.of(context).colorScheme.secondary),
                    Text(
                      "Ready Time: " +
                          (widget.recipe.prepTimeMin + widget.recipe.cookTimeMin).toString() +
                          " Mins",
                      style: const TextStyle(fontWeight: FontWeight.w400),
                    ),
                    ListTile(
                      title: Text(
                        "View",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(179, 109, 122, 133)),
                      ),
                      contentPadding: EdgeInsets.fromLTRB(170, 0, 0, 0),
                      hoverColor: Theme.of(context).colorScheme.secondary,
                      onTap: () => {
                        Navigator.of(context)
                            .pushNamed(
                              '/view_recipe',
                              arguments: widget.recipe,
                            )
                            .then((_) => setState(() {}))
                      },
                    ), 
                  ],    
                ),    
             // ),
            ),       
          ],
        )

      );
        // child: GridView.count(
          
          //padding: EdgeInsets.fromLTRB(5, 5, 15, 5),
         // crossAxisCount: 2,
          // children: [
          //   Container(   
          //     height: 300,
          //     width: 100,//double.infinity,
          //     decoration: BoxDecoration(
          //       image: DecorationImage(
          //         image: NetworkImage(widget.recipe.imageUrl),
          //         fit: BoxFit.fill,
          //         alignment: Alignment.topCenter,
          //       ),
          //     ),
          //   ),
          //   Column(
          //     children: [
          //       Text(
          //         widget.recipe.name,
          //         style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24.0),
          //       ),
          //       const Divider(
          //           thickness: 1, color: Color.fromARGB(255, 135, 156, 142)),
          //       Text(
          //         "Ready Time: " +
          //             (widget.recipe.prepTimeMin + widget.recipe.cookTimeMin).toString() +
          //             " Mins",
          //         style: const TextStyle(fontWeight: FontWeight.w400),
          //       ),                
          //     ],
          //   ),
          //   ListTile(
          //     title: Text(
          //       "View",
          //       style: TextStyle(
          //           fontWeight: FontWeight.w400,
          //           color: Color.fromARGB(179, 109, 122, 133)),
          //     ),
          //     contentPadding: EdgeInsets.fromLTRB(170, 0, 0, 0),
          //     hoverColor: Color.fromARGB(255, 201, 138, 22),
          //     onTap: () => {
          //       Navigator.of(context)
          //           .pushNamed(
          //             '/view_recipe',
          //             arguments: widget.recipe,
          //           )
          //           .then((_) => setState(() {}))
          //     },
          //   ),


            // Text(
            //   widget.recipe.name,
            //   style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24.0),
            // ),
            // // const Divider(
            // //     thickness: 1, color: Color.fromARGB(255, 135, 156, 142)),
            // ListTile(
            //   title: Text(
            //     "Ready Time: " +
            //         (widget.recipe.prepTimeMin + widget.recipe.cookTimeMin).toString() +
            //         " Mins",
            //     style: const TextStyle(fontWeight: FontWeight.w400),
            //   ),
            // ),
            // ListTile(
            //   title: Text(
            //     "View",
            //     style: TextStyle(
            //         fontWeight: FontWeight.w400,
            //         color: Color.fromARGB(179, 109, 122, 133)),
            //   ),
            //   contentPadding: EdgeInsets.fromLTRB(170, 0, 0, 0),
            //   hoverColor: Color.fromARGB(255, 201, 138, 22),
            //   onTap: () => {
            //     Navigator.of(context)
            //         .pushNamed(
            //           '/view_recipe',
            //           arguments: widget.recipe,
            //         )
            //         .then((_) => setState(() {}))
            //   },
            // ),
            // const Divider(),
            //   Container(
            //     height: 200,
            //     width: double.infinity,
            //     decoration: BoxDecoration(
            //       image: DecorationImage(
            //         //image: Image(),
            //         image: NetworkImage(widget.recipe.imageUrl),
            //         fit: BoxFit.fitWidth,
            //         alignment: Alignment.topCenter,
            //     ),
            //   ),
            // ),
          //],
       // ),
    //  ),
    //);
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
    // return SizedBox(
    //   height: 100,
    //   child: Card(
      return Card(
        shape: const RoundedRectangleBorder(),
        surfaceTintColor: Colors.blueGrey,
        child: StaggeredGrid.count(
          crossAxisCount: 3,
          children: [
            Container(   
              height: 100, //double.infinity,
              width: 100,//double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/small-logo-v2.png'),
                  fit: BoxFit.contain,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),            
            StaggeredGridTile.count(
              crossAxisCellCount: 2,
              mainAxisCellCount: 1,
              //child: SizedBox(
                child: ListView(
                  children: [
                    Text(
                      widget.recipe.name,
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24.0),
                    ),
                    Divider(
                      thickness: 1.5, color: Theme.of(context).colorScheme.secondary),
                    Text(
                      "Ready Time: " +
                          (widget.recipe.prepTimeMin + widget.recipe.cookTimeMin).toString() +
                          " Mins",
                      style: const TextStyle(fontWeight: FontWeight.w400),
                    ),
                    ListTile(
                      leading: Text(
                        "View",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(179, 109, 122, 133)),
                      ),
                      contentPadding: EdgeInsets.fromLTRB(170, 0, 0, 0),
                      hoverColor: Theme.of(context).colorScheme.secondary,
                      onTap: () => {
                        Navigator.of(context)
                            .pushNamed(
                              '/view_recipe',
                              arguments: widget.recipe,
                            )
                            .then((_) => setState(() {}))
                      },
                      trailing:                     TextButton(
                      onPressed: () {
                        _showMyDialog(
                            context,
                            'Are you sure you want to delete this recipe?',
                            widget.recipe);
                      },
                      child: const Icon(
                        Icons.delete,
                        color: Colors.black,
                      ),
                    ),
                    ),
                  ],    
                ),    
             // ),
            ),       
          ],
        )

      );

  // @override
  // Widget build(BuildContext context) {
  //   print("Name " + widget.recipe.name.toString());
  //   print("Cook time " + widget.recipe.cookTimeMin.toString());
  //   print("Ingredients " + widget.recipe.ingredients.toString());
  //   print("Instructions " + widget.recipe.instructions.toString());
  //   return SizedBox(
  //     height: 200,
  //     child: Card(
  //       child: Column(
  //         children: [
  //           ListTile(
  //             title: Text(
  //               widget.recipe.name,
  //               style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24.0),
  //             ),
  //             leading: Icon(
  //               Icons.restaurant_menu,
  //               color: Theme.of(context).colorScheme.secondary,
  //             ),
  //             trailing: TextButton(
  //               onPressed: () {
  //                 _showMyDialog(
  //                     context,
  //                     'Are you sure you want to delete this recipe?',
  //                     widget.recipe);
  //               },
  //               child: const Icon(
  //                 Icons.delete,
  //                 color: Colors.black,
  //               ),
  //             ),
  //           ),
  //           const Divider(
  //               thickness: 1, color: Color.fromARGB(255, 135, 156, 142)),
  //           ListTile(
  //             title: Text(
  //               "Ready Time: " +
  //                   (widget.recipe.prepTimeMin + widget.recipe.cookTimeMin).toString() +
  //                   " Mins",
  //               style: const TextStyle(fontWeight: FontWeight.w400),
  //             ),
  //           ),
  //           ListTile(
  //             title: Text(
  //               "View",
  //               style: TextStyle(
  //                   fontWeight: FontWeight.w400,
  //                   color: Color.fromARGB(179, 109, 122, 133)),
  //             ),
  //             contentPadding: EdgeInsets.fromLTRB(170, 0, 0, 0),
  //             hoverColor: Color.fromARGB(255, 201, 138, 22),
  //             onTap: () => {
  //               Navigator.of(context)
  //                   .pushNamed(
  //                     '/view_recipe',
  //                     arguments: widget.recipe,
  //                   )
  //                   .then((_) => setState(() {}))
  //             },
  //           ),
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
    //       ],
    //     ),
    //   ),
    // );
  }
}

Future<void> _showMyDialog(
    BuildContext context, String message, Recipe recipe) async {
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