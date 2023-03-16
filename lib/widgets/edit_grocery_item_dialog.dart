import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/quickalert.dart';
import 'package:stow/bloc/grocery_list/grocery_list_bloc.dart';
import 'package:stow/bloc/grocery_list/grocery_list_events.dart';
import 'package:stow/models/grocery_item.dart';

class EditGroceryListItemDialog {
  static Future<dynamic> showEditGroceryItemDialog(
      BuildContext context, String name, String id) async {
    String message = "";
    return QuickAlert.show(
        context: context,
        type: QuickAlertType.custom,
        barrierDismissible: true,
        showCancelBtn: true,
        cancelBtnText: 'Delete',
        confirmBtnText: 'Save',
        customAsset: 'assets/grocery-store.jpg',
        widget: TextFormField(
          decoration: const InputDecoration(
            alignLabelWithHint: true,
            hintText: 'Grocery Item Name',
            prefixIcon: Icon(
              Icons.featured_play_list,
            ),
          ),
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.phone,
          onChanged: (value) => message = value,
        ),
        onConfirmBtnTap: () async {
          if (message.isEmpty) {
            return;
          }
          context
              .read<GroceryListBloc>()
              .add(DeleteFoodItemGroceryList(name, id));
          GroceryItem groceryItem = GroceryItem(name: message);
          context
              .read<GroceryListBloc>()
              .add(AddToGroceryList([groceryItem], id));
          Navigator.pop(context);
        },
        onCancelBtnTap: () async {
          context
              .read<GroceryListBloc>()
              .add(DeleteFoodItemGroceryList(name, id));
          Navigator.pop(context);
        });
  }
}
