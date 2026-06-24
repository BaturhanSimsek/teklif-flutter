import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';

class JailbreakService {
  Future<bool> isDeviceCompromised() async {
    if (kDebugMode) return false;
    if (!Platform.isAndroid && !Platform.isIOS) return false;
    try {
      return await FlutterJailbreakDetection.jailbroken;
    } catch (_) {
      return false;
    }
  }
}
