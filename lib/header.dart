import 'dart:convert';
import 'dart:typed_data';

import 'package:openrgb/constants.dart';

class RawNetPacket {
  final int deviceIndex;
  final int commandId;
  final Uint8List restOfPkt;

  const RawNetPacket({
    required this.deviceIndex,
    required this.commandId,
    required this.restOfPkt,
  });

  Uint8List toBytes() {
    //structure:
    //magic ID (4 bytes)
    //device index (4 bytes)
    //command ID (4 bytes)
    //data length (4 bytes)
    // data in pkg (variable)

    final buffer = Uint8List(kHeaderLength + restOfPkt.lengthInBytes);
    buffer.setRange(0, 4, ascii.encode(kHeaderMagic));
    final byteDataView = ByteData.view(buffer.buffer);
    byteDataView.setUint32(4, deviceIndex, Endian.little);
    byteDataView.setUint32(8, commandId, Endian.little);
    byteDataView.setUint32(12, restOfPkt.length, Endian.little);
    buffer.setRange(
      kHeaderLength,
      kHeaderLength + restOfPkt.lengthInBytes,
      restOfPkt,
    );
    return buffer;
  }
}
