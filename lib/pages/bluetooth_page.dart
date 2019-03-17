//import 'dart:async';
//
//import 'package:flutter/material.dart';
//import 'package:flutter_blue/flutter_blue.dart';
//import 'package:mobile_computing/model/bluetooth.dart';
//import 'package:mobile_computing/ui/tiles.dart';
//
//class BluetoothPage extends StatefulWidget {
//  BluetoothPage({this.bluetooth, this.onConnect});
//
//  final Bluetooth bluetooth;
//  final ValueChanged<Bluetooth> onConnect;
//
//  @override
//  BluetoothPageState createState() {
//    return new BluetoothPageState();
//  }
//}
//
//class BluetoothPageState extends State<BluetoothPage> {
//  FlutterBlue flutterBlue = FlutterBlue.instance;
//
//  /// Scanning
//  StreamSubscription _scanSubscription;
//  Map<DeviceIdentifier, ScanResult> scanResults = new Map();
//  bool isScanning = false;
//
//  /// State
//  StreamSubscription _stateSubscription;
//  //TODO
//  BluetoothState state = BluetoothState.unknown;
//
//  /// Device
//  BluetoothDevice device;
//  bool get isConnecting => (device != null);
//  StreamSubscription deviceConnection;
//  StreamSubscription deviceStateSubscription;
//  List<BluetoothService> services = new List();
//  Map<Guid, StreamSubscription> valueChangedSubscriptions = {};
//  BluetoothDeviceState deviceState = BluetoothDeviceState.disconnected;
//
//  /// Service
//  BluetoothCharacteristic tecoCharacteristic;
//
//  /// Characteristic
//  BluetoothService tecoService;
//
//
//  @override
//  Widget build(BuildContext context) {
//    return SizedBox();
//  } //  void _stopScan() {
////    _scanSubscription?.cancel();
////    _scanSubscription = null;
////    setState(() {
////      isScanning = false;
////    });
////  }
//
//  @override
//  void initState() {
//    super.initState();
//    tecoCharacteristic = widget.bluetooth?.characteristic;
//    tecoService = widget.bluetooth?.service;
//    device = widget.bluetooth?.device;
//    widget.bluetooth?.device?.state?.then((state){
//      deviceState = state;
//    });
//
//    flutterBlue.state.then((s) {
//      setState(() {
//        state = s;
//      });
//    });
//    _stateSubscription = flutterBlue.onStateChanged().listen((s) {
//      setState(() {
//        state = s;
//      });
//    });
//  }
//
////  _refreshDeviceState(BluetoothDevice d) async {
////    var state = await d.state;
////    setState(() {
////      deviceState = state;
////      print('State refreshed: $deviceState');
////    });
////  }
//
////  @override
////  Widget build(BuildContext context) {
////    var tiles = new List<Widget>();
////
////    if (state == BluetoothState.off || state == BluetoothState.turningOn) tiles.add(_buildAlertTile());
////    if (isConnecting) {
////      print("IS CONNECTING");
////      tiles.add(_buildDeviceStateTile());
////    } else {
////      print("IS NOT CONNECTING");
////      tiles.addAll(_buildScanResultTiles());
////    }
////
////    return Column(
////      children: <Widget>[
////        _buildAppBar(),
////        Expanded(
////          child: Stack(
////            children: <Widget>[
////              isScanning ? LinearProgressIndicator(backgroundColor: Colors.indigoAccent,) : SizedBox(),
////              ListView.separated(
////                itemCount: tiles.length,
////                separatorBuilder: (context, index) => Padding(
////                      padding:
////                          EdgeInsets.all(5),
////                      child: Divider(),
////                    ),
////                itemBuilder: (context, index) => tiles[index],
////              )
////            ],
////          ),
////        ),
////      ],
////    );
////  }
//
////  Widget _buildAlertTile() {
////    return new Container(
////      color: state == BluetoothState.off
////          ? Colors.red
////          : ((state == BluetoothState.turningOn)
////              ? Colors.green
////              : Colors.transparent),
////      child: new ListTile(
////        title: new Text(
////          'Bluetooth adapter is ${state.toString().substring(15)}',
////          style: Theme.of(context).primaryTextTheme.subhead,
////        ),
////        trailing: new Icon(
////          Icons.error,
////          color: Theme.of(context).primaryTextTheme.subhead.color,
////        ),
////      ),
////    );
////  }
//
////  Widget _buildDeviceStateTile() {
////    return new ListTile(
////        leading: (deviceState == BluetoothDeviceState.connected)
////            ? const Icon(Icons.bluetooth_connected)
////            : const Icon(Icons.bluetooth_disabled),
////        title: new Text('Device is ${deviceState.toString().split('.')[1]}.'),
////        subtitle: new Text('${device.id}'),
////        trailing: new IconButton(
////          icon: const Icon(Icons.refresh),
////          onPressed: () => _refreshDeviceState(device),
////          color: Theme.of(context).iconTheme.color.withOpacity(0.5),
////        ));
////  }
//
////  List<Widget> _buildScanResultTiles() {
////    return scanResults.values
////        .map((r) => ScanResultTile(
////              result: r,
////              onTap: () => _connect(r.device),
////            ))
////        .toList();
////  }
//
////  Widget _buildScanningButton() {
////    TextStyle style = TextStyle(color: Colors.white);
////
////    if (state != BluetoothState.on) {
////      return SizedBox();
////    }
////
////    if (isConnecting) {
////      return FlatButton(
////        onPressed: _disconnect,
////        child: Text("DISCONNECT", style: style),
////      );
////    }
////    if (isScanning) {
////      return FlatButton(
////        onPressed: _stopScan,
////        child: Text("STOP SCANNING", style: style),
////      );
////    } else {
////      return FlatButton(
////        onPressed: _startScan,
////        child: Text("SCAN", style: style),
////      );
////    }
////  }
//
//  Future _findTecoService() async {
//    var foundService;
//
//    services.forEach((service) {
//      if (service.uuid.toString() == "713d0000-503e-4c75-ba94-3148f18d941e") {
//        foundService = service;
//      }
//    });
//
//    var characteristics = foundService.characteristics;
//    var foundCharacteristic;
//
//    for (BluetoothCharacteristic c in characteristics) {
//      if (c.uuid.toString() == "713d0003-503e-4c75-ba94-3148f18d941e") {
//        foundCharacteristic = c;
//      }
//    }
//
//    tecoService = foundService;
//    tecoCharacteristic = foundCharacteristic;
//    widget.onConnect(Bluetooth(device, tecoService, tecoCharacteristic, deviceConnection));
//  }
//
//  void _connect(BluetoothDevice d) async {
//    device = d;
//    // Connect to device
//    deviceConnection =
//        flutterBlue.connect(device, timeout: const Duration(seconds: 4)).listen(
//              null,
//              onDone: _disconnect,
//            );
//
//    print("MOUNTED1: " + mounted.toString());
//    // Update the connection state immediately
//    device.state.then((s) {
//      setState(() {
//        deviceState = s;
//      });
//    });
//    print("MOUNTED2: " + mounted.toString());
//
//    // Subscribe to connection changes
//    deviceStateSubscription = device.onStateChanged().listen((s) {
//
//      print("MOUNTED3: " + mounted.toString());
//      print(deviceState);
//      setState(() {
//        deviceState = s;
//      });
//      if (s == BluetoothDeviceState.connected) {
//        device.discoverServices().then((s) {
//          setState(() {
//            services = s;
//            _findTecoService();
//          });
//        });
//      }
//    });
////  }
//
//  _disconnect() {
//    print("DISONNECTING");
//    valueChangedSubscriptions.forEach((uuid, sub) => sub.cancel());
//    valueChangedSubscriptions.clear();
//    deviceStateSubscription?.cancel();
//    deviceStateSubscription = null;
//    setState(() {
//      widget.bluetooth?.dispose();
//      widget.onConnect(Bluetooth.disconnect(null, null, null));
//      device = null;
//      deviceState = BluetoothDeviceState.disconnected;
//      tecoService = null;
//      tecoCharacteristic = null;
//    });
//  }
//
////  void _startScan() {
////    scanResults = new Map();
////    _scanSubscription = flutterBlue
////        .scan(timeout: const Duration(seconds: 5))
////        .listen((scanResult) {
////      print('localName: ${scanResult.advertisementData.localName}');
////      print(
////          'manufacturerData: ${scanResult.advertisementData.manufacturerData}');
////      print('serviceData: ${scanResult.advertisementData.serviceData}');
////      setState(() {
////        scanResults[scanResult.device.id] = scanResult;
////      });
////    }, onDone: _stopScan);
////
////    setState(() {
////      isScanning = true;
////    });
////  }
//
//// Widget _buildAppBar() {
////    return AppBar(
////      title: Text("Bluetooth"),
////      actions: <Widget>[
////        _buildScanningButton()
////      ],
////    );
//// }
//
//}
