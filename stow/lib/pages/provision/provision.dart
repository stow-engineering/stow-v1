import 'dart:collection';

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../../models/add_container_argument.dart';
import '../../models/user.dart';
import '../../utils/widgets.dart';

//Place UUID varibales here, not sure if this creates problems
//Guid stowServiceUUID = Guid("2d8bdb4c-8be8-4980-a066-4f531f08c626");
String ssid = "";
String pw = "";

class Provision extends StatefulWidget {
  final StowUser user;
  const Provision({Key? key, required this.user}) : super(key: key);

  @override
  State<Provision> createState() => _ProvisionState();
}

class _ProvisionState extends State<Provision> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BluetoothState>(
        stream: FlutterBluePlus.instance.state,
        initialData: BluetoothState.unknown,
        builder: (c, snapshot) {
          final state = snapshot.data;
          if (state == BluetoothState.on) {
            //return const FindDevicesScreen();
            return PairScreen(user: widget.user);
          }
          return BluetoothOffScreen(state: state);
        });
  }
}

class PairScreen extends StatefulWidget {
  final StowUser user;
  const PairScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<PairScreen> createState() => _PairScreenState();
}

class _PairScreenState extends State<PairScreen> {
  late TextEditingController controller;

  bool buttonenabled = true;
  List<String> idRef = [];
  List<bool> isSyncing = [];
  List<bool> isSuccess = [];
  List<bool> isNotified = [];
  List<bool> isRegisterReady = [];
  List<Guid> service = [Guid("a1593384-978b-4c21-9cc8-b89370582763")];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Devices'),
      ),
      body: RefreshIndicator(
        onRefresh: () => FlutterBluePlus.instance
            .startScan(timeout: const Duration(seconds: 4)),
        child: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            StreamBuilder<List<ScanResult>>(
              stream: FlutterBluePlus.instance.scanResults,
              initialData: const [],
              builder: (c, snapshot) => Column(
                children: snapshot.data!
                    .map((r) => ListTile(
                          title: Text(r.device.name),
                          trailing: ElevatedButton(
                              onPressed: !idRef.contains(r.device.id.toString())
                                  ? () async {
                                      //if buttonenabled == true then pass a function otherwise pass "null"
                                      await r.device.connect();
                                      idRef.add(r.device.id.toString());
                                      isSyncing.add(false);
                                      isNotified.add(false);
                                      isSuccess.add(false);
                                      isRegisterReady.add(false);
                                      setState(() {
                                        //setState to refresh UI
                                        if (buttonenabled) {
                                          buttonenabled = false;
                                          //if buttonenabled == true, then make buttonenabled = false
                                        }
                                      });
                                    }
                                  : null,
                              child: const Text("Select")),
                        ))
                    .toList(),
              ),
            ),
            if (idRef.isNotEmpty)
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20)),
                child: TextButton(
                  onPressed: idRef.isNotEmpty
                      ? () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return ConnectScreen(user: widget.user);
                          }));
                        }
                      : null,
                  child: const Text(
                    'Continue',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
          ],
        )),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBluePlus.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data!) {
            return FloatingActionButton(
              child: const Icon(Icons.stop),
              onPressed: () => FlutterBluePlus.instance.stopScan(),
              backgroundColor: Colors.red,
            );
          } else {
            return FloatingActionButton(
                child: const Icon(Icons.search),
                onPressed: () => FlutterBluePlus.instance.startScan(
                    withServices: service,
                    timeout: const Duration(seconds: 4)));
          }
        },
      ),
    );
  }
}

