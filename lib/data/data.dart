import 'dart:convert';
import 'dart:typed_data';

import 'package:color/color.dart';

import '../helpers/byte_data.dart';

class ModeData {
  String modeName;
  int modeValue;
  int modeFlags;
  int modeSpeedMin;
  int modeSpeedMax;
  int modeBrightnessMin;
  int modeBrightnessMax;
  int modeColorsMin;
  int modeColorsMax;
  int modeSpeed;
  int modeBrightness;
  int modeDirection;
  int modeColorMode;
  int modeNumColors;
  List<Color> colors;

  ModeData({
    required this.modeName,
    required this.modeValue,
    required this.modeFlags,
    required this.modeSpeedMin,
    required this.modeSpeedMax,
    required this.modeBrightnessMin,
    required this.modeBrightnessMax,
    required this.modeColorsMin,
    required this.modeColorsMax,
    required this.modeSpeed,
    required this.modeBrightness,
    required this.modeDirection,
    required this.modeColorMode,
    required this.modeNumColors,
    required this.colors,
  });

  factory ModeData.fromBuffer(ByteDataWrapper wrapper) {
    final modeName = wrapper.extractString();
    final modeValue = wrapper.extractUint32();
    final modeFlags = wrapper.extractUint32();
    final modeSpeedMin = wrapper.extractUint32();
    final modeSpeedMax = wrapper.extractUint32();
    final modeBrightnessMin = wrapper.extractUint32();
    final modeBrightnessMax = wrapper.extractUint32();
    final modeColorsMin = wrapper.extractUint32();
    final modeColorsMax = wrapper.extractUint32();
    final modeSpeed = wrapper.extractUint32();
    final modeBrightness = wrapper.extractUint32();
    final modeDirection = wrapper.extractUint32();
    final modeColorMode = wrapper.extractUint32();
    final modeNumColors = wrapper.extractUint16();
    final colors = <Color>[];
    for (int i = 0; i < modeNumColors; i++) {
      colors.add(Color.rgb(
        wrapper.extractUint8(),
        wrapper.extractUint8(),
        wrapper.extractUint8(),
      ));
      wrapper.extractUint8();
    }
    return ModeData(
      modeName: modeName,
      modeValue: modeValue,
      modeFlags: modeFlags,
      modeSpeedMin: modeSpeedMin,
      modeSpeedMax: modeSpeedMax,
      modeBrightnessMin: modeBrightnessMin,
      modeBrightnessMax: modeBrightnessMax,
      modeColorsMin: modeColorsMin,
      modeColorsMax: modeColorsMax,
      modeSpeed: modeSpeed,
      modeBrightness: modeBrightness,
      modeDirection: modeDirection,
      modeColorMode: modeColorMode,
      modeNumColors: modeNumColors,
      colors: colors,
    );
  }

