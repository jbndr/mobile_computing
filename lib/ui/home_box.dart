import 'package:flutter/material.dart';

class HomeBox extends StatelessWidget {
  final String title;
  final Color color;
  final Widget widget;

  HomeBox({this.title, this.color, this.widget});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      width: 300,
      height: 100,
      child: FlatButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(width: 20),
            Text(title, style: TextStyle(fontSize: 22.0, color: Colors.white)),
            Icon(Icons.navigate_next, color: Colors.white, size: 35)
          ],
        ),
        onPressed: () => _navigate(context, widget),
      ),
    );
  }

  void _navigate(context, widget) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: _buildAppBar(context),
        body: widget,
      );
    }));
  }

  Widget _buildAppBar(context) {
    return AppBar(
      title: Text("Encode"),
      leading: FlatButton(
        child: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
