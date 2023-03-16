// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:stow/bloc/auth/auth_bloc.dart';
import 'package:stow/bloc/grocery_list/grocery_list_bloc.dart';
import 'package:stow/bloc/grocery_list/grocery_list_events.dart';
import 'package:stow/bloc/grocery_list/grocery_list_state.dart';
import 'package:stow/expandable_fab/action_button.dart';
import 'package:stow/models/grocery_lists.dart';
import 'package:stow/pages/grocery_list/grocery_list.dart';
import 'package:stow/widgets/grocery_list_header.dart';
import 'package:stow/widgets/new_grocery_list_dialog.dart';

class GroceryListHome extends StatelessWidget {
  const GroceryListHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final groceryListBloc = BlocProvider.of<GroceryListBloc>(context);
    final authBloc = BlocProvider.of<AuthBloc>(context);
    groceryListBloc.add(LoadGroceryList(authBloc.state.user!.uid));
    return Scaffold(
      floatingActionButton: ActionButton(
        onPressed: () =>
            {NewGroceryListDialog.showNewGroceryListDialog(context)},
        icon: const Icon(Icons.add),
        text: const Text("Grocery List"),
      ),
      body: SafeArea(
        child: ListView(children: [
          const GroceryListHeader(),
          BlocBuilder<GroceryListBloc, GroceryListState>(
              bloc: groceryListBloc,
              builder: (context, state) {
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: state.groceryLists.length,
                  itemBuilder: (context, index) {
                    return GroceryListCard(
                        groceryList: state.groceryLists[index], index: index);
                  },
                );
              }),
        ]),
      ),
    );
  }
}

class GroceryListCard extends StatelessWidget {
  const GroceryListCard(
      {Key? key, required this.groceryList, required this.index})
      : super(key: key);

  final GroceryList groceryList;
  final int index;

  @override
  Widget build(BuildContext context) {
    String name = groceryList.name ?? "Grocery List: " + index.toString();
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 2, bottom: 2),
      child: GestureDetector(
        onTap: () => {
          // Navigator.push(context, MaterialPageRoute(builder: (context) {
          //   return EditGroceryList(id: groceryList.id ?? "");
          // }))
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return IndividualGroceryList(id: groceryList.id ?? "");
          }))
        },
        child: Card(
          child: Row(children: <Widget>[
            Expanded(
              child: ListView(shrinkWrap: true, children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 7, top: 10),
                  child: Text(
                    name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 7, top: 10),
                  child: Text(
                    DateFormat('MM/dd/yyyy')
                        .format(groceryList.creationDate ?? DateTime.now())
                        .replaceAll(RegExp(" "), ""),
                    style: const TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                ),
              ]),
            ),
            Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 7),
                  child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(75),
                        ),
                        border: Border.all(
                          width: 3,
                          color: Theme.of(context).primaryColor,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Center(
                          child: Text(
                        groceryList.foodItems!.length.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ))),
                )),
          ]),
        ),
      ),
    );
  }
}
