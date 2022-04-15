import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stow/container_chart.dart';
import 'package:stow/database.dart';
import 'package:stow/user.dart';
import 'add_container_argument.dart';
import 'container_list.dart';
import 'user_auth.dart';
import 'login.dart';
import 'container_series.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'container_chart.dart';
import 'container.dart' as customContainer;
import 'user_containers.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class AddContainer extends StatefulWidget {
  final AddContainerArg arg;
  const AddContainer({Key? key, required this.arg}) : super(key: key);

  @override
  State<AddContainer> createState() => _AddContainerState();
}

class _AddContainerState extends State<AddContainer> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectedValue;
  @override
  Widget build(BuildContext context) {
    DatabaseService service = DatabaseService(widget.arg.user.uid);
    final nameController = TextEditingController();
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(
                left: 30.0, right: 30.0, top: 25.0, bottom: 25.0),
            child: Center(
              child: Text(
                "Register Your Container",
                style: TextStyle(color: Colors.black, fontSize: 35),
              ),
            ),
          ),
          Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 25.0, bottom: 0),
                    child: TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        hintText: 'Container Name',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 25.0, bottom: 25.0),
                    child: DropdownButtonFormField(
                      value: selectedValue,
                      items: const <DropdownMenuItem>[
                        DropdownMenuItem(
                          child: Text('Large'),
                          value: 'Large',
                        ),
                        DropdownMenuItem(child: Text('Small'), value: 'Small')
                      ],
                      onChanged: (dynamic newValue) {
                        selectedValue = newValue;
                      },
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 250,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20)),
                    child: TextButton(
                      onPressed: () {
                        final size = selectedValue;
                        final name = nameController.text;
                        service.updateContainerData(
                            name, size!, widget.arg.mac);
                        service.updateContainers(widget.arg.mac);
                        setState(() async {
                          List<BluetoothDevice> devices =
                              await FlutterBluePlus.instance.connectedDevices;
                          BluetoothDevice dev = devices.firstWhere(
                              (d) => d.id.toString() == widget.arg.mac);
                          List<BluetoothService> services =
                              await dev.discoverServices();
                          BluetoothService serv = services.firstWhere((s) =>
                              s.uuid.toString() ==
                              "2d8bdb4c-8be8-4980-a066-4f531f08c626");
                          BluetoothCharacteristic char = serv.characteristics
                              .firstWhere((c) =>
                                  c.uuid.toString() ==
                                  "a0edbb2a-405d-4331-8540-7afaf0e934b9");
                          await char.write("registered".codeUnits,
                              withoutResponse: true);
                        });
                      },
                      child: const Text(
                        'Create my container!',
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
