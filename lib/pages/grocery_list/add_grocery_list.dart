// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:stow/bloc/auth/auth_bloc.dart';
import 'package:stow/bloc/grocery_list/grocery_list_bloc.dart';
import 'package:stow/bloc/grocery_list/grocery_list_events.dart';
import 'package:stow/bloc/grocery_list/grocery_list_state.dart';
import 'package:stow/expandable_fab/action_button.dart';
import 'package:stow/models/grocery_lists.dart';

class AddGroceryList extends StatelessWidget {
  const AddGroceryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final groceryListBloc = BlocProvider.of<GroceryListBloc>(context);
    final authBloc = BlocProvider.of<AuthBloc>(context);
    final nameController = TextEditingController();
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 15),
            child: Center(
              child: Text(
                "Add New Grocery List",
                style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 28),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 30.0, right: 30.0, top: 25.0, bottom: 25.0),
            child: TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                  hintText: 'Grocery List Name',
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        width: 1, color: Color.fromARGB(255, 211, 220, 230)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        width: 1, color: Color.fromARGB(255, 0, 176, 80)),
                    borderRadius: BorderRadius.circular(15),
                  )),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your grocery list name';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 30, right: 30, top: 10.0, bottom: 25.0),
            child: Container(
              height: 40,
              width: 372,
              decoration: BoxDecoration(
                  color: Colors.green, borderRadius: BorderRadius.circular(10)),
              child: TextButton(
                onPressed: () {
                  groceryListBloc
                      .add(AddNewGroceryList([], false, nameController.text));
                  groceryListBloc
                      .add(LoadGroceryList(authBloc.state.user!.uid));
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Create',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
