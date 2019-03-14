import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:mobile_computing/model/MorseCharacter.dart';
import 'package:mobile_computing/model/MorseSymbol.dart';
import 'package:mobile_computing/widgets/character_box.dart';
import 'package:mobile_computing/widgets/symbol_box.dart';

class ScanResultTile extends StatelessWidget {
  const ScanResultTile({Key key, this.result, this.onTap}) : super(key: key);

  final ScanResult result;
  final VoidCallback onTap;

  Widget _buildTitle(BuildContext context) {
    if (result.device.name.length > 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            result.device.name,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            result.device.id.toString(),
            style: Theme.of(context).textTheme.caption,
          )
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
          )
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
        title: _buildTitle(context),
        leading: Text(result.rssi.toString() + " dBm"),
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

  BasicTile({this.onTap, this.morseCharacter, this.isConnected});

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
                onPressed: onTap,
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
