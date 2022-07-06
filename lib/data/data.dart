import 'dart:typed_data';

import 'package:color/color.dart';
import 'package:openrgb/helpers/extensions.dart';

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

  /// Returns byte data representing this [ModeData] using [BytesBuilder].
  Uint8List toBytes() {
    final builder = BytesBuilder();
    builder.add(modeName.toBytes());
    builder.add(modeValue.toBytes());
    builder.add(modeFlags.toBytes());
    builder.add(modeSpeedMin.toBytes());
    builder.add(modeSpeedMax.toBytes());
    builder.add(modeBrightnessMin.toBytes());
    builder.add(modeBrightnessMax.toBytes());
    builder.add(modeColorsMin.toBytes());
    builder.add(modeColorsMax.toBytes());
    builder.add(modeSpeed.toBytes());
    builder.add(modeBrightness.toBytes());
    builder.add(modeDirection.toBytes());
    builder.add(modeColorMode.toBytes());
    builder.add(modeNumColors.toUint16Bytes());
    for (int i = 0; i < modeNumColors; i++) {
      builder.add(colors[i].toBytes());
    }
    return builder.takeBytes();
  }

  @override
  String toString() {
    return 'ModeData{modeName: $modeName, modeValue: $modeValue, modeFlags: $modeFlags, modeSpeedMin: $modeSpeedMin, modeSpeedMax: $modeSpeedMax, modeBrightnessMin: $modeBrightnessMin, modeBrightnessMax: $modeBrightnessMax, modeColorsMin: $modeColorsMin, modeColorsMax: $modeColorsMax, modeSpeed: $modeSpeed, modeBrightness: $modeBrightness, modeDirection: $modeDirection, modeColorMode: $modeColorMode, modeNumColors: $modeNumColors, colors: $colors}';
  }

  ModeData copyWith({
    String? modeName,
    int? modeValue,
    int? modeFlags,
    int? modeSpeedMin,
    int? modeSpeedMax,
    int? modeBrightnessMin,
    int? modeBrightnessMax,
    int? modeColorsMin,
    int? modeColorsMax,
    int? modeSpeed,
    int? modeBrightness,
    int? modeDirection,
    int? modeColorMode,
    int? modeNumColors,
    List<Color>? colors,
  }) {
    return ModeData(
      modeName: modeName ?? this.modeName,
      modeValue: modeValue ?? this.modeValue,
      modeFlags: modeFlags ?? this.modeFlags,
      modeSpeedMin: modeSpeedMin ?? this.modeSpeedMin,
      modeSpeedMax: modeSpeedMax ?? this.modeSpeedMax,
      modeBrightnessMin: modeBrightnessMin ?? this.modeBrightnessMin,
      modeBrightnessMax: modeBrightnessMax ?? this.modeBrightnessMax,
      modeColorsMin: modeColorsMin ?? this.modeColorsMin,
      modeColorsMax: modeColorsMax ?? this.modeColorsMax,
      modeSpeed: modeSpeed ?? this.modeSpeed,
      modeBrightness: modeBrightness ?? this.modeBrightness,
      modeDirection: modeDirection ?? this.modeDirection,
      modeColorMode: modeColorMode ?? this.modeColorMode,
      modeNumColors: modeNumColors ?? this.modeNumColors,
      colors: colors ?? this.colors,
    );
  }

  bool get hasSpeed => modeSpeed == 1 << 0;
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
    late final int zoneMatrixHeight;
    late final int zoneMatrixWidth;
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
    final builder = BytesBuilder();
    builder.add(zoneName.toBytes());
    builder.add(zoneType.toBytes());
    builder.add(zoneLedsMin.toBytes());
    builder.add(zoneLedsMax.toBytes());
    builder.add(zoneLedsCount.toBytes());
    builder.add(zoneMatrixHeight.toBytes());
    builder.add(zoneMatrixWidth.toBytes());
    builder.add(zoneMatrix.toBytes());

    return builder.toBytes();
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
