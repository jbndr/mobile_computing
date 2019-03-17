import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_computing/game/game_data.dart';
import 'package:mobile_computing/logic/queue_logic.dart';
import 'package:mobile_computing/model/morse_character.dart';
import 'package:mobile_computing/ui/answer_button.dart';
import 'package:pimp_my_button/pimp_my_button.dart';

class Game extends StatefulWidget {
  final QueueBloc queueBloc;

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

  bool currentlyPlaying;

  StreamSubscription subscription;

  @override
  void initState() {
    super.initState();
    currentGame = GameData();
    points = 0;
    currentlyPlaying = widget.queueBloc.currentlyPlaying;
    print("CURRENTLY_PLAYING BEFORE START: " + currentlyPlaying.toString());
    widget.queueBloc.setPausable(false);
    widget.queueBloc.playCharacter(currentGame.solution);
    currentlyPlaying = widget.queueBloc.currentlyPlaying;
    print("CURRENTLY_PLAYING AFTER START: " + currentlyPlaying.toString());
  }

  @override

  void didChangeDependencies() {
    super.didChangeDependencies();
    subscription = widget.queueBloc.currentlyPlayingStream.listen((it) {
      setState(() {
        currentlyPlaying = it;
      });
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  void checkResult(
      MorseCharacter character, AnimationController controller) async {
    selectedCharacter = character;

    setState(() {
      if (!currentGame.checkSolution(character)) {
        points = points == 0 ? 0 : points - 1;
      } else {
        points++;
        controller.forward(from: 0.0);
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
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: currentlyPlaying ? null : () {
          widget.queueBloc.playCharacter(currentGame.solution);
        },
        child: Icon(Icons.refresh),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Points: " + points.toString(),
                  style:
                      TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Text("Which character was sent?",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0)),
              SizedBox(height: 50),
            ]..addAll([0, 1, 2, 3].map(_getAnswerButton).toList())),
      ),
    );
  }

  Widget _getAnswerButton(int index) {
    MorseCharacter character = currentGame.getPossibleSolutions()[index];
    return PimpedButton(
      particle: RectangleDemoParticle(),
      pimpedWidgetBuilder: (context, controller) {
        return AnswerButton(
          answer: character.character,
          isCorrect: showAnswers ? showIsCorrect(character) : null,
          isClickable: currentlyPlaying,
          onPressed: showAnswers || currentlyPlaying
              ? null
              : () {
                  checkResult(character, controller);
                },
        );
      },
    );
  }

  bool showIsCorrect(MorseCharacter character) {
    bool isCorrect = currentGame.checkSolution(character);

    if (!isCorrect) {
      if (selectedCharacter == character) {
        return false;
      } else {
        return null;
      }
    } else {
      return true;
    }
  }
}
