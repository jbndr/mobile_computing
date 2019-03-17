import 'dart:math';

import 'package:mobile_computing/model/morse_character.dart';
import 'package:mobile_computing/model/morse_symbol.dart';

class GameData{
  static final List<MorseCharacter> morseCharacters = [
    MorseCharacter(character: "A", code: [Dit(), Dah()]),
    MorseCharacter(character: "B", code: [Dah(), Dit(), Dit(), Dit()]),
    MorseCharacter(character: "C", code: [Dah(), Dit(), Dah(), Dit()]),
    MorseCharacter(character: "D", code: [Dah(), Dit(), Dit()]),
    MorseCharacter(character: "E", code: [Dit()]),
    MorseCharacter(character: "F", code: [Dit(), Dit(), Dah(), Dit()]),
    MorseCharacter(character: "G", code: [Dah(), Dah(), Dit()]),
    MorseCharacter(character: "H", code: [Dit(), Dit(), Dit(), Dit()]),
    MorseCharacter(character: "I", code: [Dit(), Dit()]),
    MorseCharacter(character: "J", code: [Dit(), Dah(), Dah(), Dah()]),
    MorseCharacter(character: "K", code: [Dah(), Dit(), Dah()]),
    MorseCharacter(character: "L", code: [Dit(), Dah(), Dit(), Dit()]),
    MorseCharacter(character: "M", code: [Dah(), Dit()]),
    MorseCharacter(character: "N", code: [Dit(), Dah()]),
    MorseCharacter(character: "O", code: [Dah(), Dah(), Dah()]),
    MorseCharacter(character: "P", code: [Dit(), Dah(), Dah(), Dit()]),
    MorseCharacter(character: "Q", code: [Dah(), Dah(), Dit(), Dah()]),
    MorseCharacter(character: "R", code: [Dit(), Dah(), Dit()]),
    MorseCharacter(character: "S", code: [Dit(), Dit(), Dit()]),
    MorseCharacter(character: "T", code: [Dah()]),
    MorseCharacter(character: "U", code: [Dit(), Dit(), Dah()]),
    MorseCharacter(character: "V", code: [Dit(), Dit(), Dit(), Dah()]),
    MorseCharacter(character: "W", code: [Dit(), Dah(), Dah()]),
    MorseCharacter(character: "X", code: [Dah(), Dit(), Dit(), Dah()]),
    MorseCharacter(character: "Y", code: [Dah(), Dit(), Dah(), Dah()]),
    MorseCharacter(character: "Z", code: [Dah(), Dah(), Dit(), Dit()]),
    MorseCharacter(character: "Ä", code: [Dit(), Dah(), Dit(), Dah()]),
    MorseCharacter(character: "Ö", code: [Dah(), Dah(), Dah(), Dit()]),
    MorseCharacter(character: "Ü", code: [Dit(), Dit(), Dah(), Dah()]),
  ];

  factory GameData() {
    List<MorseCharacter> solutions = _getRandom();
    MorseCharacter right = solutions[0];
    return GameData._(solutions..shuffle(), right);

  }

  GameData._(this._possible, this.solution);

  final List<MorseCharacter> _possible;
  final MorseCharacter solution;

  List<MorseCharacter> getPossibleSolutions() {
    return _possible;
  }

  bool checkSolution(MorseCharacter proposal) => solution == proposal;

  static List<MorseCharacter> _getRandom() {
    List<int> indexList = List();

    var rng = new Random();
    int index;
    while(indexList.length != 4){
      index = rng.nextInt(morseCharacters.length);
      if (!indexList.contains(index)){
        indexList.add(index);
      }
    }

    return [morseCharacters[indexList[0]], morseCharacters[indexList[1]], morseCharacters[indexList[2]], morseCharacters[indexList[3]]];
  }
}