import 'package:flutter/material.dart';
import 'package:mobile_computing/logic/queue_logic.dart';
import 'package:mobile_computing/model/bluetooth.dart';
import 'package:mobile_computing/pages/bluetooth_page.dart';
import 'package:mobile_computing/pages/home_page.dart';
import 'package:mobile_computing/pages/basics_page.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyTopApp());

class MyTopApp extends StatefulWidget {
  @override
  _MyTopAppState createState() => _MyTopAppState();
}

class _MyTopAppState extends State<MyTopApp> {

  Bluetooth bluetooth;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Mobile Computing App",
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: Provider(
        value: QueueBloc(
          characteristic: bluetooth?.characteristic,
          device: bluetooth?.device,
          service: bluetooth?.service,
        ),
        child: MyApp(
          bluetooth: bluetooth,
          onConnect: (_bluetooth) {
            setState(() {
              bluetooth = _bluetooth;
            });
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    bluetooth.dispose();
    super.dispose();
  }
}

class MyApp extends StatefulWidget {

  const MyApp({Key key, this.bluetooth, this.onConnect}) : super(key: key);

  final Bluetooth bluetooth;
  final ValueChanged<Bluetooth> onConnect;

  @override
  State createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: () {
        if(_selectedTab == 0) return HomePage();
        if(_selectedTab == 1) return BasicPage();
        if(_selectedTab == 2) return BluetoothPage(
          bluetooth: widget.bluetooth,
          onConnect: widget.onConnect
        );
      }(),
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
    );
  }
}
