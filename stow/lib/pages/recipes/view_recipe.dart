import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stow/bloc/recipes_events.dart';
//import 'package:stow/models/recipe_model.dart';
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
import 'package:stow/expandable_fab/expandable_fab.dart';
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
      appBar: AppBar(title: Text(widget.recipe.name),),
      body: Card(
        child: Column(
          children: [
            ListTile(
              title: Text("Ingredients List:",//widget.recipe.name,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 24.0),
              ),
            ),
            //Divider(thickness: 1, color: Theme.of(context).colorScheme.secondary),
            ListTile(
              title: Text( widget.recipe.ingredients.toString().replaceAll(RegExp(r']'), "").replaceAll(RegExp(r'\['), ""),

                style: const TextStyle(
                  fontWeight: FontWeight.w400, fontSize: 20.0),
              ),
            ),
            Divider(thickness: 2, color: Theme.of(context).colorScheme.secondary),
            ListTile(
              title: Text("Recipe Instructions:",//widget.recipe.name,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24.0),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              itemCount: widget.recipe.instructions.length,
              itemBuilder: (BuildContext context, index){

              return
                //Divider(thickness: 2, color: Theme.of(context).colorScheme.secondary),
                ListTile(
                  title: Text("Step " + (index+1).toString() + ": " + widget.recipe.instructions[index],
                    style: const TextStyle(
                      fontWeight: FontWeight.w400, fontSize: 20.0),
                  ),
                );
            }),          
          ]
        ),
      )
    );
  }
}