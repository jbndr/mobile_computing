import 'package:flutter/material.dart';
import 'package:mobile_computing/game/game_data.dart';
import 'package:mobile_computing/model/morse_character.dart';
import 'package:mobile_computing/ui/answer_button.dart';

class Game extends StatefulWidget {
  final queueBloc;

  Game(this.queueBloc);

  @override
  GameState createState() {
    return new GameState();
  }
}

class GameState extends State<Game> {
  GameData currentGame;
  int points;

  MorseCharacter selectedCharacter;

  bool showAnswers = false;

  @override
  void initState() {
    super.initState();
    currentGame = GameData();
    points = 0;
    widget.queueBloc.setPausable(false);
    widget.queueBloc.playCharacter(currentGame.solution);
  }


  void checkResult(MorseCharacter character) async {

    selectedCharacter = character;

    setState(() {
      if (!currentGame.checkSolution(character)){
        points = points == 0 ? 0 : points-1;
      } else {
        points++;
      }
      showAnswers = true;
    });

    await Future.delayed(Duration(milliseconds: 2000));

    setState(() {
      showAnswers = false;
      currentGame = GameData();
      widget.queueBloc.playCharacter(currentGame.solution);
    });

    selectedCharacter = null;

  }

  @override
  Widget build(BuildContext context) {
    print("SOLUTION: " + currentGame.solution.character);
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Points: " + points.toString(), style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          Text("Which character was sent?",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0)),
          SizedBox(height: 50),
        ]..addAll([0,1,2,3].map(_getAnswerButton).toList()));
  }

  Widget _getAnswerButton(int index) {
    MorseCharacter character = currentGame.getPossibleSolutions()[index];

    return AnswerButton(
      answer: character.character,
      isCorrect: showAnswers ? showIsCorrect(character) : null,
      onPressed: showAnswers ? null : () {
        checkResult(character);
      },
    );
  }

  bool showIsCorrect(MorseCharacter character) {
    bool isCorrect = currentGame.checkSolution(character);

    if(!isCorrect) {
      if(selectedCharacter == character) {
        return false;
      } else {
        return null;
      }
    } else {
      return true;
    }
  }

}
