import 'package:openrgb/data/rgb_controller.dart';
import 'package:openrgb/openrgb.dart';

Future<void> main() async {
  final oRgb = await OpenRGBClient.connect('127.0.0.1', 6742);
  final count = await oRgb.getControllerCount();
  final controllers = <RGBController>[];
  for (int i = 0; i < count; i++) {
    final controller = await oRgb.getControllerData(i);
    controllers.add(controller);
  }
  await oRgb.setMode(1, controllers[0].modes[2]);
}
