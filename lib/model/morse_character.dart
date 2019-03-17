import 'package:mobile_computing/model/morse_symbol.dart';

class MorseCharacter {
  final String character;
  final List<MorseSymbol> code;

  MorseCharacter({this.character, this.code});


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is MorseCharacter &&
              runtimeType == other.runtimeType &&
              character == other.character;

  @override
  int get hashCode => character.hashCode;

  String getCode() {
    String codeString = "";
    for (MorseSymbol s in code) {
      codeString += s.symbol;
    }

    return codeString;
  }

  @override
  String toString() => character;
}
