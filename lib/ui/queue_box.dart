import 'package:flutter/material.dart';

class QueueBox extends StatelessWidget {
  final String character;
  final bool isCurrent;

  QueueBox({this.character, this.isCurrent});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 0, horizontal: 5.0),
        color: isCurrent ? Colors.indigoAccent : Colors.black,
        height: 50.0,
        width: 50.0,
        child: Center(
            child: Text(
          character,
          style: TextStyle(color: Colors.white),
        )));
  }
}