  Uint8List toBytes() {
    List<int> bytes = [];
    final modeNameBytes = modeName.codeUnits;
    bytes.addAll(modeNameBytes);
    final modeValueBytes = Uint8List(4);
    modeValueBytes.buffer.asByteData().setUint32(0, modeValue);
    bytes.addAll(modeValueBytes);
    final modeFlagsBytes = Uint8List(4);
    modeFlagsBytes.buffer.asByteData().setUint32(0, modeFlags);
    bytes.addAll(modeFlagsBytes);
    final modeSpeedMinBytes = Uint8List(4);
    modeSpeedMinBytes.buffer.asByteData().setUint32(0, modeSpeedMin);
    bytes.addAll(modeSpeedMinBytes);
    final modeSpeedMaxBytes = Uint8List(4);
    modeSpeedMaxBytes.buffer.asByteData().setUint32(0, modeSpeedMax);
    bytes.addAll(modeSpeedMaxBytes);
    final modeBrightnessMinBytes = Uint8List(4);
    modeBrightnessMinBytes.buffer.asByteData().setUint32(0, modeBrightnessMin);
    bytes.addAll(modeBrightnessMinBytes);
    final modeBrightnessMaxBytes = Uint8List(4);
    modeBrightnessMaxBytes.buffer.asByteData().setUint32(0, modeBrightnessMax);
    bytes.addAll(modeBrightnessMaxBytes);
    final modeColorsMinBytes = Uint8List(4);
    modeColorsMinBytes.buffer.asByteData().setUint32(0, modeColorsMin);
    bytes.addAll(modeColorsMinBytes);
    final modeColorsMaxBytes = Uint8List(4);
    modeColorsMaxBytes.buffer.asByteData().setUint32(0, modeColorsMax);
    bytes.addAll(modeColorsMaxBytes);
    final modeSpeedBytes = Uint8List(4);
    modeSpeedBytes.buffer.asByteData().setUint32(0, modeSpeed);
    bytes.addAll(modeSpeedBytes);
    final modeBrightnessBytes = Uint8List(4);
    modeBrightnessBytes.buffer.asByteData().setUint32(0, modeBrightness);
    bytes.addAll(modeBrightnessBytes);
    final modeDirectionBytes = Uint8List(4);
    modeDirectionBytes.buffer.asByteData().setUint32(0, modeDirection);
    bytes.addAll(modeDirectionBytes);
    final modeColorModeBytes = Uint8List(4);
    modeColorModeBytes.buffer.asByteData().setUint32(0, modeColorMode);
    bytes.addAll(modeColorModeBytes);
    final modeNumColorsBytes = Uint8List(2);
    modeNumColorsBytes.buffer.asByteData().setUint16(0, modeNumColors);
    bytes.addAll(modeNumColorsBytes);
    final colorBytes = Uint8List(4 * modeNumColors);
    for (Color color in colors) {
      colorBytes.buffer.asByteData().setUint8(0, color
          .toRgbColor()
          .r
          .toInt());
      colorBytes.buffer.asByteData().setUint8(1, color
          .toRgbColor()
          .g
          .toInt());
      colorBytes.buffer.asByteData().setUint8(2, color
          .toRgbColor()
          .b
          .toInt());
      colorBytes.buffer.asByteData().setUint8(3, 0);
    }
    bytes.addAll(colorBytes);
    return Uint8List.fromList(bytes);
  }

  @override
  String toString() {
    return 'ModeData{modeName: $modeName, modeValue: $modeValue, modeFlags: $modeFlags, modeSpeedMin: $modeSpeedMin, modeSpeedMax: $modeSpeedMax, modeBrightnessMin: $modeBrightnessMin, modeBrightnessMax: $modeBrightnessMax, modeColorsMin: $modeColorsMin, modeColorsMax: $modeColorsMax, modeSpeed: $modeSpeed, modeBrightness: $modeBrightness, modeDirection: $modeDirection, modeColorMode: $modeColorMode, modeNumColors: $modeNumColors, colors: $colors}';
  }
}

class ZoneData {
  String zoneName;
  int zoneType;
  int zoneLedsMin;
  int zoneLedsMax;
  int zoneLedsCount;
  int zoneMatrixHeight;
  int zoneMatrixWidth;
  List<int> zoneMatrix;

  ZoneData({
    required this.zoneName,
    required this.zoneType,
    required this.zoneLedsMin,
    required this.zoneLedsMax,
    required this.zoneLedsCount,
    required this.zoneMatrixHeight,
    required this.zoneMatrixWidth,
    required this.zoneMatrix,
  });

