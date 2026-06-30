import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:safe_device/safe_device.dart';

class JailbreakService {
  Future<bool> isDeviceCompromised() async {
    if (kDebugMode) return false;
    if (!Platform.isAndroid && !Platform.isIOS) return false;
    try {
      return await SafeDevice.isJailBroken;
    } catch (_) {
      return false;
    }
  }
}
