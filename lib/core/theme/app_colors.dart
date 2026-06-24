import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const MaterialColor success = MaterialColor(0xFF0AA553, {
    50:  Color(0xFFE2F4EA), 100: Color(0xFFB6E4CB),
    200: Color(0xFF85D2A9), 300: Color(0xFF54C087),
    400: Color(0xFF2FB36D), 500: Color(0xFF0AA553),
    600: Color(0xFF099D4C), 700: Color(0xFF079342),
    800: Color(0xFF058A39), 900: Color(0xFF037929),
  });

  static const MaterialColor error = MaterialColor(0xFFE0302A, {
    50:  Color(0xFFFBE6E5), 100: Color(0xFFF6C1BF),
    200: Color(0xFFF09895), 300: Color(0xFFE96E6A),
    400: Color(0xFFE54F4A), 500: Color(0xFFE0302A),
    600: Color(0xFFDC2B25), 700: Color(0xFFD8241F),
    800: Color(0xFFD31E19), 900: Color(0xFFCB130F),
  });

  static const MaterialColor warning = MaterialColor(0xFFED9200, {
    50:  Color(0xFFFDF2E0), 100: Color(0xFFFADEB3),
    200: Color(0xFFF6C980), 300: Color(0xFFF2B34D),
    400: Color(0xFFF0A226), 500: Color(0xFFED9200),
    600: Color(0xFFEB8A00), 700: Color(0xFFE87F00),
    800: Color(0xFFE57500), 900: Color(0xFFE06300),
  });

  static const MaterialColor info = MaterialColor(0xFF0278D6, {
    50:  Color(0xFFE1EFFA), 100: Color(0xFFB3D7F3),
    200: Color(0xFF81BCEB), 300: Color(0xFF4EA1E2),
    400: Color(0xFF288CDC), 500: Color(0xFF0278D6),
    600: Color(0xFF0270D1), 700: Color(0xFF0165CC),
    800: Color(0xFF015BC6), 900: Color(0xFF0148BC),
  });

  // Onay durumu rengi
  static Color get approved      => success.shade500;
  static Color get approvedBg    => success.shade50;
  static Color get pending       => warning.shade500;
  static Color get pendingBg     => warning.shade50;
  static Color get draft         => const Color(0xFF78909C);
  static Color get draftBg       => const Color(0xFFECEFF1);

  // Hata arkaplanı
  static Color get errorBg => error.shade50;
}
