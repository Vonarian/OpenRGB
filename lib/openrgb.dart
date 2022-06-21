library openrgb;

import 'dart:developer';
import 'dart:io';

/// A Calculator.
class OpenRGB {
  Future<Process> test() async {
    try {
      var process = await Process.start(
          'C:\\Users\\vonar\\Desktop\\OpenRGB Windows 64-bit\\OpenRGB.exe',
          ['--server', '--noautoconnect']);
      return process;
    } catch (e, st) {
      log(e.toString(), stackTrace: st);
      rethrow;
    }
  }
}
