import 'package:openrgb/openrgb.dart';

Future<void> main() async {
  final oRgb = await OpenRGBClient.connect('127.0.0.1', 6742);
  final count = await oRgb.getControllerCount();
  print(count);
}
