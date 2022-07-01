import 'dart:typed_data';
import 'dart:ui' show Color;

class DataMode {
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
  Color color;

  DataMode({
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
    required this.color,
  });

  factory DataMode.fromBuffer(Uint8List buffer) {
    throw UnimplementedError();
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
  int zoneMatrixData;

  ZoneData({
    required this.zoneName,
    required this.zoneType,
    required this.zoneLedsMin,
    required this.zoneLedsMax,
    required this.zoneLedsCount,
    required this.zoneMatrixHeight,
    required this.zoneMatrixWidth,
    required this.zoneMatrixData,
  });

  factory ZoneData.fromBuffer(Uint8List buffer) {
    throw UnimplementedError();
  }
}

class LedData {
  String ledName;
  int ledValue;

  LedData(this.ledName, this.ledValue);

  factory LedData.fromBuffer(Uint8List buffer) {
    throw UnimplementedError();
  }
}
