import 'dart:convert';
import 'dart:typed_data';

import 'package:openrgb/data.dart';

class Command {
  const Command();
}

class NetPacketIdRequestControllerCount extends Command {
  static const id = 0;
  final int numberOfControllersInTheDeviceList;

  const NetPacketIdRequestControllerCount({
    required this.numberOfControllersInTheDeviceList,
  });

  factory NetPacketIdRequestControllerCount.parse(ByteData data) =>
      NetPacketIdRequestControllerCount(
          numberOfControllersInTheDeviceList: data.getUint32(0, Endian.little));
}
//INCOMPLETE
class NetPacketIdRequestControllerData extends Command {
  static const id = 0;
  final int type;
  final int name_len;
  final String name;
  final int vendor_len;
  final int vendor;
  final int description_len;
  final String description;
  final int version_len;
  final String version;
  final int serial_len;
  final String serial;
  final int location_len;
  final int location;
  final int num_modes;
  final int active_mode;

  final DataMode dataMode;
  final int num_zones;
  final ZoneData zoneData;
  final int num_leds;
  final LedData ledData;
  final int num_colors;

  // INCOMPLETE ==> HAS ERRORS
  factory NetPacketIdRequestControllerData.parse(ByteData data) {
    return NetPacketIdRequestControllerData(type: data.superUint32(4), name_len: data.superUint32(4), name: data.ge, vendor_len: vendor_len, vendor: vendor, description_len: description_len, description: description, version_len: version_len, version: version, serial_len: serial_len, serial: serial, location_len: location_len, location: location, num_modes: num_modes, active_mode: active_mode, dataMode: dataMode, num_zones: num_zones, zoneData: zoneData, num_leds: num_leds, ledData: ledData, num_colors: num_colors)
  }

  const NetPacketIdRequestControllerData({
    required this.type,
    required this.name_len,
    required this.name,
    required this.vendor_len,
    required this.vendor,
    required this.description_len,
    required this.description,
    required this.version_len,
    required this.version,
    required this.serial_len,
    required this.serial,
    required this.location_len,
    required this.location,
    required this.num_modes,
    required this.active_mode,
    required this.dataMode,
    required this.num_zones,
    required this.zoneData,
    required this.num_leds,
    required this.ledData,
    required this.num_colors,
  });
}

extension on ByteData{
  int superUint32(int byteOffset){
    return getUint32(byteOffset, Endian.little);
  }
}