import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

///App Themes
class Themes {
  ///Light Theme
  static ThemeData light = ThemeData.light().copyWith(
    scaffoldBackgroundColor: const Color(0xFFFAFAFA),
    colorScheme: const ColorScheme.light().copyWith(
      primary: const Color(0xFF24242C),
      secondary: const Color(0xFFE91E63),
    ),
    textTheme: GoogleFonts.poppinsTextTheme(),
  );

  ///Dark Theme
  static ThemeData dark = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: const Color(0xFF24242C),
    colorScheme: const ColorScheme.dark().copyWith(
      primary: const Color(0xFFFAFAFA),
      secondary: const Color(0xFF008080),
    ),
    textTheme: GoogleFonts.poppinsTextTheme(),
  );
}
