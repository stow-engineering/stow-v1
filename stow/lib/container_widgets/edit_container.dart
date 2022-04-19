import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;

import '../models/edit_container_argument.dart';
import '../../utils/firebase.dart';

Future<Barcode> fetchBarcode(
    String barcode, TextEditingController controller) async {
  final response = await http.get(Uri.parse(
      'https://world.openfoodfacts.org/api/v0/product/' + barcode + '.json'));
  if (response.statusCode == 200) {
    var barcode = Barcode.fromJson(jsonDecode(response.body));
    controller.text = barcode.code;
    return Barcode.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to retrieve Barcode Information');
  }
}

class Barcode {
  final String code;
  final String status_verbose;

  const Barcode({
    required this.code,
    required this.status_verbose,
  });

  factory Barcode.fromJson(Map<String, dynamic> json) {
    return Barcode(
        code: json['product']['product_name_en'],
        status_verbose: json['status_verbose']);
  }
}

class EditContainer extends StatefulWidget {
  final EditContainerArgument arg;
  const EditContainer({Key? key, required this.arg}) : super(key: key);

  @override
  State<EditContainer> createState() => _EditContainerState();
}

class _EditContainerState extends State<EditContainer> {
  String scanResult = '';
  String scannedName = '';
  late Future<Barcode> futureBarcode;
  final nameController = TextEditingController();

  String? selectedValue;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    futureBarcode = fetchBarcode('070847037989', nameController);
  }

  @override
  Widget build(BuildContext context) {
    FirebaseService service = FirebaseService(widget.arg.uid);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(),
        body: ListView(
          children: <Widget>[
            Container(
              width: 300,
              height: 250,
              child: Image.asset('assets/customer.png'),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 30.0, right: 30.0, top: 25.0, bottom: 0),
              child: Center(
                  child: Text('Edit your ' + widget.arg.container.name,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 35,
                          fontWeight: FontWeight.bold))),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  // Padding(
                  //   padding: const EdgeInsets.only(
                  //       left: 30.0, right: 30.0, top: 25.0, bottom: 0),
                  //   child: TextFormField(
                  //     controller: nameController,
                  //     decoration: const InputDecoration(
                  //       hintText: 'New Container Name',
                  //     ),
                  //     validator: (String? value) {
                  //       if (value == null || value.isEmpty) {
                  //         return widget.arg.container.name;
                  //       }
                  //       return null;
                  //     },
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 25.0, bottom: 0),
                    child: FutureBuilder<Barcode>(
                      future: futureBarcode,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return TextFormField(
                              controller: nameController,
                              decoration: InputDecoration(
                                hintText: widget.arg.container.name == null
                                    ? 'New Container Name'
                                    : widget.arg.container.name,
                              ));
                        } else if (snapshot.hasError) {
                          return TextFormField(
                              decoration: InputDecoration(
                                  hintText: 'New Container Name'));
                        }
                        return const CircularProgressIndicator();
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
                            name, size!, widget.arg.container.uid);
                        // setState(() async {
                        //   List<BluetoothDevice> devices =
                        //       await FlutterBluePlus.instance.connectedDevices;
                        //   BluetoothDevice dev = devices.firstWhere((d) =>
                        //       d.id.toString() == widget.arg.container.uid);
                        //   List<BluetoothService> services =
                        //       await dev.discoverServices();
                        //   BluetoothService serv = services.firstWhere((s) =>
                        //       s.uuid.toString() ==
                        //       "2d8bdb4c-8be8-4980-a066-4f531f08c626");
                        //   BluetoothCharacteristic char = serv.characteristics
                        //       .firstWhere((c) =>
                        //           c.uuid.toString() ==
                        //           "a0edbb2a-405d-4331-8540-7afaf0e934b9");
                        //   await char.write("registered".codeUnits,
                        //       withoutResponse: true);
                        // });
                      },
                      child: const Text(
                        'Update',
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 23, bottom: 10),
                    child: Container(
                        height: 50,
                        width: 250,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20)),
                        child: TextButton(
                          onPressed: () {
                            _showMyDialog(
                                context,
                                'Are you sure you want to delete this container?',
                                service);
                          },
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 10, bottom: 25.0),
                    child: Container(
                        height: 50,
                        width: 250,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20)),
                        child: TextButton(
                          onPressed: () async {
                            String scanResult;
                            late Future<Barcode> futureBarcode;

                            scanResult =
                                await FlutterBarcodeScanner.scanBarcode(
                                    '#00B050',
                                    'Cancel',
                                    true,
                                    ScanMode.BARCODE);

                            if (!mounted) return;

                            setState(() => this.scanResult = scanResult);

                            futureBarcode =
                                fetchBarcode(scanResult, nameController);
                            setState(() => this.futureBarcode = futureBarcode);
                          },
                          child: Text(
                            'Scan Barcode',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Future<void> _showMyDialog(
      BuildContext context, String message, FirebaseService service) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Just checking...'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                service.deleteContainer(widget.arg.container.uid);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Nope'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Perform scanning
  Future scanBarcode(TextEditingController nameController) async {
    String scanResult;
    late Future<Barcode> futureBarcode;

    scanResult = await FlutterBarcodeScanner.scanBarcode(
        '#00B050', 'Cancel', true, ScanMode.BARCODE);

    if (!mounted) return;

    setState(() => this.scanResult = scanResult);

    futureBarcode = fetchBarcode(scanResult, nameController);
    setState(() => this.futureBarcode = futureBarcode);
  }
}
