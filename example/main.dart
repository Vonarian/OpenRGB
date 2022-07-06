import 'package:color/color.dart';
import 'package:openrgb/openrgb.dart';

Future<void> main() async {
  final oRgb = await OpenRGBClient.connect();
  List<RGBController> controllers = await oRgb.getAllControllers();
  Color color = const Color.rgb(255, 255, 255);
  await oRgb.updateSingleLed(2, 0, color);
}
