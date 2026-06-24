import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalCache {
  static const _ttl = Duration(hours: 1);

  static Future<void> set(String key, Object data) async {
    final prefs = await SharedPreferences.getInstance();
    final envelope = jsonEncode({
      'ts'  : DateTime.now().millisecondsSinceEpoch,
      'data': data,
    });
    await prefs.setString(key, envelope);
  }

  static Future<T?> get<T>(String key, T Function(dynamic json) fromJson) async {
    try {
      final prefs    = await SharedPreferences.getInstance();
      final raw      = prefs.getString(key);
      if (raw == null) return null;

      final envelope = jsonDecode(raw) as Map<String, dynamic>;
      final ts       = envelope['ts'] as int;
      final age      = DateTime.now().millisecondsSinceEpoch - ts;
      if (age > _ttl.inMilliseconds) return null;

      return fromJson(envelope['data']);
    } catch (_) {
      return null;
    }
  }

  static Future<void> clear(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    final keys  = prefs.getKeys().where((k) => k.startsWith('cache:')).toList();
    for (final k in keys) { await prefs.remove(k); }
  }
}
