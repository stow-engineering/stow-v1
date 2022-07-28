import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'container.dart' as customContainer;
import 'edit_container_argument.dart';

class GroceryList extends StatefulWidget {
  final String uid;
  const GroceryList({Key? key, required this.uid}) : super(key: key);
  @override
  _GroceryListState createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  @override
  Widget build(BuildContext context) {
    final containers = Provider.of<List<customContainer.Container>>(context);

    return containers == null
        ? Container()
        : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: containers.length,
            itemBuilder: (context, index) {
              return GroceryDisplay(containers[index], widget.uid);
            },
          );
  }
}

class GroceryDisplay extends StatelessWidget {
  final customContainer.Container container;
  final String uid;
  bool checkVal = false;

  GroceryDisplay(this.container, this.uid);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Card(
          margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
          child: ListTile(
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    '/edit_container',
                    arguments: EditContainerArgument(uid, container),
                  );
                },
              ),
              leading: Checkbox(
                value: checkVal,
                onChanged: (bool? newValue) {
                  checkVal = newValue!;
                },
              ),
              title: Text(container.name.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: container.size == 'Small'
                  ? Text((((165 - container.value) / 165) * 100)
                          .round()
                          .toString() +
                      "% [" +
                      container.size +
                      "]")
                  : Text((((273 - container.value) / 273) * 100)
                          .round()
                          .toString() +
                      "% [" +
                      container.size +
                      "]")), //Text(container.value.toString())),
        ));
  }
}
