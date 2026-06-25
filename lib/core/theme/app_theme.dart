import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static const _primary = Color(0xFFFF6452); // Inventix coral

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark  => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    final scheme  = ColorScheme.fromSeed(
      seedColor:  _primary,
      brightness: brightness,
      primary:    _primary,
      onPrimary:  Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor:
          isLight ? const Color(0xFFF6F6F9) : const Color(0xFF1A1A2E),

      // AppBar
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: isLight ? Colors.white : const Color(0xFF1E1E2E),
        foregroundColor: scheme.onSurface,
        systemOverlayStyle: isLight
            ? SystemUiOverlayStyle.dark
                .copyWith(statusBarColor: Colors.transparent)
            : SystemUiOverlayStyle.light
                .copyWith(statusBarColor: Colors.transparent),
        titleTextStyle: TextStyle(
          color: scheme.onSurface,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),

      // Kartlar — beyaz, hafif gölge
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: isLight ? Colors.white : const Color(0xFF252535),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        shadowColor: Colors.black.withOpacity(0.06),
      ),

      // Input — borderless Inventix stili
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isLight
            ? const Color(0xFFF0F0F5)
            : const Color(0xFF2A2A3E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        hintStyle:
            TextStyle(color: Colors.grey.shade400, fontSize: 14),
        labelStyle: TextStyle(color: Colors.grey.shade500),
      ),

      // FilledButton — pill şekli
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: _primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28)),
          padding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 24),
          textStyle: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),

      // ElevatedButton
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28)),
          padding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 24),
        ),
      ),

      // TextButton
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: _primary),
      ),

      // NavigationBar
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        backgroundColor:
            isLight ? Colors.white : const Color(0xFF1E1E2E),
        indicatorColor: _primary.withOpacity(0.12),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final base = const TextStyle(
              fontWeight: FontWeight.w500, fontSize: 11);
          if (states.contains(WidgetState.selected)) {
            return base.copyWith(
                fontWeight: FontWeight.w700, color: _primary);
          }
          return base.copyWith(color: Colors.grey.shade500);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: _primary, size: 24);
          }
          return IconThemeData(color: Colors.grey.shade500, size: 24);
        }),
      ),

      // Chip
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)),
        side: BorderSide.none,
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color:
            isLight ? Colors.grey.shade100 : Colors.grey.shade800,
        space: 1,
        thickness: 1,
      ),
    );
  }
}
