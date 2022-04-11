import 'dart:collection';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'widgets.dart';

//Place UUID varibales here, not sure if this creates problems
//Guid stowServiceUUID = Guid("2d8bdb4c-8be8-4980-a066-4f531f08c626");
String ssid = "LAWDAWG";
String pw = "ilovepizza";

class Provision extends StatelessWidget {
  const Provision({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BluetoothState>(
        stream: FlutterBluePlus.instance.state,
        initialData: BluetoothState.unknown,
        builder: (c, snapshot) {
          final state = snapshot.data;
          if (state == BluetoothState.on) {
            //return const FindDevicesScreen();
            return const PairScreen();
          }
          return BluetoothOffScreen(state: state);
        });
  }
}

class PairScreen extends StatefulWidget {
  const PairScreen({Key? key}) : super(key: key);

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

  @override
  initState() {
    super.initState();

    controller = TextEditingController();
  }

  @override
  dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<String?> openDialog(String n) => showDialog<String>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(n),
            content: TextField(
              decoration: const InputDecoration(hintText: 'Type here'),
              autofocus: true,
              controller: controller,
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(controller.text);
                    controller.clear();
                  },
                  child: const Text('SUBMIT'))
            ],
          ),
        );
    return Scaffold(
      appBar: AppBar(
        title: const Text("Connect and Register Stow Device"),
        actions: [
          ElevatedButton(
              child: const Text('Connect Devices'),
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                onPrimary: Colors.white,
              ),
              onPressed: () async {
                ssid = (await openDialog('SSID'))!;
                pw = (await openDialog('Password'))!;
                List<BluetoothDevice> devices =
                    await FlutterBluePlus.instance.connectedDevices;
                devices.forEach((element) async {
                  isSyncing.insert(idRef.indexOf(element.id.toString()), true);
                  isSuccess[idRef.indexOf(element.id.toString())] = false;
                  isNotified[idRef.indexOf(element.id.toString())] = false;
                  List<BluetoothService> services =
                      await element.discoverServices();
                  services.forEach((s) => s.characteristics.forEach((c) async {
                        if (c.uuid.toString() ==
                            "a0edbb2a-405d-4331-8540-7afaf0e934b9") {
                          await c.write(ssid.codeUnits, withoutResponse: true);
                          await c.setNotifyValue(true);
                          c.value.listen((event) {
                            if ("connected" == String.fromCharCodes(event)) {
                              isSuccess[idRef.indexOf(c.deviceId.toString())] =
                                  true;
                              isNotified[idRef.indexOf(c.deviceId.toString())] =
                                  true;
                              isNotified[idRef.indexOf(c.deviceId.toString())] =
                                  true;
                            } else if ("failed" ==
                                String.fromCharCodes(event)) {
                              isSuccess[idRef.indexOf(c.deviceId.toString())] =
                                  false;
                              isNotified[idRef.indexOf(c.deviceId.toString())] =
                                  true;
                            }
                            FlutterBluePlus.instance.connectedDevices;
                          });
                        } else if (c.uuid.toString() ==
                            "7b6cb0d3-1a7a-4ce1-92bd-f4b8d5d580d9") {
                          await c.write(pw.codeUnits, withoutResponse: true);
                        }
                      }));
                });
                //ssid = (await openDialog('SSID'))!;
                //pw = (await openDialog('Password'))!;
                /*
                devices.map((e) => () async {
                      List<BluetoothService> services =
                          await e.discoverServices();
                      services
                          .map((s) => s.characteristics.map((c) => () async {
                                if (c.uuid.toString() ==
                                    "a0edbb2a-405d-4331-8540-7afaf0e934b9") {
                                  await c.write(ssid.codeUnits,
                                      withoutResponse: true);
                                } else if (c.uuid.toString() ==
                                    "7b6cb0d3-1a7a-4ce1-92bd-f4b8d5d580d9") {
                                  await c.write(pw.codeUnits,
                                      withoutResponse: true);
                                }
                              }));
                    });
                    */
                /*
                  devices.map((d) => d.services.map((s) => s
                      .where((q) =>
                          q.uuid.toString() ==
                          "2d8bdb4c-8be8-4980-a066-4f531f08c626")
                      .map((e) => e.characteristics.map((c) => () async {
                            if (c.uuid.toString() ==
                                "a0edbb2a-405d-4331-8540-7afaf0e934b9") {
                              await c.write(ssid.codeUnits,
                                  withoutResponse: true);
                            } else {
                              await c.write(pw.codeUnits,
                                  withoutResponse: true);
                            }
                          }))));
                          */
              }),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => FlutterBluePlus.instance
            .startScan(timeout: const Duration(seconds: 4)),
        child: SingleChildScrollView(
            child: Column(
          children: <Widget>[
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
                                return Text(
                                    "Ready to Connect Stow Device to WiFi");
                              } else if (isSyncing[
                                  idRef.indexOf(d.id.toString())]) {
                                if (isNotified[
                                    idRef.indexOf(d.id.toString())]) {
                                  if (isSuccess[
                                      idRef.indexOf(d.id.toString())]) {
                                    return ElevatedButton(
                                        onPressed: () => {
                                              Navigator.of(context).pushNamed(
                                                '/register',
                                                arguments: d.id.toString(),
                                              )
                                            },
                                        child: Text("Register"));
                                  } else {
                                    return Text("Connection Failed, Try Again");
                                  }
                                }
                                return Text("Connecting");
                              }
                              return Text(snapshot.data.toString());
                            },
                          ),
                        ))
                    .toList(),
              ),
            ),
            StreamBuilder<List<ScanResult>>(
              stream: FlutterBluePlus.instance.scanResults,
              initialData: const [],
              builder: (c, snapshot) => Column(
                children: snapshot.data!
                    .where((e) =>
                        e.device.name == "Stow") //filter to devices named stow
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
                              child: Text("Select")),
                          /*onTap: () async {
                            if (await r.device.state == '1')
                              await r.device.connect();
                          },
                          */
                        ))
                    .toList(),
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
                onPressed: () => FlutterBluePlus.instance
                    .startScan(timeout: const Duration(seconds: 4)));
          }
        },
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

