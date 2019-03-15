abstract class MorseSymbol {
  final String symbol;
  final int duration;

  MorseSymbol(this.symbol, this.duration);
}

class Dit extends MorseSymbol {
  Dit() : super("·", 100);
}

class Dah extends MorseSymbol {
  Dah() : super("-", 500);
}
