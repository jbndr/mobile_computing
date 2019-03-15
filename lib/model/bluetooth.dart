import 'dart:async';
import 'package:flutter_blue/flutter_blue.dart';

class Bluetooth {
  Bluetooth(
      this.device, this.service, this.characteristic, this.deviceConnection);

  Bluetooth.disconnect(this.device, this.service, this.characteristic);

  final BluetoothDevice device;
  final BluetoothService service;
  final BluetoothCharacteristic characteristic;
  StreamSubscription deviceConnection;

  void dispose() {
    deviceConnection?.cancel();
    deviceConnection = null;
  }
}
