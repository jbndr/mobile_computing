import 'package:flutter/material.dart';

class HomeBox extends StatelessWidget {

  final String title;
  final Color color;

  HomeBox({this.title, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
          border: Border.all(color: color, width: 3),
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      width: 300,
      height: 100,
      child: FlatButton(
        child: Text(title),
        onPressed: (){},
      ),
    );
  }
}
