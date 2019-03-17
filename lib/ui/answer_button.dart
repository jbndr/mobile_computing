import 'package:flutter/material.dart';

class AnswerButton extends StatelessWidget {

  final String answer;
  final VoidCallback onPressed;
  final bool isCorrect;
  final bool isClickable;

  AnswerButton({this.answer, this.onPressed, this.isCorrect, this.isClickable});

  @override
  Widget build(BuildContext context) {

    Color showAnswer = isCorrect == null ? Colors.white : isCorrect ? Colors.teal : Colors.pink;
    Color color = !isClickable ? showAnswer : Colors.grey[200];

    return Container(
      decoration: BoxDecoration(
        color: color,
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