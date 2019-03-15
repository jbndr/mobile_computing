import 'package:flutter/material.dart';

class SymbolBox extends StatelessWidget {
  final String symbol;

  SymbolBox({this.symbol});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 0, horizontal: 2.0),
        color: symbol == "-" ? Colors.grey: Colors.indigo,
        height: 30.0,
        width: 30.0,
        child: Center(
            child: Text(
          symbol,
          style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
        )));
  }
}
