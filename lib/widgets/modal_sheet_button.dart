// Flutter imports:
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ModalSheetButton extends StatelessWidget {
  ModalSheetButton(
      {Key? key, required this.text, required this.route, this.args})
      : super(key: key);

  String text;
  String route;
  dynamic args;

  @override
  Widget build(BuildContext context) {
    // ignore: sized_box_for_whitespace
    return Container(
      height: 70,
      width: MediaQuery.of(context).size.width,
      //decoration: BoxDecoration(border: Border.all()),
      child: TextButton(
        onPressed: () {
          Navigator.of(context).pop();
          if (args == null) {
            Navigator.of(context).pushNamed(
              route,
            );
          } else {
            Navigator.of(context).pushNamed(
              route,
              arguments: args,
            );
          }
        },
        child: Text(
          text,
          style: const TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
