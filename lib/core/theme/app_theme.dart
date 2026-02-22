import 'package:flutter/material.dart';

class AppTheme {
  // Brand colours
  static const Color brand = Color(0xFF1565C0);       // deep blue
  static const Color accent = Color(0xFFFFA000);      // amber
  static const Color success = Color(0xFF2E7D32);     // green
  static const Color danger = Color(0xFFC62828);      // red

  // Status badge colours
  static Color statusColor(String status) => switch (status) {
        'pending'     => const Color(0xFFFF8F00),
        'reviewing'   => const Color(0xFF1565C0),
        'confirmed'   => const Color(0xFF6A1B9A),
        'dispatched'  => const Color(0xFF00838F),
        'in_progress' => const Color(0xFF2E7D32),
        'completed'   => const Color(0xFF1B5E20),
        'cancelled'   => const Color(0xFF757575),
        _             => const Color(0xFF616161),
      };

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: brand,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: brand,
          foregroundColor: Colors.white,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12)),
          filled: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            backgroundColor: brand,
            foregroundColor: Colors.white,
          ),
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: brand,
          brightness: Brightness.dark,
        ),
      );
}