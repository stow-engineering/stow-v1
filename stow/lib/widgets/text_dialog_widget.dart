import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stow/bloc/grocery_list/grocery_list_bloc.dart';
import 'package:stow/bloc/grocery_list/grocery_list_events.dart';

Future<T?> showTextDialog<T>(BuildContext context,
        {required String title,
        required String value,
        String? foodItem,
        String? id}) =>
    showDialog<T>(
      context: context,
      barrierDismissible: false,
      builder: (context) => TextDialogWidget(
          title: title, value: value, foodItem: foodItem, id: id),
    );

class TextDialogWidget extends StatefulWidget {
  final String title;
  final String value;
  final String? foodItem;
  final String? id;
  bool showDeleteButton = false;

  TextDialogWidget({
    Key? key,
    required this.title,
    required this.value,
    this.foodItem,
    this.id,
  }) : super(key: key);

  @override
  _TextDialogWidgetState createState() => _TextDialogWidgetState();
}

class _TextDialogWidgetState extends State<TextDialogWidget> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();

    if (widget.title == "Edit Grocery Item") {
      widget.showDeleteButton = true;
    }
    controller = TextEditingController(text: widget.value);
  }

  @override
  Widget build(BuildContext context) {
    final groceryListBloc = BlocProvider.of<GroceryListBloc>(context);
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        if (widget.showDeleteButton)
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red)),
            child: Text('Delete'),
            onPressed: () => {
              groceryListBloc.add(DeleteFoodItemGroceryList(
                  widget.foodItem ?? "", widget.id ?? "")),
              Navigator.of(context).pop()
            },
          ),
        ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow)),
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).primaryColor)),
          child: Text('Done'),
          onPressed: () => Navigator.of(context).pop(controller.text),
        )
      ],
    );
  }
}
