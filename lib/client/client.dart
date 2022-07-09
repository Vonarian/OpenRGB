import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:color/color.dart';
import 'package:openrgb/data/constants.dart';
import 'package:openrgb/helpers/extensions.dart';
import 'package:openrgb/openrgb.dart';
import 'package:quiver/async.dart';

import '../data/command.dart';
import '../data/header.dart';

class OpenRGBClient {
  final Socket _socket;
  late final StreamQueue<RawNetPacket> _rx;
  late final StreamRouter<RawNetPacket> _router;

  /// Server version
  late final int serverVersion;

  /// Stream to listen to be notified of devices connection and disconnections.
  late final Stream<void> deviceListUpdated;

  int _controllerCount = 0;

  OpenRGBClient._(this._socket) {
    // Pipe the received data into the StreamBuffer.
    final streamBuffer = StreamBuffer<int>();
    _socket.cast<List<int>>().pipe(streamBuffer);
    // Decode the received messages in a raw packet stream.
    final receiveStream = _decodeLoop(streamBuffer);
    // Route the non-update packets out of [_rx] so we avoid a potential issue
    // with the client receiving unexpected data and breaking after a new device
    // is connected in the host machine.
    _router = StreamRouter(receiveStream);
    _rx = StreamQueue(
      _router.route((event) => event.commandId != CommandId.deviceListUpdated),
    );
    // Expose a stream of updates for API users to refresh their data.
    deviceListUpdated = _router.route(
      (event) => event.commandId == CommandId.deviceListUpdated,
    );
  }

  Future<void> _doHandshake(String? clientName) async {
    // Get Server version
    await _send(
      CommandId.requestProtocolVersion,
      Uint8List.fromList([3, 0, 0, 0]),
    ); // V3
    final response = await _rx.next;
    // Since it's LE, the first byte is the server's version.
    serverVersion = response.restOfPkt.first;
    // Send client name
    final Uint8List nameBytes;
    if (clientName != null) {
      nameBytes = ascii.encode('$clientName\x00');
    } else {
      nameBytes = ascii.encode('OpenRGB-dart\x00');
    }
    await _send(CommandId.setClientName, nameBytes);
  }

  ///First function to call to connect to the server.
  static Future<OpenRGBClient> connect({
    String host = '127.0.0.1',
    int port = 6742,
    String? clientName,
  }) async {
    final socket = await Socket.connect(host, port);
    final client = OpenRGBClient._(socket);
    await client._doHandshake(clientName);
    return client;
  }

  /// Disconnect from the server and close the socket.
  Future<void> disconnect() async {
    await _socket.close();
    await _rx.cancel();
    await _router.close();
  }

  Future<void> _send(int commandId, Uint8List data, {int deviceId = 0}) async {
    final pkt = RawNetPacket(
      deviceIndex: deviceId,
      commandId: commandId,
      restOfPkt: data,
    );
    _socket.add(pkt.toBytes());
    await _socket.flush();
  }

  static Stream<RawNetPacket> _decodeLoop(StreamBuffer<int> sb) async* {
    while (true) {
      final buffer = await sb.read(kHeaderLength);
      final headerData = Uint8List.fromList(buffer);
      if (ascii.decode(headerData.sublist(0, 4)) != kHeaderMagic) {
        throw Exception('Non-valid magic ID!');
      }

      final ByteData byteDataView = ByteData.sublistView(headerData, 4);

      final devIndex = byteDataView.getUint32(0, Endian.little);
      final commandId = byteDataView.getUint32(4, Endian.little);
      final dataLength = byteDataView.getUint32(8, Endian.little);

      yield RawNetPacket(
        deviceIndex: devIndex,
        commandId: commandId,
        restOfPkt: Uint8List.fromList(await sb.read(dataLength)),
      );
    }
  }

  /// Get the number of controllers connected to the server.
  Future<int> getControllerCount() async {
    await _send(CommandId.requestControllerCount, Uint8List(0));

    final payload = await _rx.next;
    final payloadByteData = ByteData.sublistView(payload.restOfPkt);
    final count = payloadByteData.getUint32(0, Endian.little);
    _controllerCount = count;
    return count;
  }

  /// Get controller data of one device with given [deviceId].
  Future<RGBController> getControllerData(int deviceId) async {
    if (_controllerCount == 0) {
      await getControllerCount();
    }
    if (deviceId >= _controllerCount) {
      throw Exception('Device index out of range!');
    }
    await _send(
      CommandId.requestControllerData,
      Uint8List.fromList([3, 0, 0, 0]),
      deviceId: deviceId,
    );

    final payload = await _rx.next;
    return RGBController.fromData(payload.restOfPkt);
  }

  /// Get controller data of all controllers.
  Future<List<RGBController>> getAllControllers() async {
    if (_controllerCount == 0) {
      await getControllerCount();
    }
    final controllers = <RGBController>[];
    for (int i = 0; i < _controllerCount; i++) {
      controllers.add(await getControllerData(i));
    }
    return controllers;
  }

  /// Sets a mode with given [modeId] on [deviceId]. [color] parameter does not always apply to all modes.
  Future<void> setMode(int deviceId, int modeID, Color color) async {
    RGBController targetController = await getControllerData(deviceId);
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
    final dataSize = Uint8List(4)..buffer.asByteData().setUint8(0, targetMode.toBytes().lengthInBytes + 84);
    bb.add(dataSize.toBytes());
    bb.add(modeID.toBytes());
    bb.add(targetMode.toBytes());
    await _send(
      CommandId.updateMode,
      bb.toBytes(),
      deviceId: deviceId,
    );
  }

  /// Updates all LEDs with one color.
  Future<void> updateLeds(int deviceId, int numColors, Color color) async {
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
    await _send(
      CommandId.updateLeds,
      bb.toBytes(),
      deviceId: deviceId,
    );
  }

  /// Sets the [color] of the given LED for the given [deviceId].
  Future<void> updateSingleLed(int deviceId, int ledID, Color color) async {
    if (deviceId >= _controllerCount) {
      throw Exception('Device index out of range!');
    }
    final bb = BytesBuilder();
    final ledIndexBytes = ledID.toBytes();
    bb.add(ledIndexBytes);
    final colorBytes = color.toBytes();
    bb.add(colorBytes);
    await _send(
      CommandId.updateSingleLed,
      bb.toBytes(),
      deviceId: deviceId,
    );
  }

  /// Sets custom mode for given [deviceId].
  /// Custom mode is a mode that allows you to set the colors of the LEDs individually (Depending on device's capabilities).
  Future<void> setCustomMode(int deviceId) async {
    if (deviceId >= _controllerCount) {
      throw Exception('Device index out of range!');
    }
    await _send(
      CommandId.setCustomMode,
      Uint8List(0),
      deviceId: deviceId,
    );
  }
}
