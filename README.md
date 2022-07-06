
# OpenRGB

OpenRGB Client written in pure Dart for the Dart programming language.

## Features

Communicate with the OpenRGB server to control the RGB LEDs.

## Installation

In the `dependencies:` section of your `pubspec.yaml`, add the following line:

```yaml
dependencies:
  openrgb: <latest_version>
```

## Usage

Connect to the OpenRGB server. Default value for the IP address is `127.0.0.1` and for the port
is `6742`. You can also set a custom client name, which is used to identify the client to the
server. Default value for the client name is `OpenRGB-dart`.

```dart
import 'package:openrgb/openrgb.dart';

Future<void> main() async {
  final oRgb = await OpenRGBClient.connect();
}
```

Get all controllers data

```dart

final controllersData = await oRgb.getAllControllerData();
```

Or get a specific controller data

```dart

final controllerData = await oRgb.getControllerData(controllerId);

```

Set a single LED's color

```dart
await oRgb.updateSingleLed(deviceId,ledID, color);
```

Or set all LEDs' colors

```dart
await oRgb.updateLeds(deviceId, numColors, color);
```

Set a mode for a device

```dart

final deviceId = 0;
final modeId = 2; // Depending on the device you want to set the mode for and available modes
await oRgb.setMode(deviceId, modeId, color);
```
