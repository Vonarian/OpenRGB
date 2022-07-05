import 'dart:convert';
import 'dart:typed_data';

class ByteDataWrapper {
  final ByteData data;
  int _offset = 0;

  ByteDataWrapper(this.data);

  int get remainingBytes => data.lengthInBytes - _offset;

  int extractUint8() {
    final extractedValue = data.getUint8(_offset);
    _offset += 1;
    return extractedValue;
  }

  int extractUint16() {
    final extractedValue = data.getUint16(_offset, Endian.little);
    _offset += 2;
    return extractedValue;
  }

  int extractUint32() {
    final extractedValue = data.getUint32(_offset, Endian.little);
    _offset += 4;
    return extractedValue;
  }

  String extractString() {
    final length = extractUint16();
    final extractedValue =
        utf8.decode(data.buffer.asUint8List(_offset, length));
    _offset += length;
    return extractedValue;
  }
}
