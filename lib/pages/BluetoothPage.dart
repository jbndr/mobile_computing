import 'package:flutter/material.dart';

class BluetoothPage extends StatelessWidget {
  BluetoothPage({this.isScanning, this.tiles});

  final bool isScanning;
  final List<Widget> tiles;

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        isScanning ? _buildProgressBar() : SizedBox(),
        new ListView.separated(
          itemCount: tiles.length,
          separatorBuilder: (context, index) => Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
                child: Divider(),
              ),
          itemBuilder: (context, index) => tiles[index],
        )
      ],
    );
  }

  @override
  String toStringShort() {
    return "Bluetooth";
  }

  Widget _buildProgressBar() {
    return LinearProgressIndicator(
      backgroundColor: Colors.tealAccent,
    );
  }
}
