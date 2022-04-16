import 'package:flutter/material.dart';
import 'edit_container_argument.dart';

class EditContainer extends StatefulWidget {
  final EditContainerArgument arg;
  const EditContainer({Key? key, required this.arg}) : super(key: key);

  @override
  State<EditContainer> createState() => _EditContainerState();
}

class _EditContainerState extends State<EditContainer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: 30.0, right: 30.0, top: 25.0, bottom: 0),
              child: Center(
                  child: Text('Edit your ' + widget.arg.container.name,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 35,
                          fontWeight: FontWeight.bold))),
            ),
          ],
        ));
  }
}
