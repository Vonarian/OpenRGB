import 'package:color/color.dart';
import 'package:openrgb/openrgb.dart';

Future<void> main() async {
  final oRgb = await OpenRGBClient.connect('127.0.0.1', 6742);
  final count = await oRgb.getControllerCount();
  final controllers = <RGBController>[];
  for (int i = 0; i < count; i++) {
    final controller = await oRgb.getControllerData(i);
    controllers.add(controller);
  }
  final controller = controllers[2];
  await oRgb.updateLeds(2, controller.colors.length, Color.rgb(244, 244, 244));
  await Future.delayed(Duration(milliseconds: 100));
}
