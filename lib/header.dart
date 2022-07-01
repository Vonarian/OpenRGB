import 'dart:convert';
import 'dart:typed_data';

class NetPacketHeader {
  static const int headerLength = 16;
  static const String magic = 'ORGB';
  final int deviceIndex;
  final int commandId;
  final int dataLength;

  const NetPacketHeader({
    required this.deviceIndex,
    required this.commandId,
    required this.dataLength,
  });

  factory NetPacketHeader.parse(Uint8List data) {
    if (data.length != headerLength) {
      throw Exception('Invalid header length');
    }
    if (ascii.decode(data.sublist(0, 4)) != magic) {
      throw Exception('Non-valid magic ID!');
    }

    final ByteData byteDataView = ByteData.sublistView(data, 4);

    final devIndex = byteDataView.getUint32(0, Endian.little);
    final commandId = byteDataView.getUint32(4, Endian.little);
    final dataLength = byteDataView.getUint32(8, Endian.little);

    return NetPacketHeader(
      deviceIndex: devIndex,
      commandId: commandId,
      dataLength: dataLength,
    );
  }

  Uint8List toBytes() {
    //structure:
    //magic ID (4 bytes)
    //device index (4 bytes)
    //command ID (4 bytes)
    //data length (4 bytes)

    final buffer = Uint8List(headerLength);
    buffer.setRange(0, 4, ascii.encode(magic));
    final byteDataView = ByteData.view(buffer.buffer);
    byteDataView.setUint32(4, deviceIndex, Endian.little);
    byteDataView.setUint32(8, commandId, Endian.little);
    byteDataView.setUint32(12, dataLength, Endian.little);
    return buffer;
  }
}