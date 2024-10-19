import 'package:flutter/material.dart';

ThemeData dark = ThemeData(
  fontFamily: 'Rubik',
  brightness: Brightness.dark,
  hintColor: const Color(0x80F9FAFA),
  shadowColor: const Color(0x80E8E8E8),
  primaryColor: const Color(0xFF02203A),
  //primaryColor: const Color(0xFF191B1D),
  primaryColorLight: const Color(0x80F9FAFA),
  highlightColor: const Color(0x80F9FAFA),
  focusColor: const Color(0xFF8D8D8D),
  dividerColor: const Color(0xFF2A2A2A),
  canvasColor: const Color(0xFF041524),
  cardColor: const Color(0x0DFFFFFF),

  colorScheme : const ColorScheme.dark(primary: Color(0xFF04446B),
    secondary: Color(0xFF0079E3),
    error:Color(0xFFCF6679),
    tertiary: Color(0xFF865C0A),
    tertiaryContainer: Color(0xFF3C5D96),
    onTertiaryContainer: Color(0xFF1A6483),
    primaryContainer: Color(0xFF208458),
    surface: Color(0xFF03335D),
    outline: Color(0xFF039D55),
    secondaryContainer: Color(0x80F9FAFA),),



  textTheme:  const TextTheme(
    labelLarge: TextStyle(color: Color(0x80F9FAFA)),
    displayLarge: TextStyle(fontWeight: FontWeight.w300, color: Color(0x80F9FAFA)),
    displayMedium: TextStyle(fontWeight: FontWeight.w400, color: Color(0x80F9FAFA)),
    displaySmall: TextStyle(fontWeight: FontWeight.w500, color: Color(0x80F9FAFA)),
    headlineMedium: TextStyle(fontWeight: FontWeight.w600, color: Color(0x80F9FAFA)),
    headlineSmall: TextStyle(fontWeight: FontWeight.w700, color: Color(0x80F9FAFA)),
    bodySmall: TextStyle(fontWeight: FontWeight.w900, color: Color(0x80F9FAFA)),
    titleMedium: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500, color: Color(0x80F9FAFA) ),
    bodyMedium: TextStyle(fontSize: 12.0, color: Color(0x80F9FAFA)),
    bodyLarge: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600, color: Color(0x80F9FAFA)),
  ),

  dialogTheme: const DialogTheme(
    surfaceTintColor: Color(0xFF02203A),
    shadowColor: Color(0x20454545),
  ),

);
