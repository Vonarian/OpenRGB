/// OpenRGB Dart Client to communiate with [OpenRGB](https://openrgb.org/) Server
/// This library supports all platforms that Dart is compatible with.
/// With this package, your Dart program can contorl RGB components through the server run on OpenRGB.
/// An async and a sync client are provided, read the example on how to use them.
library openrgb;

/// Clients
export 'client/client.dart';
export 'client/sync_client.dart';

/// Data structures
export 'data/data.dart';
export 'data/rgb_controller.dart';

/// Third-party packages
export 'package:color/color.dart';
