import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stow/bloc/grocery_list/grocery_list_bloc.dart';
import 'package:stow/bloc/grocery_list/grocery_list_events.dart';
import 'package:stow/widgets/edit_grocery_item_dialog.dart';

class GroceryItemCheckbox extends StatefulWidget {
  GroceryItemCheckbox(
      {Key? key,
      required this.name,
      required this.id,
      required this.checked,
      required this.index})
      : super(key: key);

  String name;
  String id;
  bool checked;
  int index;

  @override
  State<GroceryItemCheckbox> createState() => _GroceryItemCheckboxState();
}

class _GroceryItemCheckboxState extends State<GroceryItemCheckbox> {
  bool _checked = false;

  @override
  Widget build(BuildContext context) {
    var text = Text(widget.name);
    if (_checked) {
      text = Text(widget.name,
          style: const TextStyle(decoration: TextDecoration.lineThrough));
    }
    return CheckboxListTile(
        activeColor: Theme.of(context).primaryColor,
        checkColor: Colors.greenAccent,
        controlAffinity: ListTileControlAffinity.leading,
        title: text,
        value: widget.checked,
        secondary: GestureDetector(
          child: const Icon(Icons.edit),
          onTap: () {
            EditGroceryListItemDialog.showEditGroceryItemDialog(
                context, widget.name, widget.id);
          },
        ),
        onChanged: (bool? value) {
          if (value != null) {
            BlocProvider.of<GroceryListBloc>(context)
                .add(CheckGroceryItem(widget.id, value, widget.index));
          }
        });
  }
}
