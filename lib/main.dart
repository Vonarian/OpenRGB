import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:openrgb/command.dart';
import 'package:openrgb/openrgb.dart';

Future<void> main() async {
  final process = await OpenRGB().test();
  Socket socket = await Socket.connect('127.0.0.1', 6742);
  socket.listen((Uint8List event) {
    var uInt32 = event.buffer.asUint32List();
    print(uInt32);
    print(ascii.decode(uInt32.sublist(0)));
  });
  socket.add(encode(0, 1, 0).buffer.asUint8List());
  process.kill();
}

final Uint8List magic = ascii.encode('ORGB');
Uint32List encode(int deviceId, int commandId, int length) =>
    Uint32List.fromList(
        [...magic.buffer.asUint32List(), deviceId, commandId, length]);

class NetPacketHeader {
  final String pkt_magic;
  final int pkt_dev_idx;
  final int pkt_id;
  final int pkt_size;
  final Command command;

  const NetPacketHeader({
    required this.pkt_magic,
    required this.pkt_dev_idx,
    required this.pkt_id,
    required this.pkt_size,
    required this.command,
  }) : assert(pkt_magic == 'ORGB', 'Non-valid magic ID!');

  factory NetPacketHeader.parse(Uint8List data) {
    final ByteData byteDataView = ByteData.sublistView(data);
    var index = 0;

    String takeString(int bytes) =>
        ascii.decode(data.sublist(index, index += 4));

    int takeUint32() {
      final int value = byteDataView.getUint32(index, Endian.little);
      index += 4;
      return value;
    }

    final pkt_magic = takeString(4);
    final pkt_dev_idx = takeUint32();
    final pkt_id = takeUint32();
    final pkt_size = takeUint32();
    final dataSegment = ByteData.sublistView(data, index, index + pkt_size);

    final Command command;
    if (pkt_id == NetPacketIdRequestControllerCount.id) {
      command = NetPacketIdRequestControllerCount.parse(dataSegment);
    } else {
      throw Exception('Unsupported pkt_id: $pkt_id');
    }

    return NetPacketHeader(
      pkt_magic: pkt_magic,
      pkt_dev_idx: pkt_dev_idx,
      pkt_id: pkt_id,
      pkt_size: pkt_size,
      command: command,
    );
  }
}
