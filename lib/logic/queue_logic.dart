import 'dart:async';
import 'dart:collection';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:mobile_computing/model/MorseCharacter.dart';
import 'package:mobile_computing/model/MorseSymbol.dart';

class QueueBloc {

  QueueBloc(this.device, this.characteristic);

  final StreamController<bool> _pausableController = StreamController.broadcast();
  Stream<bool> get pausableStream => _pausableController.stream;

  final StreamController<Queue<MorseCharacter>> _queueController =
      StreamController.broadcast();
  Stream<Queue<MorseCharacter>> get queueStream => _queueController.stream;

  final BluetoothCharacteristic characteristic;
  final BluetoothDevice device;

  final Queue<MorseCharacter> queue = Queue();

  bool currentlyPlaying = false;
  bool _isPaused = false;

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

  void setPausable(bool isPausable) {
    _pausableController.add(isPausable);
    _isPaused = !isPausable;

    if (!_isPaused) playNextCharacterFromQueue();
  }

  void playNextCharacterFromQueue() async {

    if (queue.isNotEmpty && !_isPaused) {
      currentlyPlaying = true;
      var morse = queue.first;
      var motorIndex = 0;
      var motors = [
        [0x00, 0x00, 0x00, 0xFF],
        [0x00, 0x00, 0xFF, 0x00],
        [0x00, 0xFF, 0x00, 0x00],
        [0xFF, 0x00, 0x00, 0x00]
      ];

      for (MorseSymbol symbol in morse.code) {
        print("DEVICE: " + device.toString());
        print("DEVICE_STATE: " + device.state.toString());

        print(device == null ? "DEVICE is NULL" : "DEVICE is NOT NULL");
        print(characteristic == null ? "CHARACTERISTIC is NULL" : "CHARACTERISTIC is NOT NULL");

        await device.writeCharacteristic(characteristic, motors[motorIndex],
            type: CharacteristicWriteType.withResponse);
        await Future.delayed(Duration(milliseconds: symbol.duration));
        await device.writeCharacteristic(
            characteristic, [0x00, 0x00, 0x00, 0x00],
            type: CharacteristicWriteType.withResponse);
        motorIndex++;
      }

      queue.removeFirst();
      _queueController.add(queue);
      playNextCharacterFromQueue();
    } else {
      currentlyPlaying = false;
    }
  }

  Future playMorseCharacter(index) async {
    MorseCharacter tappedCharacter = morseCharacters[index];
    queue.add(tappedCharacter);
    _queueController.add(queue);

    if (queue.length == 1) await Future.delayed(Duration(milliseconds: 300));

    if (!currentlyPlaying) playNextCharacterFromQueue();
  }
}