class FindDevicesScreen extends StatefulWidget {
  const FindDevicesScreen({Key? key}) : super(key: key);

  @override
  State<FindDevicesScreen> createState() => _FindDevicesScreenState();
}

class _FindDevicesScreenState extends State<FindDevicesScreen> {
  late TextEditingController controller;

  @override
  initState() {
    super.initState();

    controller = TextEditingController();
  }

  @override
  dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<String?> openDialog(String n) => showDialog<String>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(n),
            content: TextField(
              decoration: const InputDecoration(hintText: 'Type here'),
              autofocus: true,
              controller: controller,
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(controller.text),
                  child: const Text('SUBMIT'))
            ],
          ),
        );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Devices'),
        actions: [
          ElevatedButton(
            child: const Text('TURN OFF'),
            style: ElevatedButton.styleFrom(
              primary: Colors.black,
              onPrimary: Colors.white,
            ),
            onPressed: Platform.isAndroid
                ? () => FlutterBluePlus.instance.turnOff()
                : null,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => FlutterBluePlus.instance
            .startScan(timeout: const Duration(seconds: 4)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<List<BluetoothDevice>>(
                stream: Stream.periodic(const Duration(seconds: 2))
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
                                if (snapshot.data ==
                                    BluetoothDeviceState.connected) {
                                  return ElevatedButton(
                                    child: const Text('OPEN'),
                                    onPressed: () async {
                                      await d.connect();
                                      ssid = (await openDialog('SSID'))!;
                                      pw = (await openDialog('Password'))!;
                                    },
                                  );
                                }
                                return Text(snapshot.data.toString());
                              },
                            ),
                          ))
                      .toList(),
                ),
              ),
              StreamBuilder<List<ScanResult>>(
                stream: FlutterBluePlus.instance.scanResults,
                initialData: const [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data!
                      .where((e) =>
                          e.device.name ==
                          "Stow") //filter to devices named stow
                      .map(
                        (r) => ScanResultTile(
                          result: r,
                          onTap: () => Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            r.device.connect();
                            return DeviceScreen(device: r.device);
                          })),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
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
                onPressed: () => FlutterBluePlus.instance
                    .startScan(timeout: const Duration(seconds: 4)));
          }
        },
      ),
    );
  }
}

class DeviceScreen extends StatefulWidget {
  const DeviceScreen({Key? key, required this.device}) : super(key: key);

  final BluetoothDevice device;

  @override
  State<DeviceScreen> createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  late TextEditingController controller;

