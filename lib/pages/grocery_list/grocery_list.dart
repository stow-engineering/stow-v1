import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stow/bloc/grocery_list/grocery_list_bloc.dart';
import 'package:stow/bloc/grocery_list/grocery_list_events.dart';
import 'package:stow/bloc/grocery_list/grocery_list_state.dart';
import 'package:stow/expandable_fab/action_button.dart';
import 'package:stow/models/grocery_lists.dart';
import 'package:stow/widgets/grocery_checkbox.dart';
import 'package:stow/widgets/new_grocery_list_item_dialog.dart';

class IndividualGroceryList extends StatefulWidget {
  IndividualGroceryList({Key? key, required this.id}) : super(key: key);

  String id;

  @override
  State<IndividualGroceryList> createState() => _IndividualGroceryListState();
}

class _IndividualGroceryListState extends State<IndividualGroceryList> {
  @override
  Widget build(BuildContext context) {
    GroceryList? myGroceryList;
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: () => {
                  context
                      .read<GroceryListBloc>()
                      .add(DeleteGroceryList(widget.id)),
                  Navigator.of(context).pop()
                },
                child: const Icon(
                  Icons.delete,
                  size: 26,
                ),
              ),
            )
          ],
        ),
        floatingActionButton: ActionButton(
          onPressed: () => {
            AddGroceryListItemDialog.showAddGroceryListItemDialog(
                context, widget.id)
          },
          icon: const Icon(Icons.add),
          text: const Text("Grocery Item"),
        ),
        body: SafeArea(
          child: BlocBuilder<GroceryListBloc, GroceryListState>(
              bloc: context.read<GroceryListBloc>(),
              builder: (context, state) {
                try {
                  myGroceryList = state.groceryLists
                      .firstWhere((element) => (element).id == widget.id);
                  return ListView.builder(
                      itemCount: myGroceryList?.foodItems?.length ?? 0,
                      itemBuilder: (context, int index) {
                        return GroceryItemCheckbox(
                            name: myGroceryList!.foodItems![index].name,
                            id: widget.id,
                            checked: myGroceryList!.foodItems![index].checked,
                            index: index);
                      });
                } catch (e) {
                  return Container();
                }
              }),
        ));
  }

  GroceryList? getGroceryList(BuildContext context, String id) {
    List<GroceryList> groceryLists =
        context.read<GroceryListBloc>().state.groceryLists;
    for (int i = 0; i < groceryLists.length; i++) {
      if (groceryLists[i].id == id) {
        return groceryLists[i];
      }
    }
    return null;
  }
}
