import 'package:flutter/material.dart';
import 'package:news_app_demo/theme/colors.dart';

class Themes {
  static final ThemeData lightMode = ThemeData(
      appBarTheme: AppBarTheme(backgroundColor: blue),
      textTheme: TextTheme(
          titleSmall: TextStyle(color: black),
          titleMedium: TextStyle(color: black, fontWeight: FontWeight.bold)),
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
          primaryContainer: Color(0xFFE2E3DD),
          secondaryContainer: Color(0xFF649C9C),
          background: Colors.grey.shade50,
          primary: blue,
          secondary: black));
  static final ThemeData darkMode = ThemeData(
      appBarTheme: AppBarTheme(backgroundColor: const Color(0xFF226B98)),
      textTheme: TextTheme(
          titleSmall: TextStyle(color: white),
          titleMedium: TextStyle(color: white, fontWeight: FontWeight.bold)),
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
          primaryContainer: Color(0xFF82BE93),
          secondaryContainer: Color(0xFF217373),
          background: Colors.grey.shade900,
          primary: const Color(0xFF226B98),
          secondary: const Color(0xFFE3E3E3)));
}
