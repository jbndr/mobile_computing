import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:mobile_computing/logic/queue_logic.dart';
import 'package:mobile_computing/pages/BluetoothPage.dart';
import 'package:mobile_computing/pages/HomePage.dart';
import 'package:mobile_computing/pages/BasicsPage.dart';
import 'package:mobile_computing/widgets/tiles.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  int _selectedTab = 0;
  List<Widget> _pages = [HomePage(), BasicPage(), BluetoothPage()];
  List<String> _names = ["Home", "Basics", "Bluetooth"];

  FlutterBlue flutterBlue = FlutterBlue.instance;

  /// Scanning
  StreamSubscription _scanSubscription;
  Map<DeviceIdentifier, ScanResult> scanResults = new Map();
  bool isScanning = false;

  /// State
  StreamSubscription _stateSubscription;
  BluetoothState state = BluetoothState.unknown;

  /// Device
  BluetoothDevice device;
  bool get isConnected => (device != null);
  StreamSubscription deviceConnection;
  StreamSubscription deviceStateSubscription;
  List<BluetoothService> services = new List();
  Map<Guid, StreamSubscription> valueChangedSubscriptions = {};
  BluetoothDeviceState deviceState = BluetoothDeviceState.disconnected;

  /// Service
  BluetoothCharacteristic tecoCharacteristic;

  /// Characteristic
  BluetoothService tecoService;

  _buildScanningButton() {
    TextStyle style = TextStyle(color: Colors.white);

    if (state != BluetoothState.on) {
      return SizedBox();
    }

    if (isConnected) {
      return FlatButton(
        onPressed: _disconnect,
        child: Text("DISCONNECT", style: style),
      );
    }

    if (isScanning) {
      return FlatButton(
        onPressed: _stopScan,
        child: Text("STOP SCANNING", style: style),
      );
    } else {
      return FlatButton(
        onPressed: _startScan,
        child: Text("SCAN", style: style),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var tiles = new List<Widget>();

    if (state != BluetoothState.on) {
      tiles.add(_buildAlertTile());
    }
    if (isConnected) {
      tiles.add(_buildDeviceStateTile());
      _findTecoService();
    } else {
      tiles.addAll(_buildScanResultTiles());
    }

    var flatButton;
    if (_selectedTab == 2) {
      flatButton = _buildScanningButton();
    } else if (_selectedTab == 1) {
      flatButton = _buildBasicsPageActions();
    } else {
      flatButton = SizedBox();
    }

    _pages[1] = BasicPage(characteristic: tecoCharacteristic, device: device, service: tecoService);
    _pages[2] = BluetoothPage(isScanning: isScanning, tiles: tiles);

    return MaterialApp(
      title: "Mobile Computing App",
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: Provider(
        value: QueueBloc(device, tecoCharacteristic),
        child: Scaffold(
          appBar: AppBar(
            title: Text(_names[_selectedTab]),
            actions: <Widget>[flatButton],
          ),
          body: _pages[_selectedTab],
          bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.home), title: Text("Home")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.school), title: Text("Basics")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.bluetooth), title: Text("Bluetooth")),
            ],
            onTap: (int index) {
              setState(() {
                _selectedTab = index;
              });
            },
            currentIndex: _selectedTab,
          ),
        ),
      ),
    );
  }

  _startScan() {
    scanResults = new Map();
    _scanSubscription = flutterBlue
        .scan(timeout: const Duration(seconds: 5))
        .listen((scanResult) {
      print('localName: ${scanResult.advertisementData.localName}');
      print(
          'manufacturerData: ${scanResult.advertisementData.manufacturerData}');
      print('serviceData: ${scanResult.advertisementData.serviceData}');
      setState(() {
        scanResults[scanResult.device.id] = scanResult;
      });
    }, onDone: _stopScan);

    setState(() {
      isScanning = true;
    });
  }

  _stopScan() {
    _scanSubscription?.cancel();
    _scanSubscription = null;
    setState(() {
      isScanning = false;
    });
  }

  @override
  void initState() {
    super.initState();
    flutterBlue.state.then((s) {
      setState(() {
        state = s;
      });
    });
    _stateSubscription = flutterBlue.onStateChanged().listen((s) {
      setState(() {
        state = s;
      });
    });
  }

  @override
  void dispose() {
    _stateSubscription?.cancel();
    _stateSubscription = null;
    _scanSubscription?.cancel();
    _scanSubscription = null;
    deviceConnection?.cancel();
    deviceConnection = null;
    super.dispose();
  }

  _buildAlertTile() {
    _disconnect();
    return new Container(
      color: state == BluetoothState.off
          ? Colors.red
          : ((state == BluetoothState.turningOn) ? Colors.green : Colors.orange),
      child: new ListTile(
        title: new Text(
          'Bluetooth adapter is ${state.toString().substring(15)}',
          style: Theme.of(context).primaryTextTheme.subhead,
        ),
        trailing: new Icon(
          Icons.error,
          color: Theme.of(context).primaryTextTheme.subhead.color,
        ),
      ),
    );
  }

  _buildScanResultTiles() {
    return scanResults.values
        .map((r) => ScanResultTile(
              result: r,
              onTap: () => _connect(r.device),
            ))
        .toList();
  }

  _connect(BluetoothDevice d) async {
    device = d;
    // Connect to device
    deviceConnection =
        flutterBlue.connect(device, timeout: const Duration(seconds: 4)).listen(
              null,
              onDone: _disconnect,
            );

    // Update the connection state immediately
    device.state.then((s) {
      setState(() {
        deviceState = s;
      });
    });

    // Subscribe to connection changes
    deviceStateSubscription = device.onStateChanged().listen((s) {
      setState(() {
        deviceState = s;
      });
      if (s == BluetoothDeviceState.connected) {
        device.discoverServices().then((s) {
          setState(() {
            services = s;
          });
        });
      }
    });
  }

  _disconnect() {
    valueChangedSubscriptions.forEach((uuid, sub) => sub.cancel());
    valueChangedSubscriptions.clear();
    deviceStateSubscription?.cancel();
    deviceStateSubscription = null;
    deviceConnection?.cancel();
    deviceConnection = null;
    setState(() {
      device = null;
      tecoService = null;
      tecoCharacteristic = null;
    });
  }

  _buildDeviceStateTile() {
    return new ListTile(
        leading: (deviceState == BluetoothDeviceState.connected)
            ? const Icon(Icons.bluetooth_connected)
            : const Icon(Icons.bluetooth_disabled),
        title: new Text('Device is ${deviceState.toString().split('.')[1]}.'),
        subtitle: new Text('${device.id}'),
        trailing: new IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () => _refreshDeviceState(device),
          color: Theme.of(context).iconTheme.color.withOpacity(0.5),
        ));
  }

  _refreshDeviceState(BluetoothDevice d) async {
    var state = await d.state;
    setState(() {
      deviceState = state;
      print('State refreshed: $deviceState');
    });
  }

  Future _findTecoService() async {
    var foundService;

    services.forEach((service) {
      if (service.uuid.toString() == "713d0000-503e-4c75-ba94-3148f18d941e") {
        foundService = service;
      }
    });

    var characteristics = foundService.characteristics;
    var foundCharacteristic;

    for (BluetoothCharacteristic c in characteristics) {
      if (c.uuid.toString() == "713d0003-503e-4c75-ba94-3148f18d941e") {
        foundCharacteristic = c;
      }
    }

    setState(() {
      tecoService = foundService;
      tecoCharacteristic = foundCharacteristic;
    });
  }

  Widget _buildBasicsPageActions() {

    return Builder(
      builder: (context) {
        return StreamBuilder<Queue>(
          stream: Provider.of<QueueBloc>(context).queueStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.requireData.isEmpty) {
              return SizedBox();
            } else {
              return Row(
                children: <Widget>[
                  StreamBuilder<bool>(
                    stream: Provider.of<QueueBloc>(context).pausableStream,
                    builder: (context, snapshot) {
                      bool isPausable = snapshot.hasData ? snapshot.data : true;

                      if (isPausable) {
                        return IconButton(
                          onPressed: () {
                            Provider.of<QueueBloc>(context).setPausable(false);
                          },
                          icon: Icon(Icons.pause, color: Colors.white),
                        );
                      } else {
                        return IconButton(
                          onPressed: () {
                            Provider.of<QueueBloc>(context).setPausable(true);
                          },
                          icon: Icon(Icons.play_arrow, color: Colors.white),
                        );
                      }
                    },
                  ),
                ],
              );
            }
          },
        );
      },
    );
  }

  Widget _buildFindService() {
    return FlatButton(
      child: Text("Find Service"),
      onPressed: _findTecoService,
    );

  }
}
