import 'package:flutter/material.dart';

class CharacterBox extends StatelessWidget {
  final String character;

  CharacterBox({this.character});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 0, horizontal: 5.0),
        color: Colors.black,
        height: 50.0,
        width: 50.0,
        child: Center(
            child: Text(
              character,
              style: TextStyle(color: Colors.white),
            )));
  }
}
