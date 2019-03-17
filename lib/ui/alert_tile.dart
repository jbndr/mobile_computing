import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class AlertTile extends StatelessWidget {

  final Stream<BluetoothState> bluetoothStateStream;

  const AlertTile({Key key, this.bluetoothStateStream}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BluetoothState>(
      stream: bluetoothStateStream,
      builder: (context, snapshot){
        if (!snapshot.hasData){
          return SizedBox();
        }

        BluetoothState state = snapshot.requireData;
        return new Container(
          color: state == BluetoothState.off
              ? Colors.red
              : ((state == BluetoothState.turningOn)
              ? Colors.green
              : Colors.transparent),
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
      },
    );
  }

}
