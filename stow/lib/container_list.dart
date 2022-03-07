import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'container.dart' as customContainer;


class ContainerList extends StatefulWidget {
  @override
  _ContainerListState createState() => _ContainerListState();
}

class _ContainerListState extends State<ContainerList> {
  @override 
  Widget build(BuildContext context) {
    final containers = Provider.of<List<customContainer.Container>>(context);

    return ListView.builder(
      itemCount: containers.length,
      itemBuilder: (context, index) {
        return ContainerDisplay(containers[index]);
      },
    );
  }
}

class ContainerDisplay extends StatelessWidget {
  final customContainer.Container container;

  ContainerDisplay(this.container);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.blue[450],
          ),
        title: Text(container.uid),
        subtitle: Text(container.value.toString())
        ),
      )
    );
  }
}

