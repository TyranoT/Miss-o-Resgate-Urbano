import 'package:flutter/material.dart';

/// Tema visual do SOS Cidade baseado em Material Design 3.
class AppTheme {
  static const Color _primaryColor = Color(0xFF1976D2);
  static const Color _criticalColor = Color(0xFFF44336);

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _primaryColor,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
        ),
      );

  static Color get criticalColor => _criticalColor;
}
