import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:openrgb/data/constants.dart';
import 'package:openrgb/data/rgb_controller.dart';
import 'package:openrgb/openrgb.dart';
import 'package:quiver/async.dart';

import 'data/command.dart';
import 'data/header.dart';

class OpenRGBClient {
  final Socket _socket;
  final StreamBuffer<int> _streamBuffer;
  late final int serverVersion;
  int controllerCount = 0;

  OpenRGBClient._(this._socket, this._streamBuffer);

  static Future<OpenRGBClient> connect(
    String host,
    int port, {
    String? clientName,
  }) async {
    var socket = await Socket.connect(host, port);
    var streamBuffer = StreamBuffer<int>();

    socket.cast<List<int>>().pipe(streamBuffer);
    var client = OpenRGBClient._(socket, streamBuffer);
    // Get Server version
    await client._send(
      CommandId.requestProtocolVersion,
      Uint8List.fromList([3, 0, 0, 0]),
    ); // V3
    final response = await client._receive();
    // Since it's LE, the first byte is the server's version.
    client.serverVersion = response.restOfPkt.first;
    // Send client name
    final Uint8List nameBytes;
    if (clientName != null) {
      nameBytes = ascii.encode('$clientName\x00');
    } else {
      nameBytes = ascii.encode('OpenRGB-dart\x00');
    }
    await client._send(CommandId.setClientName, nameBytes);

    return client;
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

  Future<RawNetPacket> _receive() async {
    // TODO: Make this another stream and queue messages in a streamqueue skipping server_only messages
    final buffer = await _streamBuffer.read(kHeaderLength);
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
      restOfPkt: Uint8List.fromList(await _streamBuffer.read(dataLength)),
    );
  }

  Future<int> getControllerCount() async {
    await _send(CommandId.requestControllerCount, Uint8List(0));

    final payload = await _receive();
    final payloadByteData = ByteData.sublistView(payload.restOfPkt);
    final count = payloadByteData.getUint32(0, Endian.little);
    controllerCount = count;
    return count;
  }

  Future<RGBController> getControllerData(int deviceId) async {
    if (deviceId >= controllerCount) {
      throw Exception('Device index out of range!');
    }
    await _send(
      CommandId.requestControllerData,
      Uint8List.fromList([3, 0, 0, 0]),
      deviceId: deviceId,
    );

    final payload = await _receive();
    return RGBController.fromData(payload.restOfPkt);
  }

  Future<bool> setMode(int deviceId, ModeData mode) async {
    if (deviceId >= controllerCount) {
      throw Exception('Device index out of range!');
    }
    try {
      await _send(
        CommandId.updateMode,
        mode.toBytes(),
        deviceId: deviceId,
      ).timeout(Duration(seconds: 1));
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
