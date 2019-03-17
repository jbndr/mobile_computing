import 'package:flutter/material.dart';

class AnswerButton extends StatelessWidget {

  final String answer;
  final VoidCallback onPressed;
  final bool isCorrect;

  AnswerButton({this.answer, this.onPressed, this.isCorrect});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isCorrect == null ? Colors.white : isCorrect ? Colors.teal : Colors.pink,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      margin: const EdgeInsets.only(top: 15),
      width: 300,
      height: 75,
      child: FlatButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(answer, style: TextStyle(fontSize: 22.0, color: Colors.black)),
          ],
        ),
        onPressed: onPressed,
      ),
    );
  }
}