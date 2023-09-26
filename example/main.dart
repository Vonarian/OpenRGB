import 'package:openrgb/openrgb.dart';

Future<void> main() async {
  // Async Client
  final asyncClient = await OpenRGBClient.connect();
  final controllers = await asyncClient.getAllControllers();
  print(controllers);
  // Sync Client
  final syncClient = OpenRGBSyncClient.connect();
  final syncControllers = syncClient.getAllControllers();
  print(syncControllers);
}
