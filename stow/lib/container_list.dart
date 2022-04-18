import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'container.dart' as customContainer;
import 'edit_container_argument.dart';

class ContainerList extends StatefulWidget {
  final String uid;
  const ContainerList({Key? key, required this.uid}) : super(key: key);
  @override
  _ContainerListState createState() => _ContainerListState();
}

class _ContainerListState extends State<ContainerList> {
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
              return ContainerDisplay(containers[index], widget.uid);
            },
          );
  }
}

class ContainerDisplay extends StatelessWidget {
  final customContainer.Container container;
  final String uid;

  ContainerDisplay(this.container, this.uid);

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
              leading: CircularProgressIndicator(
                value: container.size == 'Small'
                    ? ((165 - container.value) / 165)
                    : ((273 - container.value) / 273),
                backgroundColor: Colors.grey[350],
                strokeWidth: 8.0,
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
