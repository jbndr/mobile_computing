import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:mobile_computing/model/morse_character.dart';
import 'package:mobile_computing/model/morse_symbol.dart';
import 'package:mobile_computing/ui/character_box.dart';
import 'package:mobile_computing/ui/symbol_box.dart';

class ScanResultTile extends StatelessWidget {
  const ScanResultTile({Key key, this.result, this.onTap}) : super(key: key);

  final ScanResult result;
  final VoidCallback onTap;

  Widget _buildTitle(BuildContext context) {
    String btType = result.device.type == BluetoothDeviceType.le ? "BLE" : "UNKOWN";

    if (result.device.name.length > 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            result.device.name,
            style: TextStyle(fontWeight: FontWeight.bold, color: result.device.name == "TECO Wearable 4" ? Colors.indigoAccent : Colors.black),
          ),
          Text(
            result.device.id.toString(),
            style: Theme.of(context).textTheme.caption,
          ),
          Row(
            children: <Widget>[
              Icon(Icons.bluetooth, size: 12.0),
              SizedBox(width: 5.0),
              Text(btType, style: Theme.of(context).textTheme.caption),
              SizedBox(width: 20.0),
              Icon(Icons.signal_cellular_4_bar, size: 12.0),
              SizedBox(width: 5.0),
              Text(result.rssi.toString() + " dBm", style: Theme.of(context).textTheme.caption),
            ]),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "N/A",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            result.device.id.toString(),
            style: Theme.of(context).textTheme.caption,
          ),
          Row(
              children: <Widget>[
                Icon(Icons.bluetooth, size: 12.0),
                SizedBox(width: 5.0),
                Text(btType, style: Theme.of(context).textTheme.caption),
                SizedBox(width: 20.0),
                Icon(Icons.signal_cellular_4_bar, size: 12.0),
                SizedBox(width: 5.0),
                Text(result.rssi.toString() + " dBm", style: Theme.of(context).textTheme.caption),
              ]),

        ],
      );
    }
  }

  String getNiceHexArray(List<int> bytes) {
    return '[${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(', ')}]'
        .toUpperCase();
  }

  String getNiceManufacturerData(Map<int, List<int>> data) {
    if (data.isEmpty) {
      return null;
    }
    List<String> res = [];
    data.forEach((id, bytes) {
      res.add(
          '${id.toRadixString(16).toUpperCase()}: ${getNiceHexArray(bytes)}');
    });
    return res.join(', ');
  }

  String getNiceServiceData(Map<String, List<int>> data) {
    if (data.isEmpty) {
      return null;
    }
    List<String> res = [];
    data.forEach((id, bytes) {
      res.add('${id.toUpperCase()}: ${getNiceHexArray(bytes)}');
    });
    return res.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: _buildTitle(context),
        trailing: RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 0.0, horizontal: 14.0),
            child: Text(
              'CONNECT',
              style: TextStyle(fontSize: 12.0),
            ),
          ),
          color: Colors.indigoAccent,
          textColor: Colors.white,
          onPressed: (result.advertisementData.connectable) ? onTap : null,
        ));
  }
}

class BasicTile extends StatelessWidget {
  final VoidCallback onTap;
  final MorseCharacter morseCharacter;
  final bool isConnected;
  final bool didFindService;

  BasicTile({this.onTap, this.morseCharacter, this.isConnected, this.didFindService});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: CharacterBox(character: morseCharacter.character),
        title: _buildSymbolWidget(morseCharacter.code),
        trailing: isConnected
            ? RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3.0)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 0.0, horizontal: 20.0),
                  child: Text(
                    'SEND',
                    style: TextStyle(fontSize: 12.0),
                  ),
                ),
                color: Colors.indigoAccent,
                textColor: Colors.white,
                onPressed: didFindService ? onTap : null,
              )
            : null);
  }

  Widget _buildSymbolWidget(List<MorseSymbol> symbol) {
    List<SymbolBox> symbolWidgets = new List<SymbolBox>();

    symbol.forEach((morseSymbol) {
      symbolWidgets.add(SymbolBox(symbol: morseSymbol.symbol));
    });

    return Row(children: symbolWidgets);
  }
}