  @override
  initState() {
    super.initState();

    controller = TextEditingController();
  }

  @override
  dispose() {
    controller.dispose();

    super.dispose();
  }

  List<int> _getRandomBytes() {
    final math = Random();
    return [
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255)
    ];
  }

  List<Widget> _buildServiceTiles(List<BluetoothService> services) {
    return services
        .where(
            (e) => e.uuid.toString() == "2d8bdb4c-8be8-4980-a066-4f531f08c626")
        .map(
          (s) => ServiceTile(
            service: s,
            characteristicTiles: s.characteristics
                .map(
                  (c) => CharacteristicTile(
                    characteristic: c,
                    onReadPressed: () => c.read(),
                    onWritePressed: () async {
                      if (c.uuid.toString() ==
                          "a0edbb2a-405d-4331-8540-7afaf0e934b9") {
                        await c.write(ssid.codeUnits, withoutResponse: true);
                      } else {
                        await c.write(pw.codeUnits, withoutResponse: true);
                      }
                      await c.read();
                    },
                    onNotificationPressed: () async {
                      await c.setNotifyValue(!c.isNotifying);
                      await c.read();
                    },
                    descriptorTiles: c.descriptors
                        .map(
                          (d) => DescriptorTile(
                            descriptor: d,
                            onReadPressed: () => d.read(),
                            onWritePressed: () => d.write(_getRandomBytes()),
                          ),
                        )
                        .toList(),
                  ),
                )
                .toList(),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    Future<String?> openDialog(String n) => showDialog<String>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(n),
            content: TextField(
              decoration: const InputDecoration(hintText: 'Type here'),
              autofocus: true,
              controller: controller,
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(controller.text),
                  child: const Text('SUBMIT'))
            ],
          ),
        );
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.name),
        actions: <Widget>[
          StreamBuilder<BluetoothDeviceState>(
            stream: widget.device.state,
            initialData: BluetoothDeviceState.connecting,
            builder: (c, snapshot) {
              VoidCallback? onPressed;
              String text;
              switch (snapshot.data) {
                case BluetoothDeviceState.connected:
                  onPressed = () => widget.device.disconnect();
                  text = 'DISCONNECT';
                  break;
                case BluetoothDeviceState.disconnected:
                  onPressed = () async {
                    widget.device.connect();
                    ssid = (await openDialog('SSID'))!;
                    pw = (await openDialog('Password'))!;
                    //write to ble
                  };
                  text = 'CONNECT';
                  break;
                default:
                  onPressed = null;
                  text = snapshot.data.toString().substring(21).toUpperCase();
                  break;
              }
              return TextButton(
                  onPressed: onPressed,
                  child: Text(
                    text,
                    style: Theme.of(context)
                        .primaryTextTheme
                        .button
                        ?.copyWith(color: Colors.white),
                  ));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StreamBuilder<BluetoothDeviceState>(
              stream: widget.device.state,
              initialData: BluetoothDeviceState.connecting,
              builder: (c, snapshot) => ListTile(
                leading: (snapshot.data == BluetoothDeviceState.connected)
                    ? const Icon(Icons.bluetooth_connected)
                    : const Icon(Icons.bluetooth_disabled),
                title: Text(
                    'Device is ${snapshot.data.toString().split('.')[1]}.'),
                subtitle: Text('${widget.device.id}'),
                trailing: StreamBuilder<bool>(
                  stream: widget.device.isDiscoveringServices,
                  initialData: false,
                  builder: (c, snapshot) => IndexedStack(
                    index: snapshot.data! ? 1 : 0,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () => widget.device.discoverServices(),
                      ),
                      const IconButton(
                        icon: SizedBox(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.grey),
                          ),
                          width: 18.0,
                          height: 18.0,
                        ),
                        onPressed: null,
                      )
                    ],
                  ),
                ),
              ),
            ),
            StreamBuilder<int>(
              stream: widget.device.mtu,
              initialData: 0,
              builder: (c, snapshot) => ListTile(
                title: const Text('MTU Size'),
                subtitle: Text('${snapshot.data} bytes'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => widget.device.requestMtu(223),
                ),
              ),
            ),
            StreamBuilder<List<BluetoothService>>(
              stream: widget.device.services,
              initialData: const [],
              builder: (c, snapshot) {
                return Column(
                  children: _buildServiceTiles(snapshot.data!),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
