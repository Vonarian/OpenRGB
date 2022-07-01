import 'dart:ffi';
import 'dart:ui';

class DataMode {
  int modeNameLength;
  String modeName;
  int modeValue;
  Uint8 modeFlags;
  Uint8 modeSpeedMin;
  Uint8 modeSpeedMax;
  Uint8 modeBrightnessMin;
  Uint8 modeBrightnessMax;
  Uint8 modeColorsMin;
  Uint8 modeColorsMax;
  Uint8 modeSpeed;
  Uint8 modeBrightness;
  Uint8 modeDirection;
  Uint8 modeColorMode;
  Uint8 modeNumColors;
  Color color;

  DataMode({
    required this.modeNameLength,
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
}

class ZoneData {
  Uint8 zoneNameLength;
  String zoneName;
  int zoneType;
  Uint8 zoneLedsMin;
  Uint8 zoneLedsMax;
  Uint8 zoneLedsCount;
  String zoneMatrixLength;
  Uint8 zoneMatrixHeight;
  Uint8 zoneMatrixWidth;
  Uint8 zoneMatrixData;

  ZoneData({
    required this.zoneNameLength,
    required this.zoneName,
    required this.zoneType,
    required this.zoneLedsMin,
    required this.zoneLedsMax,
    required this.zoneLedsCount,
    required this.zoneMatrixLength,
    required this.zoneMatrixHeight,
    required this.zoneMatrixWidth,
    required this.zoneMatrixData,
  });
}

class LedData {
  Uint8 ledNameLength;
  String ledName;
  Uint8 ledValue;

  LedData(this.ledNameLength, this.ledName, this.ledValue);
}
