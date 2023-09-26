import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:color/color.dart';

import '../data/command.dart';
import '../data/constants.dart';
import '../data/header.dart';
import '../data/rgb_controller.dart';
import '../helpers/extensions.dart';

class OpenRGBSyncClient {
  final RawSynchronousSocket _socket;
  int _controllerCount = 0;
  late int serverVersion;

  OpenRGBSyncClient._(this._socket);

  ///First function to call to connect to the server.
  static OpenRGBSyncClient connect({
    String host = '127.0.0.1',
    int port = 6742,
    String? clientName,
  }) {
    final socket = RawSynchronousSocket.connectSync(host, port);
    final client = OpenRGBSyncClient._(socket);
    client._doHandshake(clientName);
    return client;
  }

  void _send(int commandId, Uint8List data, {int deviceId = 0}) {
    final pkt = RawNetPacket(
      deviceIndex: deviceId,
      commandId: commandId,
      restOfPkt: data,
    );
    _socket.writeFromSync(pkt.toBytes());
  }

  void _doHandshake(String? clientName) {
    // Get Server version
    _send(
      CommandId.requestProtocolVersion,
      Uint8List.fromList([3, 0, 0, 0]),
    ); // V3
    final response = readPkt();
    // Since it's LE, the first byte is the server's version.
    serverVersion = response.restOfPkt.first;
    // Send client name
    final Uint8List nameBytes;
    if (clientName != null) {
      nameBytes = ascii.encode('$clientName\x00');
    } else {
      nameBytes = ascii.encode('OpenRGB-dart\x00');
    }
    _send(CommandId.setClientName, nameBytes);
  }

  RawNetPacket readPkt() {
    final buffer = _socket.readSync(kHeaderLength)!;
    final headerData = Uint8List.fromList(buffer);
    if (ascii.decode(headerData.sublist(0, 4)) != kHeaderMagic) {
      throw Exception('Non-valid magic ID!');
    }

    final ByteData byteDataView = ByteData.sublistView(headerData, 4);

    final devIndex = byteDataView.getUint32(0, Endian.little);
    final commandId = byteDataView.getUint32(4, Endian.little);
    final dataLength = byteDataView.getUint32(8, Endian.little);

    return RawNetPacket(
      deviceIndex: devIndex,
      commandId: commandId,
      restOfPkt: Uint8List.fromList(_socket.readSync(dataLength)!),
    );
  }

  /// Get the number of controllers connected to the server.
  int getControllerCount() {
    _send(CommandId.requestControllerCount, Uint8List(0));

    final payload = readPkt();
    final payloadByteData = ByteData.sublistView(payload.restOfPkt);
    final count = payloadByteData.getUint32(0, Endian.little);
    _controllerCount = count;
    return count;
  }

  /// Get controller data of one device with given [deviceId].
  RGBController getControllerData(int deviceId) {
    if (_controllerCount == 0) {
      _controllerCount = getControllerCount();
    }
    if (deviceId >= _controllerCount) {
      throw Exception('Device index out of range!');
    }
    _send(
      CommandId.requestControllerData,
      Uint8List.fromList([3, 0, 0, 0]),
      deviceId: deviceId,
    );

    final payload = readPkt();
    return RGBController.fromData(payload.restOfPkt);
  }

  /// Get controller data of all controllers.
  List<RGBController> getAllControllers() {
    if (_controllerCount == 0) {
      _controllerCount = getControllerCount();
    }
    final controllers = <RGBController>[];
    for (int i = 0; i < _controllerCount; i++) {
      controllers.add(getControllerData(i));
    }
    return controllers;
  }

  /// Sets a mode with given [modeId] on [deviceId]. [color] parameter does not always apply to all modes.
  void setMode(int deviceId, int modeID, Color color) {
    RGBController targetController = getControllerData(deviceId);
    if (deviceId >= _controllerCount) {
      throw Exception('Device index out of range!');
    }
    var targetMode = targetController.modes[modeID];
    List<Color> colors = [];
    for (int i = 0; i < targetMode.modeNumColors; i++) {
      colors.add(color);
    }
    targetMode = targetMode.copyWith(colors: colors);

    final bb = BytesBuilder();
    final dataSize = Uint8List(4)
      ..buffer
          .asByteData()
          .setUint8(0, targetMode.toBytes().lengthInBytes + 84);
    bb.add(dataSize.toBytes());
    bb.add(modeID.toBytes());
    bb.add(targetMode.toBytes());
    _send(
      CommandId.updateMode,
      bb.toBytes(),
      deviceId: deviceId,
    );
  }

  /// Updates all LEDs with one color.
  void updateLeds(int deviceId, int numColors, Color color) {
    if (deviceId >= _controllerCount) {
      throw Exception('Device index out of range!');
    }
    final bb = BytesBuilder();
    bb.add(Uint8List(4)..buffer.asByteData().setUint32(0, 0, Endian.little));
    bb.add(numColors.toUint16Bytes());
    final colorBytes = color.toBytes();
    for (int i = 0; i < numColors; i++) {
      bb.add(colorBytes);
    }
    _send(
      CommandId.updateLeds,
      bb.toBytes(),
      deviceId: deviceId,
    );
  }

  /// Sets the [color] of the given LED for the given [deviceId].
  void updateSingleLed(int deviceId, int ledID, Color color) {
    if (deviceId >= _controllerCount) {
      throw Exception('Device index out of range!');
    }
    final bb = BytesBuilder();
    final ledIndexBytes = ledID.toBytes();
    bb.add(ledIndexBytes);
    final colorBytes = color.toBytes();
    bb.add(colorBytes);
    _send(
      CommandId.updateSingleLed,
      bb.toBytes(),
      deviceId: deviceId,
    );
  }

  /// Sets custom mode for given [deviceId].
  /// Custom mode is a mode that allows you to set the colors of the LEDs individually (Depending on device's capabilities).
  void setCustomMode(int deviceId) {
    if (deviceId >= _controllerCount) {
      throw Exception('Device index out of range!');
    }
    _send(
      CommandId.setCustomMode,
      Uint8List(0),
      deviceId: deviceId,
    );
  }

  void disconnect() {
    _socket.closeSync();
  }
}
