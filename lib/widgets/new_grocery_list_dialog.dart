import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/quickalert.dart';
import 'package:stow/bloc/auth/auth_bloc.dart';
import 'package:stow/bloc/grocery_list/grocery_list_bloc.dart';
import 'package:stow/bloc/grocery_list/grocery_list_events.dart';

class NewGroceryListDialog {
  static Future<dynamic> showNewGroceryListDialog(BuildContext context) async {
    String message = "";
    return QuickAlert.show(
      context: context,
      type: QuickAlertType.custom,
      barrierDismissible: true,
      confirmBtnText: 'Save',
      customAsset: 'assets/grocery-store.jpg',
      widget: TextFormField(
        decoration: const InputDecoration(
          alignLabelWithHint: true,
          hintText: 'Grocery List Name',
          prefixIcon: Icon(
            Icons.featured_play_list,
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
        context
            .read<GroceryListBloc>()
            .add(AddNewGroceryList(const [], false, message));
        context
            .read<GroceryListBloc>()
            .add(LoadGroceryList(context.read<AuthBloc>().state.user!.uid));
        Navigator.pop(context);
        await Future.delayed(const Duration(milliseconds: 1000));
        await QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: "Grocery List '$message' has been created!.",
        );
      },
    );
  }
}
