import 'dart:typed_data';

import 'package:color/color.dart';
import 'package:openrgb/helpers/byte_data.dart';
import 'package:openrgb/openrgb.dart';

class RGBController {
  final String name;
  final String vendor;
  final String description;
  final String version;
  final String serial;
  final String location;
  final List<ModeData> modes;
  final List<ZoneData> zones;
  final List<LedData> leds;
  final List<Color> colors;

  const RGBController({
    required this.name,
    required this.vendor,
    required this.description,
    required this.version,
    required this.serial,
    required this.location,
    required this.modes,
    required this.zones,
    required this.leds,
    required this.colors,
  });

  factory RGBController.fromData(Uint8List data) {
    final buffer = data.buffer;
    ByteDataWrapper wrapper = ByteDataWrapper(ByteData.view(buffer));
    wrapper.extractUint32(); // Skip data size
    wrapper.extractUint32(); //Skip type
    final String name = wrapper.extractString();
    final String vendor = wrapper.extractString();
    final String description = wrapper.extractString();
    final String version = wrapper.extractString();
    final String serial = wrapper.extractString();
    final String location = wrapper.extractString();
    final int numModes = wrapper.extractUint16();
    wrapper.extractUint32(); // Skip active mode
    final List<ModeData> modes = <ModeData>[];
    for (int i = 0; i < numModes; i++) {
      ModeData modeData = ModeData.fromBuffer(wrapper);
      modes.add(modeData);
    }
    final int numZones = wrapper.extractUint16();
    final List<ZoneData> zones = <ZoneData>[];
    for (int i = 0; i < numZones; i++) {
      ZoneData zoneData = ZoneData.fromBuffer(wrapper);
      zones.add(zoneData);
    }
    final int numLeds = wrapper.extractUint16();
    final List<LedData> leds = <LedData>[];
    for (int i = 0; i < numLeds; i++) {
      LedData ledData = LedData.fromBuffer(wrapper);
      leds.add(ledData);
    }
    final int numColors = wrapper.extractUint16();
    final List<Color> colors = <Color>[];
    for (int i = 0; i < numColors; i++) {
      colors.add(Color.rgb(
        wrapper.extractUint8(),
        wrapper.extractUint8(),
        wrapper.extractUint8(),
      ));
      wrapper.extractUint8();
    }
    return RGBController(
      name: name,
      vendor: vendor,
      description: description,
      version: version,
      serial: serial,
      location: location,
      modes: modes,
      zones: zones,
      leds: leds,
      colors: colors,
    );
  }


  @override
  String toString() {
    return 'RGBController ==> name: $name, vendor: $vendor, description: $description, version: $version, serial: $serial, location: $location, modes: $modes, zones: $zones, leds: $leds, colors: $colors';
  }
}
