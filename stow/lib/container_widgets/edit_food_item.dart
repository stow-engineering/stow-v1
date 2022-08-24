import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:stow/bloc/auth_bloc.dart';
import 'package:stow/bloc/auth_state.dart';
import 'package:stow/bloc/containers_bloc.dart';
import 'package:stow/bloc/food_bloc.dart';
import 'package:stow/bloc/food_events.dart';
import 'package:stow/models/food_item.dart';
import 'package:stow/models/user.dart';
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

class EditFoodItem extends StatefulWidget {
  final FoodItem foodItem;
  const EditFoodItem({Key? key, required this.foodItem}) : super(key: key);

  @override
  State<EditFoodItem> createState() => _EditFoodItemState();
}

class _EditFoodItemState extends State<EditFoodItem> {
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
    FirebaseService service = Provider.of<FirebaseService>(context);
    final stateBloc = BlocProvider.of<AuthBloc>(context);
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
                  child: Text('Edit ' + widget.foodItem.name,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 35,
                          fontWeight: FontWeight.bold))),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
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
                                hintText: widget.foodItem.name == null
                                    ? 'New FoodItem Name'
                                    : widget.foodItem.name,
                              ));
                        } else if (snapshot.hasError) {
                          return TextFormField(
                              decoration: InputDecoration(
                                  hintText: 'New FoodItem Name'));
                        }
                        return const CircularProgressIndicator();
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
                        final name = nameController.text;
                        FoodItem newFoodItem = FoodItem(
                            name: name,
                            value: widget.foodItem.value,
                            uid: widget.foodItem.uid,
                            barcode: widget.foodItem.barcode);
                        context
                            .read<FoodItemsBloc>()
                            .add(UpdateFoodItems(newFoodItem));
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
                                'Are you sure you want to delete this foodItem?',
                                service,
                                stateBloc.state.user,
                                widget.foodItem);
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

  Future<void> _showMyDialog(BuildContext context, String message,
      FirebaseService service, StowUser? user, FoodItem foodItem) async {
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
                context.read<FoodItemsBloc>().add(DeleteFoodItems(foodItem));
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
