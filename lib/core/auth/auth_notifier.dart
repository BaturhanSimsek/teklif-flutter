import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_notifier.g.dart';

@Riverpod(keepAlive: true)
AuthNotifier authNotifier(AuthNotifierRef ref) => AuthNotifier();

class AuthNotifier extends ChangeNotifier {
  bool _authenticated = true;
  bool get isAuthenticated => _authenticated;

  void invalidate() {
    _authenticated = false;
    notifyListeners();
  }

  void restore() {
    _authenticated = true;
    notifyListeners();
  }
}
