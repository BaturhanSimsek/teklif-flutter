import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_provider.g.dart';

const _key = 'theme_mode';

@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  ThemeMode build() => ThemeMode.system;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    state = switch (saved) {
      'light'  => ThemeMode.light,
      'dark'   => ThemeMode.dark,
      _        => ThemeMode.system,
    };
  }

  Future<void> setMode(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, switch (mode) {
      ThemeMode.light  => 'light',
      ThemeMode.dark   => 'dark',
      ThemeMode.system => 'system',
    });
  }
}
