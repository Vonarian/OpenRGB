import 'dart:convert';
import 'dart:typed_data';

import 'package:color/color.dart';

extension ToBytesInt on int {
  Uint8List toBytes() {
    final bytes = Uint8List(4);
    bytes.buffer.asByteData().setUint32(0, this, Endian.little);
    return bytes;
  }

  Uint8List toUint16Bytes() {
    final bytes = Uint8List(2);
    bytes.buffer.asByteData().setUint16(0, this, Endian.little);
    return bytes;
  }
}

extension ToStringBytes on String {
  Uint8List toBytes() {
    final bb = BytesBuilder();
    var encodedString = utf8.encode('$this\x00');
    var encodedLength = encodedString.length.toUint16Bytes();
    bb.add(encodedLength);
    bb.add(encodedString);
    return bb.toBytes();
  }
}

extension ToUint8List on List<int> {
  Uint8List toBytes() {
    final self = this;

    for (int i = 0; i < self.length; i++) {
      self[i].toBytes();
    }

    return (self is Uint8List) ? self : Uint8List.fromList(self);
  }
}

extension ColorToBytes on Color {
  /// Converts a color to a byte list using BytesBuilder returning a 4-byte list.
  Uint8List toBytes() {
    final bb = BytesBuilder();
    final rgbColor = toRgbColor();

    bb.addByte(rgbColor.r.toInt());
    bb.addByte(rgbColor.g.toInt());
    bb.addByte(rgbColor.b.toInt());
    bb.addByte(255);

    return bb.toBytes();
  }
}

extension NotNull on Object? {
  bool get hasValue => this != null;
}
