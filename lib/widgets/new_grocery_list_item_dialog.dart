import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/quickalert.dart';
import 'package:stow/bloc/grocery_list/grocery_list_bloc.dart';
import 'package:stow/bloc/grocery_list/grocery_list_events.dart';
import 'package:stow/models/grocery_item.dart';

class AddGroceryListItemDialog {
  static Future<dynamic> showAddGroceryListItemDialog(
      BuildContext context, String id) async {
    String message = "";
    return QuickAlert.show(
      context: context,
      type: QuickAlertType.custom,
      barrierDismissible: true,
      confirmBtnText: 'Add',
      customAsset: 'assets/grocery-store.jpg',
      widget: TextFormField(
        decoration: const InputDecoration(
          alignLabelWithHint: true,
          hintText: 'Grocery Item Name',
          prefixIcon: Icon(
            Icons.dining_outlined,
          ),
        ),
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
        onChanged: (value) => message = value,
      ),
      onConfirmBtnTap: () async {
        if (message.isEmpty) {
          await QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: 'Please input something',
          );
          return;
        }
        GroceryItem groceryItem = GroceryItem(name: message);
        context
            .read<GroceryListBloc>()
            .add(AddToGroceryList([groceryItem], id));
        Navigator.pop(context);
      },
    );
  }
}
