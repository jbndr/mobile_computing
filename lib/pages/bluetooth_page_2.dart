import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:mobile_computing/model/bluetooth.dart';
import 'package:mobile_computing/ui/tiles.dart';

class BluetoothPage extends StatefulWidget {
  BluetoothPage({this.bluetooth, this.onConnect});

  final Bluetooth bluetooth;
  final ValueChanged<Bluetooth> onConnect;

  @override
  _BluetoothPageState createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {
  FlutterBlue flutterBlue = FlutterBlue.instance;

  BluetoothDevice bluetoothDevice;
  BluetoothState bluetoothState;
  BluetoothDeviceState bluetoothDeviceState;

  bool isScanning = false;

  bool get isConnecting => bluetoothDevice != null;
  bool get isConnected =>
      bluetoothDeviceState == BluetoothDeviceState.connected;
  bool get isBluetoothOn => bluetoothState == BluetoothState.on;

  StreamSubscription<BluetoothState> _stateSubscription;
  StreamSubscription<ScanResult> _scanSubscription;
  StreamSubscription<BluetoothDeviceState> _deviceConnection;
  //StreamSubscription<BluetoothDeviceState> _deviceStateSubscription;
  Map<DeviceIdentifier, ScanResult> scanResults;

  @override
  void initState() {
    super.initState();
    scanResults = new Map();
    bluetoothDeviceState = BluetoothDeviceState.disconnected;
    bluetoothState = BluetoothState.unknown;

    flutterBlue.state.then((s) {
      setState(() {
        bluetoothState = s;
      });
    });

    _stateSubscription = flutterBlue.onStateChanged().listen((s) {
      if (s == BluetoothState.turningOff) {
        print("BLUETOOTH GEHT GERADE AUS");
        _deviceConnection?.cancel();
        _scanSubscription.cancel();
        setState(() {
          bluetoothDeviceState = BluetoothDeviceState.disconnected;
         // bluetoothDevice = null;
        });
      } else if (s == BluetoothState.on) {
        print("DEVICE");
        print(bluetoothDevice);
        if (bluetoothDevice != null) {
          print("BLUETOOTH_DEVICE");
          print(bluetoothDevice);
         _connect(bluetoothDevice);
        }
      }
      setState(() {
        bluetoothState = s;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _deviceConnection?.cancel();
    _scanSubscription?.cancel();
    _stateSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildAppBar(),
        isScanning ? _buildLoadingBar() : SizedBox(),
        _buildAlertTile(),
        !isConnecting ? _buildScanResultTiles() : _buildDeviceResultTile()
      ],
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text("Blueooth"),
      actions: <Widget>[
        (isConnected || isConnecting)
            ? _buildDisconnectButton()
            : _buildScanningButton()
      ],
    );
  }

  Widget _buildScanningButton() {
    TextStyle style = TextStyle(color: Colors.white);

    if (isBluetoothOn) {
      if (isScanning) {
        return FlatButton(
          onPressed: _toggleScan,
          child: Text("STOP SCANNING", style: style),
        );
      } else {
        return FlatButton(
          onPressed: _toggleScan,
          child: Text("SCAN", style: style),
        );
      }
    } else {
      return SizedBox();
    }
  }

  Widget _buildDisconnectButton() {
    return FlatButton(
      onPressed: _disconnect,
      child: Text("DISCONNECT", style: TextStyle(color: Colors.white)),
    );
  }

  void _disconnect() {
    _deviceConnection?.cancel();
    //_deviceStateSubscription?.cancel();
    setState(() {
      bluetoothDeviceState = BluetoothDeviceState.disconnected;
      bluetoothDevice = null;
    });
  }

  void _toggleScan() {
    if (isScanning) {
      _scanSubscription.cancel();
    } else {
      scanResults = new Map();

      _scanSubscription = flutterBlue
          .scan(timeout: const Duration(seconds: 5))
          .listen((scanResult) {
        setState(() {
          scanResults[scanResult.device.id] = scanResult;
        });
      }, onDone: () {
        _scanSubscription.cancel();
        setState(() {
          isScanning = !isScanning;
          scanResults = scanResults;
        });
      });
    }

    setState(() {
      isScanning = !isScanning;
    });
  }

  void _connect(BluetoothDevice device) {

    print(scanResults);
    print("DEVICE!!!!!");
    print(device);

    setState(() {
      bluetoothDevice = device;
    });

    print("DEVICE CONNECT STREAM");
    print(_deviceConnection);


    _deviceConnection =
        flutterBlue.connect(device, timeout: const Duration(seconds: 6), autoConnect: false).listen(
          (state){
            setState(() {
        bluetoothDeviceState = state;
      });
            if (state == BluetoothDeviceState.connected){
              print("!!!!!!!!!CONNECTED!!!!!!!!!!!!!");
            }
          },
              onDone: _disconnect,
            );

//    device.state.then((state) {
//      print("STATE 1");
//      print(state);
//
//      setState(() {
//        bluetoothDevice = device;
//        bluetoothDeviceState = state;
//      });
//    });
//
//    _deviceStateSubscription = device.onStateChanged().listen((state) {
//      print("STATE 2");
//      print(state);
//      setState(() {
//        bluetoothDeviceState = state;
//      });
//      if (state == BluetoothDeviceState.connected) {
//        print("!!!!!!!!NOW CONNECT TO SERVICE!!!!!!!");
////          device.discoverServices().then((s) {
////            setState(() {
////              services = s;
////              _findTecoService();
////            });
////          });
//      }
//    });
  }

  Widget _buildScanResultTiles() {
    return Expanded(
      child: ListView(
        children: scanResults.values
            .map((r) => ScanResultTile(
                  result: r,
                  onTap: () => _connect(r.device),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildLoadingBar() {
    return LinearProgressIndicator(backgroundColor: Colors.indigoAccent);
  }

  Widget _buildDeviceResultTile() {
    return new ListTile(
        leading: isConnected
            ? const Icon(Icons.bluetooth_connected)
            : const Icon(Icons.bluetooth_disabled),
        title: new Text(
            'Device is ${bluetoothDeviceState.toString().split(".")[1]}.'),
        subtitle: new Text('${bluetoothDevice.id}'),
        trailing: new IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () => _refreshDeviceState(bluetoothDevice),
          color: Theme.of(context).iconTheme.color.withOpacity(0.5),
        ));
  }

  Future _refreshDeviceState(BluetoothDevice device) async {
    var state = await device.state;
    setState(() {
      bluetoothDeviceState = state;
    });
  }

  Widget _buildAlertTile() {
    if (bluetoothState != BluetoothState.off &&
        bluetoothState != BluetoothState.turningOn) {
      return SizedBox();
    }

    return Container(
      color: bluetoothState == BluetoothState.off
          ? Colors.red
          : ((bluetoothState == BluetoothState.turningOn)
              ? Colors.green
              : Colors.transparent),
      child: new ListTile(
        title: new Text(
          'Bluetooth adapter is ${bluetoothState.toString().substring(15)}',
          style: Theme.of(context).primaryTextTheme.subhead,
        ),
        trailing: new Icon(
          Icons.error,
          color: Theme.of(context).primaryTextTheme.subhead.color,
        ),
      ),
    );
  }
}
