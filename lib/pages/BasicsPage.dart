import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:mobile_computing/logic/queue_logic.dart';
import 'package:mobile_computing/model/MorseCharacter.dart';
import 'package:mobile_computing/widgets/character_box.dart';
import 'package:mobile_computing/widgets/tiles.dart';
import 'package:provider/provider.dart';

class BasicsPage extends StatefulWidget {
  final BluetoothCharacteristic characteristic;
  final BluetoothDevice device;

  BasicsPage({this.characteristic, this.device});

  @override
  BasicsPageState createState() {
    return new BasicsPageState();
  }
}

class BasicsPageState extends State<BasicsPage> {
  QueueBloc queueBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    queueBloc = Provider.of<QueueBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            StreamBuilder<Queue<MorseCharacter>>(
              stream: queueBloc.queueStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.requireData.length == 0)
                  return SizedBox(height: 50,);
                Queue queue = snapshot.requireData;
                return Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                    height: 50.0,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: queue.length,
                        itemBuilder: (context, index) {
                          return CharacterBox(
                              character: queue.elementAt(index).toString(),
                              isCurrent: index == 0);
                        }));
              },
            ),
            Expanded(child: _buildList(context)),
          ],
        ),
      ),
    );
  }

  ListView _buildList(context) {
    return ListView.builder(
      itemCount: QueueBloc.morseCharacters.length,
      itemBuilder: (context, index) {
        return BasicTile(
            isConnected: (widget.device != null),
            morseCharacter: QueueBloc.morseCharacters[index],
            onTap: () => queueBloc.playMorseCharacter(index));
      },
    );
  }

  @override
  String toStringShort() {
    return "Basics";
  }
}
