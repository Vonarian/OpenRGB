import 'package:openrgb/openrgb.dart';

Future<void> main() async {
  final oRgb = await OpenRGBClient.connect('127.0.0.1', 6742);
  final count = await oRgb.getControllerCount();
  final controllers = <RGBController>[];
  for (int i = 0; i < count; i++) {
    final controller = await oRgb.getControllerData(i);
    controllers.add(controller);
  }
  for (final controller in controllers) {
    for (final mode in controller.modes) {
      await oRgb.setMode(1, mode, 0);
    }
  }
}