class ConnectScreen extends StatefulWidget {
  final StowUser user;
  const ConnectScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ConnectScreen> createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool bssid = false;
  bool pass = false;
  List<String> idRef = [];
  List<bool> isSyncing = [];
  List<bool> isSuccess = [];
  List<bool> isNotified = [];
  List<bool> isRegisterReady = [];
  String name = "";
  String code = "";
  String total = "";
  @override
  Widget build(BuildContext context) {
    //final ssidController = TextEditingController();
    //final passController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Connect Devices"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 25.0, bottom: 0),
                    child: TextFormField(
                      key: Key(name),
                      initialValue: name,
                      //controller: ssidController,
                      decoration: const InputDecoration(
                        hintText: 'WiFi Name',
                      ),
                      onTap: () {
                        bssid = true;
                      },
                      onFieldSubmitted: (value) {
                        //ssid = ssidController.text;
                        setState(() {
                          bssid = true;
                          name = value;
                          total = value + " " + code + " ";
                        });
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter a WiFi name';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 25.0, bottom: 0),
                    child: TextFormField(
                      key: Key(code),
                      initialValue: code,
                      //controller: passController,
                      decoration: const InputDecoration(
                        hintText: 'Password',
                      ),
                      onTap: () {
                        pass = true;
                      },
                      onFieldSubmitted: (value) {
                        //password = passController.text;
                        setState(() {
                          pass = true;
                          code = value;
                          total = name + " " + value + " ";
                        });
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter Password';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
                height: 40,
                thickness: 2,
                indent: 150,
                endIndent: 150,
                color: Colors.grey),
            StreamBuilder<List<BluetoothDevice>>(
              stream: Stream.periodic(const Duration(seconds: 4))
                  .asyncMap((_) => FlutterBluePlus.instance.connectedDevices),
              initialData: const [],
              builder: (c, snapshot) => Column(
                children: snapshot.data!
                    .map((d) => ListTile(
                          title: Text(d.name),
                          subtitle: Text(d.id.toString()),
                          trailing: StreamBuilder<BluetoothDeviceState>(
                            stream: d.state,
                            initialData: BluetoothDeviceState.disconnected,
                            builder: (c, snapshot) {
                              if (!idRef.contains(d.id.toString())) {
                                idRef.add(d.id.toString());
                                isSyncing.add(false);
                                isNotified.add(false);
                                isSuccess.add(false);
                                isRegisterReady.add(false);
                              }
                              if (snapshot.data ==
                                      BluetoothDeviceState.connected &&
                                  !isSyncing[idRef.indexOf(d.id.toString())]) {
                                return const Text("Ready");
                              } else if (isSyncing[
                                  idRef.indexOf(d.id.toString())]) {
                                if (isNotified[
                                    idRef.indexOf(d.id.toString())]) {
                                  if (isSuccess[
                                      idRef.indexOf(d.id.toString())]) {
                                    return ElevatedButton(
                                        onPressed: () async {
                                          List<BluetoothDevice> devices =
                                              await FlutterBluePlus
                                                  .instance.connectedDevices;
                                          BluetoothDevice dev =
                                              devices.firstWhere((b) =>
                                                  b.id.toString() ==
                                                  d.id.toString());
                                          List<BluetoothService> services =
                                              await dev.discoverServices();
                                          BluetoothService serv =
                                              services.firstWhere((s) =>
                                                  s.uuid.toString() ==
                                                  "2d8bdb4c-8be8-4980-a066-4f531f08c626");
                                          BluetoothCharacteristic char = serv
                                              .characteristics
                                              .firstWhere((c) =>
                                                  c.uuid.toString() ==
                                                  "a0edbb2a-405d-4331-8540-7afaf0e934b9");
                                          await char.write(
                                              "processing".codeUnits,
                                              withoutResponse: true);
                                          Navigator.of(context).pushNamed(
                                            '/add_container',
                                            arguments: AddContainerArg(
                                                widget.user, d.id.toString()),
                                          );
                                        },
                                        child: const Text("Register"));
                                  } else {
                                    return const Text(
                                        "Connection Failed, Try Again");
                                  }
                                }
                                return const CircularProgressIndicator(); //Text("Connecting...");
                              }
                              return Text(snapshot.data.toString());
                            },
                          ),
                        ))
                    .toList(),
              ),
            ),
            Container(
              height: 40,
            ),
            if (bssid == true && pass == true)
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20)),
                child: TextButton(
                  onPressed: idRef.isNotEmpty
                      ? () async {
                          List<BluetoothDevice> devices =
                              await FlutterBluePlus.instance.connectedDevices;
                          devices.forEach((element) async {
                            isSyncing.insert(
                                idRef.indexOf(element.id.toString()), true);
                            isSuccess[idRef.indexOf(element.id.toString())] =
                                false;
                            isNotified[idRef.indexOf(element.id.toString())] =
                                false;
                            List<BluetoothService> services =
                                await element.discoverServices();
                            services.forEach((s) =>
                                s.characteristics.forEach((c) async {
                                  if (c.uuid.toString() ==
                                      "a0edbb2a-405d-4331-8540-7afaf0e934b9") {
                                    //total = name + " " + code + " ";
                                    await c.write(total.codeUnits,
                                        withoutResponse: true);
                                    await c.setNotifyValue(true);
                                    c.value.listen((event) {
                                      if ("connected" ==
                                          String.fromCharCodes(event)) {
                                        isSuccess[idRef.indexOf(
                                            c.deviceId.toString())] = true;
                                        isNotified[idRef.indexOf(
                                            c.deviceId.toString())] = true;
                                        isNotified[idRef.indexOf(
                                            c.deviceId.toString())] = true;
                                      } else if ("failed" ==
                                          String.fromCharCodes(event)) {
                                        isSuccess[idRef.indexOf(
                                            c.deviceId.toString())] = false;
                                        isNotified[idRef.indexOf(
                                            c.deviceId.toString())] = true;
                                      }
                                      FlutterBluePlus.instance.connectedDevices;
                                    });
                                  } else if (c.uuid.toString() ==
                                      "7b6cb0d3-1a7a-4ce1-92bd-f4b8d5d580d9") {
                                    await c.write(pw.codeUnits,
                                        withoutResponse: true);
                                  }
                                }));
                          });
                        }
                      : null,
                  child: const Text(
                    'Connect',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key? key, this.state}) : super(key: key);

  final BluetoothState? state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.white54,
            ),
            Text(
              'Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'not available'}.',
              style: Theme.of(context)
                  .primaryTextTheme
                  .subtitle2
                  ?.copyWith(color: Colors.white),
            ),
            ElevatedButton(
              child: const Text('TURN ON'),
              onPressed: Platform.isAndroid
                  ? () => FlutterBluePlus.instance.turnOn()
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
