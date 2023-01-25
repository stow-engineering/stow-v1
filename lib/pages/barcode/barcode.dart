// Dart imports:
import 'dart:async';
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

// Project imports:
import '../../models/user.dart';
import '../../utils/authentication.dart';
import '../home/get_name.dart';

Future<Barcode> fetchBarcode(String barcode) async {
  final response = await http.get(Uri.parse(
      'https://world.openfoodfacts.org/api/v0/product/' + barcode + '.json'));
  if (response.statusCode == 200) {
    return Barcode.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to retrieve Barcode Information');
  }
}

class Barcode {
  final String code;
  final String statusVerbose;

  const Barcode({
    required this.code,
    required this.statusVerbose,
  });

  factory Barcode.fromJson(Map<String, dynamic> json) {
    return Barcode(
        code: json['product']['product_name_en'],
        statusVerbose: json['status_verbose']);
  }
}

class BarcodePage extends StatefulWidget {
  final StowUser user;
  const BarcodePage({Key? key, required this.user}) : super(key: key);

  @override
  State<BarcodePage> createState() => _BarcodePageState();
}

class _BarcodePageState extends State<BarcodePage> {
  String scanResult = '';
  late Future<Barcode> futureBarcode;

  @override
  void initState() {
    super.initState();
    futureBarcode = fetchBarcode('070847037989');
  }

  @override
  Widget build(BuildContext context) {
    // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    // final FirebaseService service = FirebaseService(widget.user.uid);
    final GetName fullName = GetName(widget.user.uid, true);
    final authService = Provider.of<AuthenticationService>(context);
    final GlobalKey<ScaffoldState> _key = GlobalKey();
    return Scaffold(
        key: _key,
        drawer: Drawer(
            child: ListView(
                children: [
              const Icon(Icons.person_rounded,
                  size: 200, color: Color.fromARGB(255, 0, 176, 80)),
              Center(child: fullName),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      '/account',
                      arguments: widget.user,
                    );
                  },
                  child: Row(children: const [
                    Icon(Icons.settings, color: Colors.black),
                    Text(
                      'Profile & Settings',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w300),
                    ),
                  ]),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    '/pantry',
                    arguments: widget.user,
                  );
                },
                child: Row(children: const [
                  Icon(Icons.kitchen, color: Colors.black),
                  Text(
                    'Check your pantry',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w300),
                  ),
                ]),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    '/recipes',
                    arguments: widget.user,
                  );
                },
                child: Row(children: const [
                  Icon(Icons.blender, color: Colors.black),
                  Text(
                    'Browse recipes',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w300),
                  ),
                ]),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    '/groceries',
                    arguments: widget.user,
                  );
                },
                child: Row(children: const [
                  Icon(Icons.settings, color: Colors.black),
                  Text(
                    'Update grocery lists',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w300),
                  ),
                ]),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed('/barcode', arguments: widget.user);
                },
                child: Row(children: const [
                  Icon(Icons.scanner, color: Colors.black),
                  Text(
                    'Scan barcode',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w300),
                  ),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: OutlinedButton(
                    onPressed: () {
                      authService.signOut();
                    },
                    // style: const ButtonStyle(side: BorderSide(color: Colors.red, width: 2),)
                    child: const Text(
                      "Sign Out",
                      style: TextStyle(color: Colors.red),
                    )),
              )
            ],
                padding: const EdgeInsets.only(
                    top: 40, bottom: 40, left: 20, right: 20))),
        backgroundColor: Colors.white,
        // floatingActionButton: FloatingActionButton(
        //     onPressed: () {},
        //     backgroundColor: Colors.green,
        //     child: const Icon(Icons.add)),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (int selected) => {
            if (selected == 0)
              {
                Navigator.of(context).pushNamed(
                  '/home',
                  arguments: widget.user,
                )
              }
            else if (selected == 1)
              {
                Navigator.of(context).pushNamed(
                  '/pantry',
                  arguments: widget.user,
                )
              }
            else if (selected == 2)
              {
                Navigator.of(context).pushNamed(
                  '/recipes',
                  arguments: widget.user,
                )
              }
            else if (selected == 3)
              {
                Navigator.of(context).pushNamed(
                  '/groceries',
                  arguments: widget.user,
                )
              }
          },
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            // BottomNavigationBarItem(
            //     icon: Icon(Icons.local_grocery_store), label: 'Groceries'),
            BottomNavigationBarItem(icon: Icon(Icons.kitchen), label: 'Pantry'),
            BottomNavigationBarItem(
                icon: Icon(Icons.blender), label: 'Recipes'),
          ],
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.menu),
            color: const Color.fromARGB(255, 211, 220, 230),
            onPressed: () => {_key.currentState!.openDrawer()},
            iconSize: 45,
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        // body: ContainerList(),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Container(
                height: 40,
                width: 200,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 0, 176, 80),
                    borderRadius: BorderRadius.circular(10)),
                child: TextButton(
                  onPressed: scanBarcode,
                  child: const Text(
                    'Scan Barcode',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FutureBuilder<Barcode>(
                future: futureBarcode,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data!.code);
                  } else if (snapshot.hasError) {
                    return const Text('Error');
                  }
                  return const CircularProgressIndicator();
                },
              )
            ])));
  }

  // Perform scanning
  Future scanBarcode() async {
    String scanResult;
    late Future<Barcode> futureBarcode;

    try {
      scanResult = await FlutterBarcodeScanner.scanBarcode(
          '#00B050', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      scanResult = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() => this.scanResult = scanResult);

    futureBarcode = fetchBarcode(scanResult);
    setState(() => this.futureBarcode = futureBarcode);
  }
}
