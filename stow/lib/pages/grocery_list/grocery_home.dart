import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stow/bloc/auth/auth_bloc.dart';
import 'package:stow/bloc/grocery_list/grocery_list_bloc.dart';
import 'package:stow/bloc/grocery_list/grocery_list_events.dart';
import 'package:stow/bloc/grocery_list/grocery_list_state.dart';
import 'package:stow/expandable_fab/action_button.dart';
import 'package:stow/models/grocery_lists.dart';
import 'package:stow/pages/grocery_list/edit_grocery_list.dart';

class GroceryListHome extends StatelessWidget {
  const GroceryListHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final groceryListBloc = BlocProvider.of<GroceryListBloc>(context);
    final authBloc = BlocProvider.of<AuthBloc>(context);
    groceryListBloc.add(LoadGroceryList(authBloc.state.user!.uid));
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: ActionButton(
        onPressed: () => {
          Navigator.of(context).pushNamed(
            '/add-grocery-list',
          )
        },
        icon: const Icon(Icons.add),
      ),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 15),
          child: Center(
              child: Text(
            authBloc.state.firstname! + "'s Grocery Lists",
            style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor),
          )),
        ),
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
    );
  }
}

class GroceryListCard extends StatelessWidget {
  GroceryListCard({Key? key, required this.groceryList, required this.index})
      : super(key: key);

  final GroceryList groceryList;
  final int index;

  @override
  Widget build(BuildContext context) {
    String name = groceryList.name ?? "Grocery List: " + index.toString();
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15, top: 2, bottom: 2),
      child: GestureDetector(
        onTap: () => {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return EditGroceryList(id: groceryList.id ?? "");
          }))
        },
        child: Card(
          child: Padding(
              padding: const EdgeInsets.only(left: 5, top: 10, bottom: 10),
              child: Text(
                name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )),
        ),
      ),
    );
  }
}