  factory ZoneData.fromBuffer(ByteDataWrapper wrapper) {
    final zoneName = wrapper.extractString();
    final zoneType = wrapper.extractUint32();
    final zoneLedsMin = wrapper.extractUint32();
    final zoneLedsMax = wrapper.extractUint32();
    final zoneLedsCount = wrapper.extractUint32();
    final zoneMatrixLength = wrapper.extractUint16();
    late final zoneMatrixHeight;
    late final zoneMatrixWidth;
    final List<int> zoneMatrix = [];
    if (zoneMatrixLength != 0) {
      zoneMatrixHeight = wrapper.extractUint16();
      zoneMatrixWidth = wrapper.extractUint16();

      for (int i = 0; i < zoneMatrixHeight * zoneMatrixWidth; i++) {
        zoneMatrix.add(wrapper.extractUint32());
      }
    } else {
      zoneMatrixHeight = 0;
      zoneMatrixWidth = 0;
    }

    return ZoneData(
      zoneName: zoneName,
      zoneType: zoneType,
      zoneLedsMin: zoneLedsMin,
      zoneLedsMax: zoneLedsMax,
      zoneLedsCount: zoneLedsCount,
      zoneMatrixHeight: zoneMatrixHeight,
      zoneMatrixWidth: zoneMatrixWidth,
      zoneMatrix: zoneMatrix,
    );
  }

  Uint8List toBytes() {
    List<int> bytes = [];
    final zoneNameBytes = AsciiCodec().encode(zoneName);
    bytes.addAll(zoneNameBytes);
    final zoneTypeBytes = Uint8List(4);
    zoneTypeBytes.buffer.asByteData().setUint32(0, zoneType);
    bytes.addAll(zoneTypeBytes);
    final zoneLedsMinBytes = Uint8List(4);
    zoneLedsMinBytes.buffer.asByteData().setUint32(0, zoneLedsMin);
    bytes.addAll(zoneLedsMinBytes);
    final zoneLedsMaxBytes = Uint8List(4);
    zoneLedsMaxBytes.buffer.asByteData().setUint32(0, zoneLedsMax);
    bytes.addAll(zoneLedsMaxBytes);
    final zoneLedsCountBytes = Uint8List(4);
    zoneLedsCountBytes.buffer.asByteData().setUint32(0, zoneLedsCount);
    bytes.addAll(zoneLedsCountBytes);
    final zoneMatrixLengthBytes = Uint8List(2);
    zoneMatrixLengthBytes.buffer.asByteData().setUint16(0, zoneMatrix.length);
    bytes.addAll(zoneMatrixLengthBytes);
    if (zoneMatrix.length != 0) {
      final zoneMatrixHeightBytes = Uint8List(2);
      zoneMatrixHeightBytes.buffer.asByteData().setUint16(0, zoneMatrixHeight);
      bytes.addAll(zoneMatrixHeightBytes);
      final zoneMatrixWidthBytes = Uint8List(2);
      zoneMatrixWidthBytes.buffer.asByteData().setUint16(0, zoneMatrixWidth);
      bytes.addAll(zoneMatrixWidthBytes);
      for (int i = 0; i < zoneMatrix.length; i++) {
        final zoneMatrixBytes = Uint8List(4);
        zoneMatrixBytes.buffer.asByteData().setUint32(0, zoneMatrix[i]);
        bytes.addAll(zoneMatrixBytes);
      }
    }
    return Uint8List.fromList(bytes);
  }

  @override
  String toString() {
    return 'ZoneData{zoneName: $zoneName, zoneType: $zoneType, zoneLedsMin: $zoneLedsMin, zoneLedsMax: $zoneLedsMax, zoneLedsCount: $zoneLedsCount, zoneMatrixHeight: $zoneMatrixHeight, zoneMatrixWidth: $zoneMatrixWidth, zoneMatrix: $zoneMatrix}';
  }
}

class LedData {
  String ledName;
  int ledValue;

  LedData(this.ledName, this.ledValue);

  factory LedData.fromBuffer(ByteDataWrapper wrapper) {
    final ledName = wrapper.extractString();
    final ledValue = wrapper.extractUint32();
    return LedData(ledName, ledValue);
  }

  @override
  String toString() {
    return 'LedData ==> ledName: $ledName, ledValue: $ledValue';
  }
}
