import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stow/bloc/containers/containers_bloc.dart';
import 'package:stow/bloc/food/food_bloc.dart';
import 'package:stow/bloc/grocery_list/grocery_list_bloc.dart';
import 'package:stow/bloc/recipes_bloc.dart';
import 'package:stow/pages/home/home.dart';
import 'package:stow/pages/pantry/pantry.dart';
import 'package:stow/route_generator.dart';
import 'package:stow/utils/firebase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stow/utils/stow_colors.dart';

class BlocProv extends StatelessWidget {
  const BlocProv({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseService service = Provider.of<FirebaseService>(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider<ContainersBloc>(
            create: (_) => ContainersBloc(service: service)),
        BlocProvider<FoodItemsBloc>(
            create: (_) => FoodItemsBloc(service: service)),
        BlocProvider<RecipesBloc>(create: (_) => RecipesBloc(service: service)),
        BlocProvider<GroceryListBloc>(
          create: (_) => GroceryListBloc(service: service),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Stow',
        theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 6, 70, 53),
          primarySwatch:
              createMaterialColor(const Color.fromRGBO(6, 70, 53, 1)),
        ),
        //home: Home(key: key),
        home: Pantry(),
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
