import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stow/bloc/auth/auth_bloc.dart';
import 'package:stow/bloc/grocery_list/grocery_list_bloc.dart';
import 'package:stow/bloc/grocery_list/grocery_list_events.dart';
import 'package:stow/bloc/grocery_list/grocery_list_state.dart';
import 'package:stow/expandable_fab/action_button.dart';
import 'package:stow/models/grocery_lists.dart';
import 'package:stow/widgets/scrollable_widget.dart';
import 'package:stow/widgets/text_dialog_widget.dart';

class EditGroceryList extends StatelessWidget {
  EditGroceryList({Key? key, required this.id}) : super(key: key);
  String id;
  late GroceryListBloc groceryListBloc;
  late AuthBloc authBloc;

  @override
  Widget build(BuildContext context) {
    groceryListBloc = BlocProvider.of<GroceryListBloc>(context);
    authBloc = BlocProvider.of<AuthBloc>(context);

    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: () => {
                  groceryListBloc.add(DeleteGroceryList(id)),
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
            addGroceryItem(
                context,
                groceryListBloc.state.groceryLists
                    .where((element) => element.id == id)
                    .length)
          },
          icon: const Icon(Icons.add),
          text: const Text("Edit"),
        ),
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: ScrollableWidget(
                child: BlocBuilder<GroceryListBloc, GroceryListState>(
              bloc: groceryListBloc,
              builder: (context, state) {
                return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: buildDataTable(state, context));
              },
            )),
          ),
        ));
  }

  Widget buildDataTable(GroceryListState state, BuildContext context) {
    try {
      final columns = ['Grocery Item'];
      var groceryList =
          state.groceryLists.firstWhere((element) => (element).id == id);

      return DataTable(
        columns: getColumns(columns),
        rows: getRows(groceryList.foodItems, context),
      );
    } catch (exception) {
      return const SizedBox();
    }
  }

  List<DataColumn> getColumns(List<String> columns) {
    return columns.map((String column) {
      return DataColumn(label: Text(column));
    }).toList();
  }

  List<DataRow> getRows(List<String>? groceries, BuildContext context) =>
      groceries!.map((String itemName) {
        final cells = [itemName];
        return DataRow(
          cells: modelBuilder(cells, (index, cell) {
            return DataCell(
              Text('$cell'),
              showEditIcon: true,
              onTap: () {
                editGroceryItem(itemName, context);
              },
            );
          }),
        );
      }).toList();

  static List<T> modelBuilder<M, T>(
          List<M> models, T Function(int index, M model) builder) =>
      models
          .asMap()
          .map<int, T>((index, model) => MapEntry(index, builder(index, model)))
          .values
          .toList();

  Future editGroceryItem(String itemName, BuildContext context) async {
    final newItemName = await showTextDialog(context,
        title: "Edit Grocery Item",
        value: itemName,
        foodItem: itemName,
        id: id);

    List<String> newFoodItems = [newItemName];
    groceryListBloc.add(LoadGroceryList(authBloc.state.user!.uid));
  }

  Future addGroceryItem(BuildContext context, int numItems) async {
    final newItemName = await showTextDialog(
      context,
      title: "Add New Grocery Item",
      value: "New Grocery Item",
    );

    if (newItemName != null) {
      List<String> newFoodItems = [newItemName];
      groceryListBloc.add(AddToGroceryList(newFoodItems, id));
      groceryListBloc.add(LoadGroceryList(authBloc.state.user!.uid));
    }
  }
}
